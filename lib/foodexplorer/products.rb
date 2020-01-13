class Product
	attr_accessor :id, :name, :calories, :carbs, :fat, :protein, :image, :cabinet_name

	@@all = []

	def initialize(attribute_hash)
		attributes.each { |key, value| product.send("#{key}=", value) } # Mass assignemnt
		@@all << self
	end

	def self.create_from_api # Single responsibility principle
		attribute_hash = API.product_info
		product = Product.new(attribute_hash)
	end

	def self.all
		@@all
	end
end