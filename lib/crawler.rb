lib = File.expand_path('../', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "crawler/crawl"
require "crawler/robot_txt_parser"
require "crawler/link_extractor"
require "crawler/static_asset_extractor"
require "crawler/scheduler"
require "crawler/page"
require "crawler/page_processor"
