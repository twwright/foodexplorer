require 'bundler/inline'

gemfile true do
 source 'http://rubygems.org'
 gem 'colorize'
 gem 'httparty'
end

require_relative "foodexplorer/CLI"
require_relative "foodexplorer/API"
require_relative "foodexplorer/cabinets"
require_relative "foodexplorer/products"
require_relative "foodexplorer/version"