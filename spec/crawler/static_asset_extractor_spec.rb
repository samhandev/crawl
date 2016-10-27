require 'spec_helper'

RSpec.describe Crawler::StaticAssetExtractor do
  let(:simple_html_page) { File.open("spec/fixtures/simple_html_page.html", "rb").read }
  let(:single_link_page) { File.open("spec/fixtures/single_link_page.html", "rb").read }

  it "should not find any static assets" do
    expect(subject.assets(simple_html_page)).to eq([])
  end

  it "should find the static assets from link elements" do
    expect(subject.assets(single_link_page)).to include("/bundle/main.css")
  end

  it "should not find static assets(single_link_page) from link elements that have rel of publisher" do
    expect(subject.assets(single_link_page)).not_to include("https://plus.google.com/+simple")
  end

  it "should include link elements with a rel of icon" do
    expect(subject.assets(single_link_page)).to include("/images/favicons/favicon-196x196.png")
  end

  it "should include script elements with a src attribute" do
    expect(subject.assets(single_link_page)).to include("/bundle/blah.js")
  end

  it "should detail with script elements that do not have a src attribute" do
    expect(subject.assets(single_link_page)).not_to include(nil)
  end

  it "should include img elements" do
    expect(subject.assets(single_link_page)).to include("/images/an-image.svg")
  end

  it "should filter out any images with out a src" do
    expect(subject.assets(single_link_page)).not_to include(nil)
  end
end
