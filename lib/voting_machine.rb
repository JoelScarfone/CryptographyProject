require_relative 'vote.rb'

class VotingMachine

	def initialize
		@candadates = Array.new
		@security_paramater = nil
		init
	end

	def init
		system "clear"
		puts "Booting up voting machine..."
		print "Please enter the number of candadates: "
		@num_candadates = gets.to_i
		(1..@num_candadates).each do |i|
			print "   Please enter a name for canadadate #{i}: "
			@candadates << gets
		end
		print "Enter a security paramater (reccomended 10 < l < 15): "
		@security_paramater = gets
	end

	def start
		iteration = 0
		loop do
			get_vote
			break if (iteration += 1) == 10
		end

	end

	private

	def get_vote
		system "clear"
		puts "Welcome! Press Enter to log in (:D):"
		gets
		bsn = rand(100000000) + 90000000
		puts "You have been assigned a BSN of: #{bsn}"
		puts "Please choose from one of the following candadates: "
		@candadates.each_with_index do |candadate, index|
			puts "   #{index} - #{candadate}"
		end
		candadate_voted_for = gets.to_i
		vote = Vote.new(candadate_voted_for, @security_paramater, @candadates.length)
		vote.generate_vc
	end

end

voting_machine = VotingMachine.new
voting_machine.start
