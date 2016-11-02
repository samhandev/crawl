module Crawler
  class Page
    attr_accessor :parent, :url, :links, :assets

    def initialize(parent: "root", url: nil, links: [], assets: [])
      @parent = parent
      @url = url
      @links = links
      @assets = assets
    end

    def to_json(*a)
      { "parent" => parent, "url" => url, "links" => links, "assets" => assets}.to_json(*a)
    end
  end
end
