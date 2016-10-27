module Crawler
  class Page
    attr_accessor :parent, :url, :links, :assets

    def initialize(parent: "root", url: nil, links: [], assets: [])
      @parent = parent
      @url = url
      @links = links
      @assets = assets
    end
  end
end
