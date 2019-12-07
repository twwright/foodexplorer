require 'httparty'
require 'pp'
require 'pry'

class Product
	include HTTParty
	attr_accessor :name, :calories, :carbs, :fat, :protein

	@@all = {}

	def initialize
			random = rand(99999)
			result = HTTParty.get("https://api.spoonacular.com/food/products/#{random}?apiKey=6e81216fd91a43569ecbddbdcb495bbe")
			self.name = result["title"]
			self.calories = result["nutrition"]["calories"].to_i
			self.carbs = result["nutrition"]["carbs"].gsub("g", "").to_i
			self.fat = result["nutrition"]["fat"].gsub("g", "").to_i
			self.protein = result["nutrition"]["protein"].gsub("g", "").to_i
			full_description = {
					"calories" => self.calories,
					"carbs" => self.carbs,
					"fat" => self.fat,
					"protein" => self.protein
				}
			@@all[self.name] = full_description
	end

	#TODO: Manually allow user to create a product with input
=begin
	def self.create(name:, calories:, carbs:, fat:, protein:)
		self.name = name
		self.calories = calories.gsub("g", "").to_i
		self.carbs = carbs.gsub("g", "").to_i
		self.fat = fat.gsub("g", "").to_i
		self.protein = protein.gsub("g", "").to_i
		full_description = {
				"calories" => self.calories,
				"carbs" => self.carbs,
				"fat" => self.fat,
				"protein" => self.protein
			}
		@@all[self.name] = full_description
	end
=end

	def self.all
		@@all
	end
end

=begin
"Open a new cabinet" Cabinet#open
1. Creates new cabinet object that contains an array of Grocery objects
2. Adds new grocery array to larger Cabinet.all list

"Report contents of all cabinets" Cabinet#all == Groceries.all


Cabinet.all == Product.all
Cabinet.new == generate three product object
=end