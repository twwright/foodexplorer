class Product
	attr_accessor :id, :name, :calories, :carbs, :fat, :protein, :image, :cabinet

	@@all = []

	def initialize
		@@all << self
	end

	def self.create_new # Single responsibility principle
		product = Product.new
		attributes = API.product_info
		attributes.each { |key, value| product.send("#{key}=", value) } # Mass assignemnt
		product
	end

	def self.all
		@@all
	end
end