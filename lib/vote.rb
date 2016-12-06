require 'elgamal'

class Vote

	NUM_A = 123
	NUM_B = 321

	def initialize(security_paramater, num_candadates)
		@security_paramater = security_paramater.to_i
		@num_candadates = num_candadates.to_i
	end

	attr_reader :vc, :chosen_nums
	attr_accessor :k_values

	def generate_vc(pub_key, choice)

		@vc = []
		@k_values = []
		@chosen_nums = []

		raise ArgumentError.new("Required ElGamal::PublicKey to generate vc") unless pub_key.is_a? ElGamal::PublicKey

		(0..@num_candadates - 1).each do |i|
			row = []
			(0..@security_paramater - 1).each do |j|
				rand_k_a = rand(pub_key.public_p - 1) + 1
				rand_k_b = rand(pub_key.public_p - 1) + 1
				if choice == i
					k_values << [rand_k_a, rand_k_b]
					num = [NUM_A, NUM_B].sample
					@chosen_nums << num
					row << [pub_key.encrypt(num, rand_k: rand_k_a), pub_key.encrypt(num, rand_k: rand_k_b)]
				else
					row << [pub_key.encrypt(NUM_A, rand_k: rand_k_a), pub_key.encrypt(NUM_B, rand_k: rand_k_b)].shuffle
				end
			end
			@vc << row
		end


	end

	def decrypt_vc(priv_key)

		raise ArgumentError.new("Required ElGamal::PrivateKey to decrypt the vc.") unless priv_key.is_a? ElGamal::PrivateKey

		@vc.each_with_index do |row, num_candadate|
			count = 0
			row.each do |bsn|
				decryption_a = priv_key.decrypt(bsn[0])
				decryption_b = priv_key.decrypt(bsn[1])
				if decryption_a == decryption_b
					count += 1
				end
			end

			return num_candadate if count == @security_paramater 
		
		end

		return -1 # faulty vote
	end

	def get_formatted_vc_row(row)
		@vc[row].map{ |x| get_pair_as_string(x) }
	end

	def get_vc_row(row)
		@vc[row]
	end

	def pretty_print
		width = @vc.flatten.map{ |x| get_pair_as_string(x).to_s.length }.max * 2 + 10
		puts @vc.map { |row| row.map { |bmp| get_pair_as_string(bmp).rjust(width) }.join }
	end

	private

	def get_pair_as_string(bmp)
		return bmp[0].to_s + bmp[1].to_s
	end

end