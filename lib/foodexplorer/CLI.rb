class CLI
	attr_accessor :selected_cabinet, :selected_product

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
		elsif input.include?("item") || input.include?("product")
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
		elsif input.include?("menu") || input.include?("back")
			main_menu
		else
			oops
			kitchen_menu
		end
	end

	def new_cabinet
		self.selected_cabinet = Cabinet.new
		random_count = rand(0..3)
		if random_count == 0
			puts "\nUh oh! Looks like this cabinet is empty."
			puts "As a consolation prize, how about a bad joke?"
			puts API.joke
			kitchen_menu
		else
			loop do
				product = Product.create_from_api
				self.selected_cabinet.product_list << product
				product.cabinet_name = self.selected_cabinet.name 
				break if self.selected_cabinet.product_list.count == random_count
			end
			display_cabinet
		end
	end

	def display_cabinet
		puts "\nInside of #{self.selected_cabinet.name} we have..."
		self.selected_cabinet.product_list.each.with_index(1) { |product, index| puts "\t #{index}. #{product.name}" }
		cabinet_contents_query
	end

	def cabinet_contents_query
		puts "\nTo find out more information about an item, type the item number below. To go back, type #{"Back".on_red}."
		print "\n>> ".on_red
		input = gets.to_s.strip.downcase
		if input.include? "exit"
			goodbye
		elsif input.include? "back"
			puts "\nLet's head back to the kitchen."
			kitchen_splash
		elsif input.include? "menu"
			main_menu
		elsif input == "1" || input == "2" || input == "3"
			self.selected_product = self.selected_cabinet.product_list[input.to_i-1]
			show_basic_info
		else
			oops
			cabinet_contents_query
		end
	end

	def current_cabinets
		puts "\nHere's a list of your current cabinet(s):"
		cabinet_list_all
	end

	def cabinet_list_all
		if Cabinet.all.length == 0
			puts "\nHmm. Looks like we haven't opened any cabinets yet!"
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
		if input.include? "exit"
			goodbye
		elsif input.include? "menu"
			main_menu
		elsif input.include? "back"
			kitchen_menu
		elsif input.to_i.between?(1,999)
			self.selected_cabinet = Cabinet.all[input.to_i-1]
			if self.selected_cabinet.product_list.count == 0
				puts "\n... oh no! This cabinet was empty."
				puts "Maybe we should check out a different cabinet."
				kitchen_menu
			else
				display_cabinet
			end
		else
			oops
			open_current_cabinet_query
		end
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
			@selected_product = Product.all[input.to_i-1]
			if @selected_product != nil
				show_basic_info
			else
				oops
				products_explore_query
			end
		end
	end

	def show_basic_info
		puts "\n#{self.selected_product.name} has #{self.selected_product.calories} calories and and looks like this:"
		puts "\t#{self.selected_product.image}".blue
		puts "#{self.selected_product.name} has an \#ID of #{self.selected_product.id} and can be found in #{self.selected_product.cabinet_name}."
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
			show_expanded_info
		elsif input.include? "no"
			puts "\nVery well then. Let's head back to the main menu."
			main_menu
		else
			oops
			show_expanded_info_query
		end
	end

	def show_expanded_info
		print "\nIt looks like a serving of this product contains "
		if self.selected_product.fat == nil
			puts "#{self.selected_product.carbs} of carbs and #{self.selected_product.protein} of protein."
		elsif self.selected_product.carbs == nil
			puts "#{self.selected_product.fat} of fat and #{self.selected_product.protein} of protein."
		elsif self.selected_product.protein == nil
			puts "#{self.selected_product.carbs} of carbs and #{self.selected_product.fat} of fat."
		else
			puts "#{self.selected_product.carbs} of carbs, #{self.selected_product.fat} of fat, and #{self.selected_product.protein} of protein."
		end
		puts "To purchase this product or continue your quest for info, head to:"
		puts "\thttps://google.com/search?q=#{self.selected_product.name.gsub(" ", "+")}".blue
		main_menu
	end

	def oops
		random = rand(0..5)
		if random == 1
			puts "\nOops.. I'm not sure I understood what you were trying to do."
		elsif random == 2
			puts "\nHmm.. looks like you're having a little trouble."
		elsif random == 3
			puts "\nOh no.. I don't think you entered a valid option."
		elsif random == 4
			puts "\nDarn.. you lost me. Let's try that again?"
		else
			puts "\nWhoops.. didn't catch that. Try again?"
		end
	end

	def goodbye
		puts "\nWAIT! Before you go, here's a random food fact:"
		puts "\nDID YOU KNOW?!".blue
		puts API.trivia
		puts "\nHave an amazing day! We'll see you again soon!".on_red
		exit
	end

end