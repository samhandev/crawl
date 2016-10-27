require 'faraday'
require 'pp'

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
    end

    def execute
      process_scheduler
    end

    private
    attr_accessor :url_queue, :visited_urls, :queued_urls, :page_processor

    def process_scheduler
      puts "running the scheduler"
      while !@scheduler.empty?
        page = @scheduler.get_next
        processed_page = page_processor.process(page)
        visited_urls[processed_page.url] = processed_page
        @scheduler.add_page_links(page)
      end

      pp(visited_urls)
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
