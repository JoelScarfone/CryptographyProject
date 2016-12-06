require_relative 'vote'
require 'elgamal'

class VotingMachine

	SECRET_A = 987

	MODE_REGULAR = 1
	MODE_SIMULATION = 2

	def initialize(mode: MODE_SIMULATION)

		@votes = []
		@candadates = []
		@mode = mode

	end

	def run_simulation
		init_simulation
		collect_votes
		count_votes
	end

	private

	def init_simulation
		system "clear"
		puts "Booting up voting machine..."
		print "Please enter the number of candadates: "
		@num_candadates = gets.to_i
		(1..@num_candadates).each do |i|
			print "   Please enter a name for canadadate #{i}: "
			@candadates << gets.strip
		end
		print "Enter a security paramater (reccomended 10 < l < 15): "
		@security_paramater = gets
		print "Generating cryptographic tools..." if @mode == MODE_SIMULATION
		@pub_key, @priv_key = ElGamal::KeyPair.new.generate(bits: 20, a: SECRET_A)
		puts "Done." if @mode == MODE_SIMULATION
		sleep(1)
	end

	def collect_votes

		#infinite loop of 
		loop do
			vote, bsn = get_vote
			break if vote.nil?
			@votes <<  [vote, bsn]
		end

	end

	def get_vote
		system "clear"
		puts "Welcome! Press Enter to log in (:D):"
		login = gets
		return nil, nil if login == "-1\n"
		bsn = rand(100000000) + 100000000
		puts "You have been assigned a BSN of: #{bsn}"
		puts "Please choose from one of the following candadates: "
		@candadates.each_with_index do |candadate, index|
			puts "   #{index} - #{candadate}"
		end
		candadate_voted_for = gets.to_i
		vote = Vote.new(@security_paramater, @candadates.length)
		vote.generate_vc(@pub_key, candadate_voted_for)

		system "clear"
		puts "Vote submitted for candadate: #{@candadates[candadate_voted_for]}"
		if @mode == MODE_SIMULATION
				puts
				vote.pretty_print
				puts
			end
		puts "\nWould you like to verify your vote? (y/n)"
		answer = gets
		
		if answer.strip.downcase == "y"
			puts
			puts "You voted for candadate: #{@candadates[candadate_voted_for]}, in position #{candadate_voted_for}."
			puts
			k_values = vote.k_values
			vote.chosen_nums.each_with_index do |pledge, index|
				puts
				puts "Pledging #{vote.chosen_nums[index]}, for BMP #{vote.get_formatted_vc_row(candadate_voted_for)[index]}, which value would you like the k value used (left/right)."
				answer = gets.strip.downcase
				break if answer == 'end'
				if answer == "left"
					puts "k value used => #{k_values[index][0]}"
					puts "#{vote.get_vc_row(candadate_voted_for)[index][0]} = [ #{@pub_key.public_g} ** #{k_values[index][0]} % #{@pub_key.public_p}, #{vote.chosen_nums[index]} * #{@pub_key.public_h} ** #{k_values[index][0]} % #{@pub_key.public_p}] => TRUE :D"
				else
					puts "k value used => #{k_values[index][1]}"
					puts "#{vote.get_vc_row(candadate_voted_for)[index][1]} = [ #{@pub_key.public_g} ** #{k_values[index][1]} % #{@pub_key.public_p}, #{vote.chosen_nums[index]} * #{@pub_key.public_h} ** #{k_values[index][1]} % #{@pub_key.public_p}] => TRUE :D"
				end
			end

		end

		puts "\nPress enter to continue..."
		gets

		[vote, bsn]
	end

	def count_votes

		system "clear"
		puts "Decrypting votes..."

		candadates_to_votes = Hash.new { |x,y| x[y] = 0 }

		@votes.each do |vote, bsn|
			vote_for = vote.decrypt_vc(@priv_key)
			candadates_to_votes[@candadates[vote_for]] += 1
		end

		puts "Done."
		puts "#{candadates_to_votes}"

	end

end
