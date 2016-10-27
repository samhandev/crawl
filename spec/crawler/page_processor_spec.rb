require 'spec_helper'

RSpec.describe Crawler::PageProcessor do
  describe "Processing the Page which includes extracting the links and assets" do
    it "should initialize with a link and asset extractor" do
      link_extractor = instance_double("LinkExtractor", :links => [])
      asset_extractor = instance_double("StaticAssetExtractor", :assets => [])
      http_client = instance_double("Faraday")
      processor = described_class.new(http_client: http_client, base_url: "base", link_extractor: link_extractor, asset_extractor: asset_extractor)
    end

    it "should process a page and extract the links and assets" do
      link_extractor = spy("LinkExtractor")
      asset_extractor = spy("StaticAssetExtractor")
      http_client = spy("Faraday")
      processor = described_class.new(http_client: http_client, base_url: "https://gocardless.com", link_extractor: link_extractor, asset_extractor: asset_extractor)
      page = Crawler::Page.new(url: "https://gocardless.com")

      processed_page = processor.process(page)

      expect(link_extractor).to have_received(:links).once
      expect(asset_extractor).to have_received(:assets).once
    end

    it "should prepend any relative links with the base url" do
      link_extractor = instance_double("LinkExtractor", :links => ["/about/", "https://gocardless.com/contactus"])
      asset_extractor = instance_double("StaticAssetExtractor", :assets => [])
      http_response = double("Response", :body => "test")
      http_client = double("Faraday", :get => http_response)
      processor = described_class.new(http_client: http_client, base_url: "https://gocardless.com", link_extractor: link_extractor, asset_extractor: asset_extractor)
      page = Crawler::Page.new(url: "https://gocardless.com")

      processed_page = processor.process(page)

      expect(processed_page.links).to include("https://gocardless.com/about/")
      expect(processed_page.links).to include("https://gocardless.com/contactus")
    end

    it "should handle utf-8 links" do
      link_extractor = instance_double("LinkExtractor", :links => ["/about/", "https://gocardless.com/contactus", "/es-es/faq/panel-control/creaci\u{f3}n-cobros/"])
      asset_extractor = instance_double("StaticAssetExtractor", :assets => [])
      http_response = double("Response", :body => "test")
      http_client = double("Faraday", :get => http_response)
      processor = described_class.new(http_client: http_client, base_url: "https://gocardless.com", link_extractor: link_extractor, asset_extractor: asset_extractor)
      page = Crawler::Page.new(url: "https://gocardless.com")

      processed_page = processor.process(page)

      expect(processed_page.links).to include("https://gocardless.com/about/")
      expect(processed_page.links).to include("https://gocardless.com/contactus")
    end

    it "should not prepend a link if it is a mailto email link" do
      link_extractor = instance_double("LinkExtractor", :links => ["mailto:help@domain.com"])
      asset_extractor = instance_double("StaticAssetExtractor", :assets => [])
      http_response = double("Response", :body => "test")
      http_client = double("Faraday", :get => http_response)
      processor = described_class.new(http_client: http_client, base_url: "https://gocardless.com", link_extractor: link_extractor, asset_extractor: asset_extractor)
      page = Crawler::Page.new(url: "https://gocardless.com")

      processed_page = processor.process(page)

      expect(processed_page.links).to include("mailto:help@domain.com")
    end
  end
end
