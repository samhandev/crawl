module Crawler
  class RobotTxtParser
    def initialize(robots_txt_html)
      @robots_txt_html = robots_txt_html
    end

    def disallowed
      # filter out lines that begin with Disallow:
      filter_disallowed.map { |line| extract_path(line) }
    end

    private

    def extract_path(line)
      line.split(' ').last
    end

    def filter_disallowed
      @robots_txt_html.split("\n").select { |line| line.start_with?("Disallow:") }
    end
  end
end
