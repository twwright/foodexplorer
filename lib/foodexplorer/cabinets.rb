require 'pry'

class Cabinets < CLI
	attr_accessor :name


	@@all = {}

	def open
		self.name = "Cabinet #{@@all.length + 1}"
		cabinet = []
		random = rand(0..3)
		if random == 0
			puts "Uh oh! Looks like this cabinet is empty."
		else
			while cabinet.length < rand(1..3) do
			cabinet << Product.new
			end
		end
		@@all[self.name] = cabinet
		if cabinet.length == 3
			puts "Let's see what's in #{self.name}..."
			sleep 2
			puts "Looks like we have... #{"(1)".black.on_blue}. #{cabinet[0].name}, #{"(2)".black.on_blue}. #{cabinet[1].name}, and #{"(3)".black.on_blue}. #{cabinet[2].name}."
		elsif cabinet.length == 2
			puts "Let's see what's in #{self.name}..."
			sleep 2
			puts " Looks like we have... #{"(1)".black.on_blue}. #{cabinet[0].name}, and #{"(2)".black.on_blue}. #{cabinet[1].name}."
		else
			puts "Let's see what's in #{self.name}..."
			sleep 2
			puts " Hmm... not very full, is it? \n Looks like we just have #{"(1)".black.on_blue}. #{cabinet[0].name}."
		end
		sleep 1
		puts "To find out more information about an item, type the item number below. To back, type #{"Back".black.on_red}."
		input = gets.to_s.strip.downcase
		if input.include? "exit"
			goodbye
		elsif input.include? "back"
			puts "Let's head back to the kichen.\n"
			sleep 2
			kitchen
		elsif input == "1"
			cabinet[0].show_info
		elsif input == "2"
			cabinet[1].show_info
		elsif input == "3"
			cabinet[2].show_info
		else
			puts "\nOops.. I'm not sure I understood what you'd like to do. Let's head back to the main menu."
			sleep 2
			main_menu
	end

	def self.all
		@@all
	end

end