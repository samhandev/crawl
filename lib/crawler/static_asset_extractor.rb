require 'nokogiri'

module Crawler
  class StaticAssetExtractor
    def assets(html)
      @parsed_html = Nokogiri::HTML(html)
      get_link_static_assets.sort.uniq +
        get_script_static_assets.sort.uniq +
        get_image_static_assets.sort.uniq
    end

    private

    def get_image_static_assets
      image_assets = @parsed_html.css("img").map { |element| element["src"] }
      image_assets.reject { |asset| asset.nil? }
    end

    def get_script_static_assets
      filtered_script_elements = @parsed_html.css("script").reject do |element|
        element["src"].nil?
      end
      filtered_script_elements.map { |element| element["src"] }
    end


    def get_link_static_assets
      get_href_values(only_include_rel_of(["stylesheet",
                                           "icon"]))
    end

    def get_href_values(links)
      links.map { |element| element["href"] }
    end

    def only_include_rel_of(rel_types)
      all_links.select do |link|
        rel_types.include?(link["rel"])
      end
    end

    def all_links
      @parsed_html.css("link")
    end
  end
end
