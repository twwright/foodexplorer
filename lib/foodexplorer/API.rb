class API
	include HTTParty
	API_ROOT = "https://api.spoonacular.com/food"
	API_KEY = "?apiKey=6e81216fd91a43569ecbddbdcb495bbe"

	def self.product_info
		id = rand(99999)
		product_json = HTTParty.get("#{API_ROOT}/products/#{id}#{API_KEY}")
		if result_json["code"] == 0 || result_json["code"] == 400
			self.product_info
		else 
			product_json
		end
	end

	def self.joke
		HTTParty.get("#{API_ROOT}/jokes/random#{API_KEY}")["text"]
	end

	def self.trivia
		HTTParty.get("#{API_ROOT}/trivia/random#{API_KEY}")["text"]
	end

end