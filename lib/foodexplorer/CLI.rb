class CLI
	include HTTParty
	API_ROOT = "https://api.spoonacular.com/food"
	API_KEY = "?apiKey=6e81216fd91a43569ecbddbdcb495bbe"

	def begin
		main_intro
	end

	def main_intro
		puts <<-DOC.gsub /^\s*/, ''
			Hello! Welcome to your personal foodexplorer! 
			We're going to explore your kitchen and check out the nutritional facts for the products that we find! 
			Let's get started!
		DOC
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
		puts "\nTo see your current cabinets, enter the #{"Kitchen".on_blue}."
		puts "You can also jump right to a list of all of your products by typing #{"Items".on_blue}."
		puts "At any time typing #{"Exit".on_red} will leave... but we'll miss you."
		puts "So, what would you like to do?"
		print "\n>> ".on_red
		input = gets.strip.downcase
		if input.include? "exit"
			goodbye
		elsif input.include? "kit"
			kitchen_intro
		elsif input.include? "item" || "product"
			products_intro
		else
			puts "\nOops.. I'm not sure I understood what you'd like to do. Let's head back to the main menu."
			sleep 1
			main_menu
		end
	end
	
	def kitchen_intro
		puts "\nWelcome to the kitchen!"
		puts "I bet you don't even remember what you have in these cabinets!"
		puts "Time to explore!"
		cabinets_menu
	end

	def cabinets_menu
		puts "\nWould you like to Open a #{"New".on_green} cabinet or see your #{"Current".on_blue} cabinet(s)?"
		print "\n>> ".on_red
		input = gets.strip.downcase
		if input.include? "exit"
			goodbye
		elsif input.include? "new"
			puts "\nLet's do it!"
			open = Cabinets.new
		elsif input.include? "cur"
			current_cabinets
		elsif input.include? "menu" || "back"
			main_menu
		else
			puts "\nOops.. I'm not sure I understood what you'd like to do. Let's head back to the Main menu."
			sleep 1
			main_menu
		end
	end

	def current_cabinets
		puts "\nHere's a list of your current cabinets(s):"
		cabinets_list_all
	end

	def cabinets_list_all
		if Cabinets.all.length == 0
			create_new_cabinet_query
		elsif Cabinets.all.length > 0
			Cabinets.all.each { |cabinet| puts "\t [- #{cabinet.name} -]" }
			cabinets_explore_query
		else
			puts "\nWhoops. Looks like we might've encountered an error."
			cabinets_list_all
		end
	end

	def cabinets_explore_query
		puts "\nTo explore a cabinet, just type the number of the cabinet!"
		print "\n>> ".on_red
		input = gets.gsub("cabinet", "").strip.downcase
		open_existing_cabinet(input)
	end

	def open_existing_cabinet(input)
		if input.include? "exit"
			goodbye
		elsif input.to_i.between?(1,999)
			contents = Product.all.select { |product, cabinet| product.cabinet == "Cabinet #{input}" }
			puts "\nInside of Cabinet #{input} we have..."
			case contents.length
			when 0
				puts "... oh no! This cabinet was empty."
				puts "Maybe we should check out a different cabinet."
				cabinets_menu
			else
				contents.each.with_index(1) { |product, index| puts "\t #{index}. #{product.name}" }
			end
		else
			puts "\nOops.. I'm not sure I understood what you'd like to do."
			sleep 1
			cabinets_explore_query
		end
	end

	def create_new_cabinet_query
		puts "\nHmm. Looks like we haven't opened any cabinets yet."
		puts "Would you like to open one now? Type #{"Yes".on_green} or #{"No".on_red}."
		print "\n>> ".on_red
		input = gets.strip.downcase
		if input.include? "exit"
			goodbye
		elsif input.include? "yes"
			open = Cabinets.new
		elsif input.include? "no"
			puts "\nVery well then. Let's head back to the main menu."
			main_menu
		else
			puts "\nOops.. I'm not sure I understood what you'd like to do."
			sleep 1
			create_new_cabinet_query
		end
	end

	def products_intro
		puts "\nLet's take a look at all of the products in your kitchen!"
		products_list
	end

	def products_list
		if Product.all.length == 0
			create_new_product_from_cabinet_query
		elsif Product.all.length > 0
			list = Product.all
			list.each.with_index(1) { |product, index| puts "\t#{index}." + " #{product.name}" }
		end
		products_explore_query(list)
	end

	def create_new_product_from_cabinet_query
		puts "\nHmm. Looks like you don't have found any products yet."
		puts "Would you like to head to the kitchen to open a new cabinet?"
		puts "Type #{"Yes".on_green} or #{"No".on_red}."
		print "\n>> ".on_red
		input = gets.strip.downcase
		if input.include? "exit"
			goodbye
		elsif input.include? "yes"
			kitchen_intro
		elsif input.include? "no"
			puts "\nVery well then. Let's head back to the main menu."
			main_menu
		else
			puts "\nOops.. I'm not sure I understood what you'd like to do. Let's head back to the main menu."
			sleep 1
			main_menu
		end
	end
	
	def products_explore_query(list)
		puts "\nTo find out more information about an item, type the item number below. To go back to the kitchen, type #{"Back".on_red}."
		print "\n>> ".on_red
		input = gets.strip.downcase.to_i #Convert to integer; string will change to 0, convert back to string to check for chars
		case input
		when 0
			if input.to_s.include? "exit"
				goodbye
			elsif input.to_s.include? "back"
				puts "\nLet's head back to the kichen."
				sleep 1
				kitchen_intro
			else
				puts "\nOops.. I'm not sure I understood what you'd like to do."
				sleep 1
				products_explore_query(list)
			end
		else
			if list[input.to_i-1] != nil #As long as there's an item in the list with this index, display the info
				list[input.to_i-1].show_basic_info
			else
				puts "\nOops. Looks like we had trouble with that one. Maybe try again?"
				products_list
			end
		end
	end

	def goodbye
		puts "\nWAIT! Before you go, here's a random food fact:"
		puts "\nDID YOU KNOW?!".on_red
		puts HTTParty.get("#{API_ROOT}/trivia/random#{API_KEY}")["text"]
		puts "\nHave an amazing day! We'll see you again soon!"
		exit
	end

end