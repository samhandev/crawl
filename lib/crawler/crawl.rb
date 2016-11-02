require 'faraday'
require 'pp'
require 'thread'
require 'json'

module Crawler
  class Crawl
    def initialize(url)
      @url = url
      @conn = Faraday.new
      @disallowed_paths = get_disallowed_paths
      #seed the intial url onto the queue
      @static_asset_extractor = StaticAssetExtractor.new
      @link_extractor = LinkExtractor.new
      @visited_urls = {}
      @scheduler = Scheduler.new(base_url: url, disallowed_paths: @disallowed_paths)
      @scheduler.add(url: url)
      @page_processor = PageProcessor.new(http_client: Faraday.new,
                                          base_url: url,
                                          link_extractor: LinkExtractor.new,
                                          asset_extractor: StaticAssetExtractor.new)
      @semaphore = Mutex.new
    end

    def execute
      process_scheduler

      pp(visited_urls)
      File.open("output.json", "w") do |f|
        f.write(visited_urls.to_json)
      end
      puts "Unique links visited: #{visited_urls.length}"
    end

    private
    attr_accessor :url_queue, :visited_urls, :queued_urls, :page_processor

    def process_scheduler
      # start threads to read and process from the schedule queued
      threads = []

      10.times do
        threads << Thread.new do
          puts "processing thread started..."
          thread_page_processor = PageProcessor.new(http_client: Faraday.new,
                                                     base_url: @url,
                                                     link_extractor: LinkExtractor.new,
                                                     asset_extractor: StaticAssetExtractor.new)
          loop do
            page = @scheduler.get_next
            processed_page = thread_page_processor.process(page)
            add_processed_page(processed_page)
            @scheduler.add_page_links(page)
          end
        end
      end

      #wait till all threads are finished
      while (@scheduler.num_waiting_threads < threads.count)
        sleep(1)
      end

      threads.each(&:exit)
      threads.each(&:join)

      visited_urls
    end

    def add_processed_page(page)
      @semaphore.synchronize {
        visited_urls[page.url] = page
      }

    end

    def get_disallowed_paths
      response = @conn.get(@url + "/robots.txt")
      return [] if response.status == 404
      robots_content = response.body
      robots_parser = RobotTxtParser.new(robots_content)
      robots_parser.disallowed << "/cdn-cgi"
    end
  end
end
