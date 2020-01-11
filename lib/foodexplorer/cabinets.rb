class Cabinet
	attr_accessor :name

	@@all = []

	def initialize
		self.name = "Cabinet #{@@all.length + 1}"
		@@all << self
	end

	def self.all
		@@all
	end

end