class Product < CLI
	include HTTParty
	attr_accessor :id, :name, :calories, :carbs, :fat, :protein, :cabinet

	@@all = []

	def initialize(cabinet)
		create_new
		self.cabinet = cabinet
		@@all << self
		# self.name = result["title"]
		# self.calories = result["nutrition"]["calories"].to_i #returns int
		# self.carbs = result["nutrition"]["carbs"] #returns string, use .gsub("g", "").to_i if wanting to do calculations in future
		# self.fat = result["nutrition"]["fat"] #returns string, use .gsub("g", "").to_i if wanting to do calculations in future
		# self.protein = result["nutrition"]["protein"] #returns string, use .gsub("g", "").to_i if wanting to do calculations in future
	end
		
	def create_new
		result_hash = HTTParty.get("https://api.spoonacular.com/food/products/#{id = rand(99999)}?apiKey=6e81216fd91a43569ecbddbdcb495bbe")
		if result["code"] == ( 0 || 400 )
			self.id = id
			create_new
		else 
			assign_attr(result_hash)
		end
	end

	def assign_attr(result_hash)
		self.name = result["title"]
		self.calories = result["nutrition"]["calories"].to_i #returns int
		self.carbs = result["nutrition"]["carbs"] #returns string, use .gsub("g", "").to_i if wanting to do calculations in future
		self.fat = result["nutrition"]["fat"] #returns string, use .gsub("g", "").to_i if wanting to do calculations in future
		self.protein = result["nutrition"]["protein"] #returns string, use .gsub("g", "").to_i if wanting to do calculations in future
	end
end
=begin
		#Defining a method to try_again in case the first randomized key produces nil result, which would throw an error
		#Chose to use a new method called try_again rather than the same randomize method so that the traceback errors in bash would be explicit.
	def create_new(cabinet)
		random = rand(99999)
		result = HTTParty.get("https://api.spoonacular.com/food/products/#{random}?apiKey=6e81216fd91a43569ecbddbdcb495bbe")
		case result["code"]
		when 0
			binding.pry
		when 400
			binding.pry
		else
			self.cabinet = cabinet
		 	self.name = result["title"]
		 	self.calories = result["nutrition"]["calories"]#returns int
		 	self.carbs = result["nutrition"]["carbs"]#returns string, use .gsub("g", "").to_i if wanting to do calculations in future
		 	self.fat = result["nutrition"]["fat"]#returns string, use .gsub("g", "").to_i if wanting to do calculations in future
		 	self.protein = result["nutrition"]["protein"]#returns string, use .gsub("g", "").to_i if wanting to do calculations in future
			@@all << self
		 end
	end

	def show_info
		puts "#{self.name} is located in #{self.cabinet} and contains #{self.calories} calories."
		puts "It looks like a serving of this product contains #{self.carbs} of carbs, #{self.fat} of fat, and #{self.protein} of protein."
		sleep 1
		puts "Let's head back to the kitchen."
		main_menu
	end

	def self.all
		@@all
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

end