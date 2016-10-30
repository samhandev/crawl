require 'uri'
require 'thread'

module Crawler
  class Scheduler
    def initialize(base_url:, disallowed_paths:)
      @base_url = base_url
      @disallowed_paths = disallowed_paths
      @queue = Queue.new
      @queued_urls = {}
      @semaphore = Mutex.new
    end

    def add_page_links(page)
      page.links.map do |link|
        add(url: link, parent: page.url)
      end
    end

    def add(url:, parent: "root")
      semaphore.synchronize {
        if can_queue_url?(url)
          queued_urls[url] = true
          queue.push(Page.new(url: url, parent: parent))
        end
      }
    end

    def get_next
      queue.pop
    end

    def empty?
      queue.empty?
    end

    def queue_length
      queue.length
    end

    def num_waiting_threads
      queue.num_waiting
    end

    private

    attr_accessor :queue, :queued_urls, :base_url, :semaphore

    def can_queue_url?(url)
      # add to the queue only if we have not previously queued
      # or the path is in the disallowed_paths list
      # or the url is not on our base_url domain
      queued_urls[url].nil? && url_host_matches?(url) && !url_path_in_disallowed?(url)
    end

    def url_host_matches?(url)
      URI(base_url).host == URI(url).host
    end

    def url_path_in_disallowed?(url)
      URI(url).path.start_with?(*@disallowed_paths)
    end
  end
end
