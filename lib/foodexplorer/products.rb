class Product
	attr_accessor :id, :name, :calories, :carbs, :fat, :protein, :image, :cabinet_name

	@@all = []

	def initialize(attribute_hash)
		attribute_hash.each { |key, value| self.send("#{key}=", value) } # Mass assignemnt
		@@all << self
	end

	def self.create_from_api
		attribute_hash = API.product_info
		Product.new(attribute_hash)
	end

	def self.all
		@@all
	end
end