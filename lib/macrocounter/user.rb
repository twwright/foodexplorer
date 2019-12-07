class User
	attr_accessor :first_name, :last_name, :age, :weight, :height, :metric, :activity_level, :goals
	attr_reader :macro_ratio
	@@all = []

	def initialize
		@@all << self
	end

	def macros
	end

	
end