require 'uri'

module Crawler
  class PageProcessor
    def initialize(http_client:, base_url:, link_extractor: LinkExtractor.new, asset_extractor: StaticAssetExtractor.new)
      @http_client = http_client
      @base_url = base_url
      @link_extractor = link_extractor
      @asset_extractor = asset_extractor
    end

    def process(page)
      puts "processing: #{page.url}"
      response_body = http_client.get(page.url).body

      links = link_extractor.links(response_body)
      page.links = prepend_relative_urls(links)
      page.assets = asset_extractor.assets(response_body)
      page
    end

    private

    attr_accessor :link_extractor, :asset_extractor, :base_url, :http_client

    def prepend_relative_urls(links)
      links.map do |link|
        encoded_link = URI.encode(link)
        if (URI(encoded_link).host == nil)
          base_url + encoded_link
        else
          encoded_link
        end
      end
    end
  end
end
