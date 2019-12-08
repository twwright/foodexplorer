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

	def products_menu
		puts "Here's some products, bruh."
		#Lists current groceries
		#Points to select_groceries, open_cabinet, view_cabinets, or go_back
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
			cabinet_list
		elsif input.include? "menu" || "back"
			main_menu
		else
			puts "\nOops.. I'm not sure I understood what you'd like to do. Let's head back to the Kitchen menu."
			sleep 2
			kitchen_menu
		end
	end

	def cabinet_list
		puts "Here's a list of your current cabinet(s):\n"
		if Cabinet.all.length == 0
			puts "Hmm. Looks like we haven't opened any cabinets yet. Would you like to open one now? Type #{"Yes".black.on_green} or #{"No".black.on_red}."
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
			puts "\nTo explore a cabinet, just type the number of the cabinet below."
			input = gets.strip.downcase
			if input.include? "exit"
				goodbye
			elsif input.to_i.between(1,999)
				Cabinet.all[input.to_i - 1].each.with_index do |index, product| 
					puts "\n#{index +1}. #{product[0].name}"
				end
				product_info
			else
				puts "\nOops.. I'm not sure I understood what you'd like to do. Let's head back to the main menu."
				sleep 2
				main_menu
			end
		end
	end


	def ascii
		puts "So, would you like to go #{"Back".black.on_blue} or see a sweet ASCII image instead? #{"Yes".black.on_green} or #{"No".black.on_red}."
		input = gets.strip.downcase
		if input.include? "exit"
			goodbye
		elsif input.include? "ye"
			puts "Soon, master, soon."
			sleep 2
			puts "\nLet's head back to the main meu."
			sleep 1
			main_menu
		elsif input.include? "no"
			puts "\nYour loss. Let's head back to the main menu."
			sleep 1
			main_menu
		elsif input.include? "menu" || "back"
			main_menu
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

	start = CLI.new
	start.begin

end