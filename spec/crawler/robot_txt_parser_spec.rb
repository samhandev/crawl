require 'spec_helper'

RSpec.describe Crawler::RobotTxtParser do
  let(:sample_robots_txt) { File.open("spec/fixtures/robots.txt", 'rb').read }
  subject { described_class.new(sample_robots_txt)}
  it "Returns disallowed paths" do
    list_disallowed = subject.disallowed

    expect(list_disallowed.length).to eq(7)
  end
end
