require 'spec_helper'

RSpec.describe Crawler::Page do
  describe "Page" do

    it "allows you to create a Page object with just a url" do
      page = described_class.new(url: "https://gocardless.com")
    end

    it "defaults to a parent of root" do
      page = described_class.new(url: "https://gocardless.com")

      expect(page.parent).to eq("root")
    end
  end
end
