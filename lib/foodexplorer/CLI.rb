require "colorize"

class CLI

	def begin
		main_intro
	end

	def main_intro
		puts <<-DOC.gsub /^\s*/, ''
			Hello! Welcome to your personal foodexplorer! 
			We're going to explore your kitchen and check out the nutritional facts for the products that we find! 
			Let's get started!
		DOC
		sleep 1
		loading = 3
		print " L O A D I N G\n".red + "[---".red
		until loading == 0
			print "--".red
			sleep 1
			loading -= 1
		end
		puts "---]".red
		main_menu
	end

	def main_menu
		puts "To see your current cabinets, enter the #{"Kitchen".on_blue}."
		sleep 1
		puts "You can also jump right to a list of all of your products by typing #{"Items".on_blue}."
		sleep 1
		puts "At any time typing #{"Exit".on_red} will leave... but we'll miss you."
		sleep 1
		puts "So, what would you like to do?"
		input = gets.strip.downcase
		if input.include? "exit"
			goodbye
		elsif input.include? "kit"
			kitchen_intro
		elsif input.include? "item" || "product"
			products_intro
		else
			puts "Oops.. I'm not sure I understood what you'd like to do. Let's head back to the main menu."
			sleep 2
			main_menu
		end
	end

	def products_intro
		puts "Let's take a look at all of the products in your kitchen!"
		sleep 1
		products_list
	end

	def products_list
		if Product.all.length == 0
			puts "Hmm. Looks like you don't have found any products yet." 
			sleep 1
			puts "Would you like to head to the kitchen to open a new cabinet?"
			puts "Type #{"Yes".on_green} or #{"No".on_red}."
			input = gets.strip.downcase
			if input.include? "exit"
				goodbye
			elsif input.include? "yes"
				kitchen_intro
			elsif input.include? "no"
				puts "Very well then. Let's head back to the main menu."
				main_menu
			else
				puts "Oops.. I'm not sure I understood what you'd like to do. Let's head back to the main menu."
				sleep 2
				main_menu
			end
		elsif Product.all.length > 0
				list = Product.all
				list.each.with_index(1) { |product, index| puts "#{index}." + " #{product.name}" }
		end
		sleep 1
		puts "To find out more information about an item, type the item number below. To go back to the kitchen, type #{"Back".on_red}."
		input = gets.strip.downcase.to_i #Convert to integer; string will change to 0, convert back to string to check for chars
		case input
		when 0	
			if input.to_s.include? "exit"
				goodbye
			elsif input.to_s.include? "back"
				puts "Let's head back to the kichen."
				sleep 2
				kitchen_intro
			else
				puts "Oops.. I'm not sure I understood what you'd like to do. Let's head back to the main menu."
				sleep 2
				main_menu
			end
		else
			if list[input.to_i] != nil #As long as there's an item in the list with this index, display the info
				list[input.to_i].show_info
			else
				puts "Oops. Looks like we had trouble with that one. Maybe try again?"
				products_list
			end
		end
	end

	def kitchen_intro
		puts "Welcome to the kitchen! Here you'll find all of your cabinets, stocked and otherwise."
		puts "I bet you don't even remember what you have in here!"
		puts "Time to explore!"
		sleep 1
		kitchen_menu
	end

	def kitchen_menu
		puts "Would you like to Open a #{"New".on_green} cabinet or see your #{"Current".on_blue} cabinet(s)?"
		input = gets.strip.downcase
		if input.include? "exit"
			goodbye
		elsif input.include? "new"
			puts "Let's do it!"
			open = Cabinets.new
		elsif input.include? "cur"
			cabinets_intro
		elsif input.include? "menu" || "back"
			main_menu
		else
			puts "Oops.. I'm not sure I understood what you'd like to do. Let's head back to the Main menu."
			sleep 2
			main_menu
		end
	end

	def cabinets_intro
		puts "Here's a list of your current cabinets(s):"
		sleep 1
		cabinets_list
	end

	def cabinets_list
		if Cabinets.all.length == 0
			puts "Hmm. Looks like we haven't opened any cabinets yet."
			sleep 1
			puts "Would you like to open one now? Type #{"Yes".on_green} or #{"No".on_red}."
			input = gets.strip.downcase
			if input.include? "exit"
				goodbye
			elsif input.include? "yes"
				open = Cabinets.new
			elsif input.include? "no"
				puts "Very well then. Let's head back to the main menu."
				main_menu
			else
				puts "Oops.. I'm not sure I understood what you'd like to do. Let's head back to the main menu."
				sleep 2
				main_menu
			end
		elsif Cabinets.all.length > 0
			Cabinets.all.each { |cabinet| puts "[- #{cabinet.name} -]" }
			cabinets_explore
		else
			puts "Whoops. Looks like we might've encountered an error. Let's head back to the main menu."
			main_menu
		end
	end

	def cabinets_explore
		puts "To explore a cabinet, just type the number of the cabinet!"
		input = gets.gsub("cabinet", "").strip.downcase
		if input.include? "exit"
			goodbye
		elsif input.to_i.between?(1,999)
			list = Product.all.select { |product, cabinet| product.cabinet == "Cabinet #{input}" }
			puts "Inside of Cabinet #{input} we have..."
			case list.length
			when 0
				puts "... oh no! This cabinet was empty."
				puts "Maybe we should check out a different cabinet."
				kitchen_intro
			else
				list.each.with_index(1) { |product, index| puts "#{index}. #{product.name}" }
			end
		end
		sleep 1
		puts "To find out more information about an item, type the item number below. To go back, type #{"Back".on_red}."
		input = gets.to_s.strip.downcase
		if input.include? "exit"
			goodbye
		elsif input.include? "back"
			puts "Let's head back to the kitchen."
			sleep 2
			kitchen_intro
		elsif input == "1"
			list[0].show_info
		elsif input == "2"
			list[1].show_info
		elsif input == "3"
			list[2].show_info
		else
			puts "Oops.. I'm not sure I understood what you'd like to do. Let's head back to the main menu."
			sleep 2
			main_menu
		end
	end

	def goodbye
		puts "Have an amazing day! We'll see you again soon!".on_magenta
		sleep 1
		exit
	end

end