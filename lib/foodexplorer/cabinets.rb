class Cabinets < CLI
	include HTTParty

	attr_accessor :name, :contents

	@@all = []

	def initialize
		self.name = "Cabinet #{@@all.length + 1}"
		contents = []
		random_count = rand(0..3)
		if random_count == 0
			puts "\nUh oh! Looks like this cabinet is empty."
			puts "As a consolation prize, how about a bad joke?"
			sleep 1
			puts HTTParty.get("#{API_ROOT}/jokes/random#{API_KEY}")["text"]
			@@all << self
			kitchen_intro
		else
			loop do
				contents << Product.new(self.name)
				break if contents.length == random_count
			end
		end
		@@all << self
		new_cabinet(contents)
	end

	def new_cabinet(contents)
		case contents.length
		when 3
			puts "\nLet's see what's in #{self.name}..."
			sleep 1
			puts "\nLooks like we have...\n#{"(1)".on_blue} #{contents[0].name},\n#{"(2)".on_blue} #{contents[1].name}, and\n#{"(3)".on_blue} #{contents[2].name}."
		when 2
			puts "\nLet's see what's in #{self.name}..."
			sleep 1
			puts "\nLooks like we have...\n#{"(1)".on_blue} #{contents[0].name}, and\n#{"(2)".on_blue} #{contents[1].name}."
		else
			puts "\nLet's see what's in #{self.name}..."
			sleep 1
			puts "\nHmm... not very full, is it? Looks like we just one item:\n#{"(1)".on_blue} #{contents[0].name}."
		end
		sleep 1
		product_info_from_cabinet(contents)
	end

	def product_info_from_cabinet(contents)
		puts "\nTo find out more information about an item, type the item number below. To go back, type #{"Back".on_red}."
		print "\n>> ".on_red
		input = gets.to_s.strip.downcase
		if input.include? "exit"
			goodbye
		elsif input.include? "back"
			puts "\nLet's head back to the kitchen."
			sleep 1
			kitchen_intro
		elsif input == "1"
			contents[0].show_basic_info
		elsif input == "2"
			contents[1].show_basic_info
		elsif input == "3"
			contents[2].show_basic_info
		else
			puts "\nOops.. I'm not sure I understood what you'd like to do. Let's try that again."
			sleep 1
			product_info_from_cabinet(contents)
		end
	end
	
	def self.all
		@@all
	end

end