require 'spec_helper'

RSpec.describe Crawler::LinkExtractor do
  describe "no links" do
    let(:simple_html_page) { File.open("spec/fixtures/simple_html_page.html", "rb").read }
    let(:single_link_page) { File.open("spec/fixtures/single_link_page.html", "rb").read }


    it "should not find any links" do
      expect(subject.links(simple_html_page)).to eq([])
    end

    it "should find a link" do
      expect(subject.links(single_link_page)).to eq(["/link_a", "mailto:help@email.com"])
    end

    it "should ignore links beginning with #" do
      expect(subject.links(single_link_page)).not_to include("#features")
    end
  end
end
