class CLI

	def begin
		splash
	end

	def splash
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
			kitchen_splash
		elsif input.include? "item" || "product"
			products_splash
		else
			puts "\nOops.. I'm not sure I understood what you'd like to do. Let's head back to the main menu."
			sleep 1
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
			cabinet_name = Cabinet.new.name # Might need to make this two method calls
			new_cabinet(cabinet_name)
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

	def new_cabinet(cabinet_name)
		random_count = rand(0..3)
		if random_count == 0
			puts "\nUh oh! Looks like this cabinet is empty."
			puts "As a consolation prize, how about a bad joke?"
			sleep 1
			puts API.joke
			@@all << self
			kitchen_splash
		else
			loop do
				Product.new(cabinet_name)
				break if Product.all.count { |product, cabinet| product.cabinet == "Cabinet #{cabinet_name}" } == random_count
			end
			display_cabinet(cabinet_name)
		end
	end

	def display_cabinet(cabinet_name)
		puts "\nInside of Cabinet #{cabinet_name} we have..."
		Product.all.each.with_index(1) { |product, index| puts "\t #{index}. #{product.name}" }
		cabinet_contents_query(cabinet_name)
	end

	def open_existing_cabinet(input)
		if input.include? "exit"
			goodbye
		elsif input.to_i.between?(1,999)
			if Product.all.count { |product, cabinet| product.cabinet == "Cabinet #{input}" } == 0
				puts "... oh no! This cabinet was empty."
				puts "Maybe we should check out a different cabinet."
				kitchen_menu
			else
				display_cabinet(input)
			end
		else
			puts "\nOops.. I'm not sure I understood what you'd like to do."
			sleep 1
			current_cabinet
		end
	end

	def cabinet_contents_query(cabinet_name)
		contents = Product.all.select { |product, cabinet| product.cabinet == "Cabinet #{input}" }
		puts "\nTo find out more information about an item, type the item number below. To go back, type #{"Back".on_red}."
		print "\n>> ".on_red
		input = gets.to_s.strip.downcase
		if input.include? "exit"
			goodbye
		elsif input.include? "back"
			puts "\nLet's head back to the kitchen."
			sleep 1
			kitchen_splash
		elsif input == "1"
			contents[0].show_basic_info
		elsif input == "2"
			contents[1].show_basic_info
		elsif input == "3"
			contents[2].show_basic_info
		else
			puts "\nOops.. I'm not sure I understood what you'd like to do. Let's try that again."
			sleep 1
			cabinet_contents_query(cabinet_name)
		end
	end

	def current_cabinets
		puts "\nHere's a list of your current cabinets(s):"
		cabinets_list_all
	end

	def cabinets_list_all
		if Cabinets.all.length == 0
			puts "\nHmm. Looks like we haven't opened any cabinets yet."
			kitchen_menu
		elsif Cabinets.all.length > 0
			Cabinets.all.each { |cabinet| puts "\t [- #{cabinet.name} -]" }
			open_current_cabinet_query
		else
			puts "\nWhoops. Looks like we might've encountered an error."
			cabinets_list_all
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

	def self.create_new_product_from_cabinet_query
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
	
	def self.products_explore_query(list)
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
				list[input.to_i-1].show_basic_info(id) #Do I need these IDs or do I just want it to pass itself???
			else
				puts "\nOops. Looks like we had trouble with that one. Maybe try again?"
				products_list
			end
		end
	end


	def self.show_basic_info(id)
		puts "\n#{id.name} is located in #{id.cabinet} and contains #{id.calories} calories."
		show_macros(id)
	end

	def self.show_macros(id)
		print "\nIt looks like a serving of this product contains "
		if self.fat == nil
			puts "#{id.carbs} of carbs and #{id.protein} of protein."
		elsif self.carbs == nil
			puts "#{id.fat} of fat and #{id.protein} of protein."
		elsif self.protein == nil
			puts "#{id.carbs} of carbs and #{id.fat} of fat."
		else
			puts "#{id.carbs} of carbs, #{id.fat} of fat, and #{id.protein} of protein."
		end
		show_expanded_info_query(id)
	end

	def self.show_expanded_info_query(id)
		puts "\nWould you be interested in finding out some more?"
		puts "Type #{"Yes".on_green} or #{"No".on_red}."
		print "\n>> ".on_red
		input = gets.strip.downcase
		if input.include? "exit"
			goodbye
		elsif input.include? "yes"
			show_expanded_info(id)
		elsif input.include? "no"
			puts "\nVery well then. Let's head back to the main menu."
			main_menu
		else
			puts "\nOops.. I'm not sure I understood what you'd like to do. Let's head back to the main menu."
			sleep 2
			main_menu
		end
	end

	def self.show_expanded_info(id)
		puts "\nThe Spoonacular code for #{id.name} is number #{id.id}."
		puts "Here's a picture of #{id.name}:\n#{id.image}"
		puts "To purchase or continue your quest for info, head over to https://google.com/search?q=#{self.name.gsub(" ", "+")}"
		sleep 1
		main_menu
	end

	def goodbye
		puts "\nWAIT! Before you go, here's a random food fact:"
		puts "\nDID YOU KNOW?!".on_red
		puts API.trivia
		puts "\nHave an amazing day! We'll see you again soon!"
		exit
	end

end