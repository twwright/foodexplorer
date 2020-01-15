
class API
	include HTTParty
	@@api_root = "https://api.spoonacular.com/food"
	@@api_key = "?apiKey=9e4c58ce555c4046bab477e4741a7bbd"

	def self.product_info
		id = rand(99999)
		result_hash = HTTParty.get("#{@@api_root}/products/#{id}#{@@api_key}")
		if result_hash["status"] == 404 || result_hash["title"] == nil # Repeats if no product with ID from Spoonacular
			self.product_info
		else 
			product = {}
			product[:id] = result_hash["id"]
			product[:name] = result_hash["title"]
			product[:calories] = result_hash["nutrition"]["calories"].to_i #returns int
			product[:carbs] = result_hash["nutrition"]["carbs"] #returns string, use .gsub("g", "").to_i if wanting to do calculations in future
			product[:fat] = result_hash["nutrition"]["fat"] #returns string, use .gsub("g", "").to_i if wanting to do calculations in future
			product[:protein] = result_hash["nutrition"]["protein"] #returns string, use .gsub("g", "").to_i if wanting to do calculations in future
			product[:image] = result_hash["images"][1]
			product # Returns hash of selected attributes from Spoonacular
		end
	end

	def self.joke
		HTTParty.get("#{@@api_root}/jokes/random#{@@api_key}")["text"]
	end

	def self.trivia
		HTTParty.get("#{@@api_root}/trivia/random#{@@api_key}")["text"]
	end

end