=begin

##TODO: Add a User class that stores a user's fitness characteristics, calculates nutritional requirements,
##		retains data, allows logging of products into User when consumed, allows macronutrient tracking across multiple products

class User
	attr_accessor :first_name, :last_name, :age, :weight, :height, :metric, :activity_level, :goals, :macro_ratio
	@@all = []

	def initialize
		@@all << self
	end

	def macros
	end

end

=end