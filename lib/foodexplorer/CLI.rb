require "colorize"
require "pry"

class CLI

	def begin
		main_intro
	end

	def main_intro
		puts <<-DOC.gsub /^\s*/, ''
			Hello! Welcome to your personal macrocounter!
			A macronutrient, or 'macro' for short, is a fundamental building block of nutrition. 
			We're going to explore your kitchen and check out the nutritional facts for your current groceries! 
			Let's get started!
		DOC
		sleep 1
		loading = 3
		print "\nLOADING\n[--" 
		until loading == 0
			print "--"
			sleep 1
			loading -= 1
		end
		print "--]\n\n"
		main_menu
	end

	def main_menu
		puts "To see your current cabinets, enter #{"Kitchen".black.on_blue}."
		sleep 1
		puts "You can also jump right to your products by typing #{"Items".black.on_blue}."
		sleep 1
		puts "At any time typing #{"Exit".black.on_red} will leave... but we'll miss you."
		sleep 1
		puts "So, what would you like to do?"
		input = gets.strip.downcase
		if input.include? "exit"
			goodbye
		elsif input.include? "kit"
			kitchen_intro
		elsif input.include? "pro"
			products_intro
		else
			puts "\nOops.. I'm not sure I understood what you'd like to do. Let's head back to the main menu."
			sleep 2
			main_menu
		end
	end

	def back_prompt
		puts "Would you like to head back to your #{"Cabinets".black.on_blue}, the #{"Kitchen".black.on_blue}, or the Main #{"Menu".black.on_blue}?"
		input = gets.strip.downcase
			if input.include? "exit"
				goodbye
			elsif input.include? "kit"
				kitchen_intro
			elsif input.include? "cab"
				cabinet_intro
			else
				puts "\nOops.. I'm not sure I understood what you'd like to do. Let's head back to the main menu."
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
			puts "Hmm. Looks like you don't have found any products yet.\n 
			Would you like to head to the kitchen to check out some cabinets?\n
			Type #{"Yes".black.on_green} or #{"No".black.on_red}."
			input = gets.strip.downcase
			if input.include? "exit"
				goodbye
			elsif input.include? "yes"
				cabinet_intro
			elsif input.include? "no"
				puts "\nVery well then. Let's head back to the main menu."
				main_menu
			else
				puts "\nOops.. I'm not sure I understood what you'd like to do. Let's head back to the main menu."
				sleep 2
				main_menu
			end
		elsif Product.all.length > 0
			Product.all.each {} |index, product| puts "\n#{index + 1}. #{product[index].name}" }
			product_explore
		else
			puts "\nOops.. I'm not sure I understood what you'd like to do. Let's head back to the main menu."
			sleep 2
			main_menu
		end
	end

	def product_explore
		puts "\nTo see the nutritional facts of a product, type the number of the product below."
		input = gets.strip.downcase
		if input.include? "exit"
			goodbye
		elsif input.to_i.between(1,999)
			puts Product.all[input - 1].show_info
		else
			puts "\nOops.. I'm not sure I understood what you'd like to do. Let's head back to the main menu."
			sleep 2
			main_menu
		end
	end

	def kitchen_intro
		<<-DOC.gsub /^\s*/, ''
		Welcome to the kitchen! Here you'll find all of your cabinets, stocked and otherwise.
		I bet you don't even remember what you have in here!
		Let's explore what you have around here.
		DOC
		sleep 1
		kitchen_menu
	end

	def kitchen_menu
		puts "Would you like to Open a #{"New".black.on_green} cabinet or see your #{"Current".black.on_blue} cabinet(s)?"
		input = gets.strip.downcase
		if input.include? "exit"
			goodbye
		elsif input.include? "new"
			puts "Let's do it!"
			Cabinet.new
		elsif input.include? "cur"
			cabinet_intro
		elsif input.include? "menu" || "back"
			main_menu
		else
			puts "\nOops.. I'm not sure I understood what you'd like to do. Let's head back to the Kitchen menu."
			sleep 2
			kitchen_menu
		end
	end

	def cabinet_intro
		puts "Here's a list of your current cabinet(s):\n"
		sleep 1
		cabinet_list
	end

	def cabinet_list
		if Cabinet.all.length == 0
			puts "Hmm. Looks like we haven't opened any cabinets yet. \n
			Would you like to open one now? Type #{"Yes".black.on_green} or #{"No".black.on_red}."
			input = gets.strip.downcase
			if input.include? "exit"
				goodbye
			elsif input.include? "yes"
				Cabinet.new
			elsif input.include? "no"
				puts "\nVery well then. Let's head back to the main menu."
				main_menu
			else
				puts "\nOops.. I'm not sure I understood what you'd like to do. Let's head back to the main menu."
				sleep 2
				main_menu
			end
		else 
			Cabinet.all.each { |cabinet| puts "#{cabinet.name}\n" }
			cabinet_explore
		end
	end

	def cabinet_explore
		puts "To explore a cabinet, just type the number of the cabinet below."
		input = gets.gsub("cabinet", "").strip.downcase.
		if input.include? "exit"
			goodbye
		elsif input.to_i.between(1,999)
			Cabinet.all[input.to_i - 1].each.with_index do |index, product| 
				puts "\n#{index + 1}. #{product[0].name}"
			end
		else
			puts "\nOops.. I'm not sure I understood what you'd like to do. Let's head back to the main menu."
			sleep 2
			main_menu
		end
	end

	def goodbye
		puts "\nHave a bountiful day! =] We'll see you again soon!"
		sleep 1
		exit
	end

	nav = CLI.new
	nav.begin

end