class CLI

	def splash
		puts <<-SPLASH.gsub /^\s*/, ''
		Hello! Welcome to your personal foodexplorer! 
		We're going to explore your kitchen and check out the nutritional facts for the products that we find! 
		Let's get started!
		SPLASH
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
			kitchen_splash
		elsif input.include? "item" || "product"
			products_splash
		else
			oops
			main_menu
		end
	end
	
############################
### KITCHEN MENU OPTIONS ###
############################

	def kitchen_splash
		puts "\nWelcome to the kitchen!"
		puts "I bet you don't even remember what you have in these cabinets!"
		puts "Time to explore!"
		kitchen_menu
	end

	def kitchen_menu
		puts "\nWould you like to Open a #{"New".on_green} cabinet or see your #{"Current".on_blue} cabinet(s)?"
		print "\n>> ".on_red
		input = gets.strip.downcase
		if input.include? "exit"
			goodbye
		elsif input.include? "new"
			puts "\nLet's do it!"
			new_cabinet
		elsif input.include? "cur"
			current_cabinets
		elsif input.include? "menu" || "back"
			main_menu
		else
			oops
			kitchen_menu
		end
	end

	def new_cabinet
		cabinet = Cabinet.new
		random_count = rand(0..3)
		if random_count == 0
			puts "\nUh oh! Looks like this cabinet is empty."
			puts "As a consolation prize, how about a bad joke?"
			puts API.joke
			kitchen_splash
		else
			final_count = Product.all.count + random_count
			loop do
				product = Product.create_new
				product.cabinet = cabinet.name # Establishing a belongs-to relationship
				break if Product.all.count == final_count
			end
			display_cabinet(cabinet.name) # Passes cabinet name to display_cabinet to eliminate repetitive code
		end
	end

	def display_cabinet(cabinet_name)
		puts "\nInside of #{cabinet_name} we have..."
		Product.all.each.with_index(1) do |product, index| 
			if product.cabinet == cabinet_name
				puts "\t #{index}. #{product.name}"
			end
		end
		cabinet_contents_query(cabinet_name)
	end

	def open_existing_cabinet(input)
		if input.include? "exit"
			goodbye
		elsif input.to_i.between?(1,999)
			if Product.all.count { |product, cabinet| product.cabinet == "Cabinet #{input}" } == 0
				puts "\n... oh no! This cabinet was empty."
				puts "Maybe we should check out a different cabinet."
				kitchen_menu
			else
				display_cabinet("Cabinet #{input}")
			end
		else
			oops
			open_current_cabinet_query
		end
	end

	def cabinet_contents_query(cabinet_name)
		puts "\nTo find out more information about an item, type the item number below. To go back, type #{"Back".on_red}."
		print "\n>> ".on_red
		input = gets.to_s.strip.downcase
		if input.include? "exit"
			goodbye
		elsif input.include? "back"
			puts "\nLet's head back to the kitchen."
			kitchen_splash
		elsif input == "1" || input == "2" || input == "3"
			selection = Product.all.select { |product, cabinet| product.cabinet == cabinet_name }[input.to_i-1]
			show_basic_info(selection)
		else
			oops
			cabinet_contents_query(cabinet_name)
		end
	end

	def current_cabinets
		puts "\nHere's a list of your current cabinet(s):"
		cabinet_list_all
	end

	def cabinet_list_all
		if Cabinet.all.length == 0
			puts "\nHmm. Looks like we haven't opened any cabinets yet."
			kitchen_menu
		else Cabinet.all.length > 0
			Cabinet.all.each { |cabinet| puts "\t [- #{cabinet.name} -]" }
			open_current_cabinet_query
		end
	end

	def open_current_cabinet_query
		puts "\nTo explore a cabinet, just type the number of the cabinet!"
		print "\n>> ".on_red
		input = gets.gsub("cabinet", "").strip.downcase
		open_existing_cabinet(input)
	end

############################
### PRODUCT MENU OPTIONS ###
############################

	def products_splash
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
		products_explore_query
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
			kitchen_splash
		elsif input.include? "no"
			puts "\nVery well then. Let's head back to the main menu."
			main_menu
		else
			oops
			create_new_product_from_cabinet_query
		end
	end
	
	def products_explore_query
		puts "\nTo find out more information about an item, type the item number below. To go back to the kitchen, type #{"Back".on_red}."
		print "\n>> ".on_red
		input = gets.strip.downcase
		if input.to_i == 0
			if input.to_s.include? "exit"
				goodbye
			elsif input.to_s.include? "back"
				puts "\nLet's head back to the kichen."
				kitchen_splash
			else
				oops
				products_explore_query
			end
		else
			selection = Product.all[input.to_i-1]
			if selection != nil
				show_basic_info(selection)
			else
				oops
				products_explore_query
			end
		end
	end

	def show_basic_info(selection)
		puts "\n#{selection.name} has #{selection.calories} calories and and looks like this:"
		puts "\t#{selection.image}".blue
		puts "#{selection.name} has an ID of #{selection.id} and can be found in #{selection.cabinet}."
		show_expanded_info_query(selection)
	end

	def show_expanded_info_query(selection)
		puts "\nWould you be interested in finding out some more?"
		puts "Type #{"Yes".on_green} or #{"No".on_red}."
		print "\n>> ".on_red
		input = gets.strip.downcase
		if input.include? "exit"
			goodbye
		elsif input.include? "yes"
			show_expanded_info(selection)
		elsif input.include? "no"
			puts "\nVery well then. Let's head back to the main menu."
			main_menu
		else
			oops
			show_expanded_info_query(selection)
		end
	end

	def show_expanded_info(selection)
		print "\nIt looks like a serving of this product contains "
		if selection.fat == nil
			puts "#{selection.carbs} of carbs and #{selection.protein} of protein."
		elsif selection.carbs == nil
			puts "#{selection.fat} of fat and #{selection.protein} of protein."
		elsif selection.protein == nil
			puts "#{selection.carbs} of carbs and #{selection.fat} of fat."
		else
			puts "#{selection.carbs} of carbs, #{selection.fat} of fat, and #{selection.protein} of protein."
		end
		puts "To purchase this product or continue your quest for info, head to:"
		puts "\thttps://google.com/search?q=#{selection.name.gsub(" ", "+")}".blue
		main_menu
	end

	def oops
		puts "\nOops.. I'm not sure I understood what you were trying to do."
	end

	def goodbye
		puts "\nWAIT! Before you go, here's a random food fact:"
		puts "\nDID YOU KNOW?!".blue
		puts API.trivia
		puts "\nHave an amazing day! We'll see you again soon!".on_red
		exit
	end

end