class Product < CLI
	include HTTParty
	attr_accessor :id, :name, :calories, :carbs, :fat, :protein, :cabinet

	@@all = []

	def initialize(cabinet)
		create_new
		self.cabinet = cabinet
		@@all << self
		# self.name = result_hash["title"]
		# self.calories = result_hash["nutrition"]["calories"].to_i #returns int
		# self.carbs = result_hash["nutrition"]["carbs"] #returns string, use .gsub("g", "").to_i if wanting to do calculations in future
		# self.fat = result_hash["nutrition"]["fat"] #returns string, use .gsub("g", "").to_i if wanting to do calculations in future
		# self.protein = result_hash["nutrition"]["protein"] #returns string, use .gsub("g", "").to_i if wanting to do calculations in future
	end
		
	def create_new
		self.id = rand(99999)
		result_hash = HTTParty.get("https://api.spoonacular.com/food/products/#{self.id}?apiKey=6e81216fd91a43569ecbddbdcb495bbe")
		if result_hash["code"] == ( 0 || 400 )
			print "..."
			create_new
		else 
			assign_attr(result_hash)
		end
	end

	def assign_attr(result_hash)
		self.name = result_hash["title"]
		self.calories = result_hash["nutrition"]["calories"].to_i #returns int
		self.carbs = result_hash["nutrition"]["carbs"] #returns string, use .gsub("g", "").to_i if wanting to do calculations in future
		self.fat = result_hash["nutrition"]["fat"] #returns string, use .gsub("g", "").to_i if wanting to do calculations in future
		self.protein = result_hash["nutrition"]["protein"] #returns string, use .gsub("g", "").to_i if wanting to do calculations in future
	end

	def show_basic_info
		puts "#{self.name} is located in #{self.cabinet} and contains #{self.calories} calories."
		puts "It looks like a serving of this product contains #{self.carbs} of carbs, #{self.fat} of fat, and #{self.protein} of protein."
		sleep 1
		puts "Let's head back to the kitchen."
		main_menu
	end

	def self.all
		@@all
	end
end

=begin
TODO: Manually allow user to create a product with input

def self.create(name:, calories:, carbs:, fat:, protein:)
		self.name = name
		self.calories = calories.gsub("g", "").to_i
		self.carbs = carbs.gsub("g", "").to_i
		self.fat = fat.gsub("g", "").to_i
		self.protein = protein.gsub("g", "").to_i
		@@all << self
	end
=end
