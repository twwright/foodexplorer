class Product
	attr_accessor :id, :name, :calories, :carbs, :fat, :protein, :cabinet

	@@all = []

	def initialize(cabinet_name)
		self.cabinet = cabinet_name
		product_json = API.product_info
		create_new(product_json)
		@@all << self
	end

	def create_new(product_json)
		self.id = product_json["id"]
		self.name = product_json["title"]
		self.calories = product_json["nutrition"]["calories"].to_i #returns int
		self.carbs = product_json["nutrition"]["carbs"] #returns string, use .gsub("g", "").to_i if wanting to do calculations in future
		self.fat = product_json["nutrition"]["fat"] #returns string, use .gsub("g", "").to_i if wanting to do calculations in future
		self.protein = product_json["nutrition"]["protein"] #returns string, use .gsub("g", "").to_i if wanting to do calculations in future
		self.image = product_json["images"][0]
	end

	def self.all
		@@all
	end
end