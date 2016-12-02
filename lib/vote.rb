class Vote

	@vc = []

	def initialize(choice, security_paramater, num_candadates)
		@choice = choice
		@security_paramater
		@num_candadates
	end

	def generate_vc

		(0..@num_candadates).each do |i|
			row = []
			@security_paramater.each do |j|
				bit = rand(2)
				if @choice == i
					row << [bit, bit]
				else
					row << [bit, bit + 1 % 2]
				end
			end
			vc << row
		end

		puts vc
		gets

	end

end