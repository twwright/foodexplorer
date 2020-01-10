require 'httparty'
require 'pp'
require 'colorize'
require_relative "foodexplorer/CLI"
require_relative "foodexplorer/version"
require_relative "foodexplorer/products"
require_relative "foodexplorer/cabinets"

module Foodexplorer
  class Error < StandardError; end
end
