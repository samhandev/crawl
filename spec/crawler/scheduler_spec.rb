require 'spec_helper'

RSpec.describe Crawler::Scheduler do
  describe "Decides if url is added to the queue based on disallowed and visited lists" do
    let(:subject) { described_class.new(base_url: "https://gocardless.com", disallowed_paths: ["/path/", "/path2/"]) }

    it "starts with nothing in it's queue" do
      expect(subject.empty?).to eq(true)
    end

    it "should add a page with the url into the queue" do
      expect(subject.empty?).to eq(true)
      expected_url = "https://gocardless.com/about"

      subject.add(url: expected_url)

      expect(subject.empty?).to eq(false)
      expect(subject.get_next.url).to eq(expected_url)
    end

    it "should not add the same url to the queue twice" do
      expected_url = "https://gocardless.com/about"

      subject.add(url: expected_url)
      expect(subject.queue_length).to eq(1)

      subject.add(url: expected_url)
      expect(subject.queue_length).to eq(1)
    end

    it "should not add a url if it is not on the same domain" do
      diff_url = "https://test.com"

      subject.add(url: diff_url)

      expect(subject.empty?).to eq(true)
    end

    it "should not add any links that are included in disallowed_paths" do
      disallowed_url_1 = "https://gocardless.com/path/"
      disallowed_url_2 = "https://gocardless.com/path2/"

      subject.add(url: disallowed_url_1)

      expect(subject.empty?).to eq(true)

      subject.add(url: disallowed_url_2)

      expect(subject.empty?).to eq(true)
    end

  end
end
