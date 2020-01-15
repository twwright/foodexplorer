class Cabinet
	attr_accessor :name, :product_list

	@@all = []

	def initialize
		self.name = "Cabinet #{@@all.length + 1}"
		self.product_list = []
		@@all << self
	end

	def self.all
		@@all
	end

end