require 'pry'
class API
	include HTTParty
	@@api_root = "https://api.spoonacular.com/food"
	@@api_key = "?apiKey=6e81216fd91a43569ecbddbdcb495bbe"

	def self.product_info
		id = rand(99999)
		result_hash = HTTParty.get("#{@@api_root}/products/#{id}#{@@api_key}")
		if result_hash["status"] == 404 # Repeats if no product with ID from Spoonacular
			binding.pry
			self.product_info
		else 
			product = {}
			product[:id] = result_hash["id"]
			product[:name] = result_hash["title"]
			product[:calories] = result_hash["nutrition"]["calories"].to_i #returns int
			product[:carbs] = result_hash["nutrition"]["carbs"] #returns string, use .gsub("g", "").to_i if wanting to do calculations in future
			product[:fat] = result_hash["nutrition"]["fat"] #returns string, use .gsub("g", "").to_i if wanting to do calculations in future
			product[:protein] = result_hash["nutrition"]["protein"] #returns string, use .gsub("g", "").to_i if wanting to do calculations in future
			product[:image] = "https://spoonacular.com/#{id}-636x393.jpg"
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

#https://api.spoonacular.com/food/products/99999?apiKey=6e81216fd91a43569ecbddbdcb495bbe
#result_hash = HTTParty.get("https://api.spoonacular.com/food/products/33495&limit=10?apiKey=6e81216fd91a43569ecbddbdcb495bbe").parsed_response