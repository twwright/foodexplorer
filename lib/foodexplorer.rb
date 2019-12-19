require 'httparty'
require 'pp'
require 'pry'
require_relative "foodexplorer/CLI"
require_relative "foodexplorer/version"
require_relative "foodexplorer/products"
#TODO: require_relative "foodexplorer/user"
require_relative "foodexplorer/cabinets"

module Foodexplorer
  class Error < StandardError; end
end
