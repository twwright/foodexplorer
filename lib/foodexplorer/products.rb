class Product < CLI
	include HTTParty

	attr_accessor :id, :name, :calories, :carbs, :fat, :protein, :cabinet

	@@all = []

	def initialize(cabinet)
		self.cabinet = cabinet
		create_new
		@@all << self
	end
		
	def create_new
		self.id = rand(99999)
		result_hash = HTTParty.get("#{API_ROOT}/products/#{self.id}#{API_KEY}")
		if result_hash["code"] == ( 0 || 400 )
			create_new
		else 
			assign_attr(result_hash)
		end
	end

	def assign_attr(result_hash)
		self.name = result_hash["title"]
		self.calories = result_hash["nutrition"]["calories"].to_i #returns int
		self.carbs = result_hash["nutrition"]["carbs"] #returns string, use .gsub("g", "").to_i if wanting to do calculations in future
		self.fat = result_hash["nutrition"]["fat"] #returns string, use .gsub("g", "").to_i if wanting to do calculations in future
		self.protein = result_hash["nutrition"]["protein"] #returns string, use .gsub("g", "").to_i if wanting to do calculations in future
	end

	def show_basic_info
		puts "\n#{self.name} is located in #{self.cabinet} and contains #{self.calories} calories."
		show_macros	
	end

	def show_macros
		print "\nIt looks like a serving of this product contains "
		if self.fat == nil
			puts "#{self.carbs} of carbs and #{self.protein} of protein."
		elsif self.carbs == nil
			puts "#{self.fat} of fat and #{self.protein} of protein."
		elsif self.protein == nil
			puts "#{self.carbs} of carbs and #{self.fat} of fat."
		else
			puts "#{self.carbs} of carbs, #{self.fat} of fat, and #{self.protein} of protein."
		end
		show_expanded_info_query
	end

	def show_expanded_info_query
		puts "\nWould you be interested in finding out some more?"
		puts "Type #{"Yes".on_green} or #{"No".on_red}."
		print "\n>> ".on_red
		input = gets.strip.downcase
		if input.include? "exit"
			goodbye
		elsif input.include? "yes"
			show_expanded_info(self.id)
		elsif input.include? "no"
			puts "\nVery well then. Let's head back to the main menu."
			main_menu
		else
			puts "\nOops.. I'm not sure I understood what you'd like to do. Let's head back to the main menu."
			sleep 2
			main_menu
		end
	end

	def show_expanded_info(id)
		result_obj = HTTParty.get("#{API_ROOT}/products/#{id}#{API_KEY}")
		puts "\nThe Spoonacular code for #{self.name} is number #{self.id}."
		puts "Here's a picture of #{self.name}:\n#{result_obj["images"][0]}"
		puts "To purchase or continue your quest for info, head over to https://google.com/search?q=#{self.name.gsub(" ", "+")}"
		sleep 1
		main_menu
	end

	def self.all
		@@all
	end
end