require 'nokogiri'

module Crawler
  class LinkExtractor
    def links(html)
      @parsed_html = Nokogiri::HTML(html)
      filter_out_links(all_hrefs).sort.uniq
    end

    private

    def all_hrefs
      @parsed_html.css("a").map { |element| element["href"] }
    end

    def filter_out_links(links)
      links.reject do |link|
        link == nil || link.start_with?("#")
      end
    end
  end
end
