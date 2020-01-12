require 'pry'
class API
	include HTTParty
	API_ROOT = "https://api.spoonacular.com/food"
	API_KEY = "?apiKey=6e81216fd91a43569ecbddbdcb495bbe"

	def self.product_info
		id = rand(99999)
		json = HTTParty.get("#{API_ROOT}/products/#{id}#{API_KEY}")
		if json["code"] == 0 || json["code"] == 400
			binding.pry
			self.product_info # Repeats if error with the random ID from Spoonacular
		else 
			product = {}
			product[:id] = json["id"]
			product[:name] = json["title"]
			product[:calories] = json["nutrition"]["calories"].to_i #returns int
			product[:carbs] = json["nutrition"]["carbs"] #returns string, use .gsub("g", "").to_i if wanting to do calculations in future
			product[:fat] = json["nutrition"]["fat"] #returns string, use .gsub("g", "").to_i if wanting to do calculations in future
			product[:protein] = json["nutrition"]["protein"] #returns string, use .gsub("g", "").to_i if wanting to do calculations in future
			product[:image] = json["images"][0]
			product # Returns hash of selected attributes from Spoonacular
		end
	end

	def self.joke
		HTTParty.get("#{API_ROOT}/jokes/random#{API_KEY}")["text"]
	end

	def self.trivia
		HTTParty.get("#{API_ROOT}/trivia/random#{API_KEY}")["text"]
	end

end