require "yaml"

class Hangman

	attr_accessor :guesses_left, :secret_len, :secret

	def initialize(dictionary)
		dict = File.open(dictionary).readlines
		@goodwords = dict.select {|word| word.length >= 5 && word.length <= 12}
		@goodlength = @goodwords.length
	end

	def choose_secret
		@secret = @goodwords[rand(@goodlength)].downcase.chomp
		@secret_len = @secret.length
		@guesses_left = @secret_len + 3
		@guess_so_far = "_"* @secret_len
	end

	def show_guess_so_far
		puts
		@guess_so_far.each_char do |c|
			print c + " "
		end
		puts
	end

	def check_guess(letter)
		secret_arr = @secret.split(//)
		secret_arr.each_index do |i|
			if letter == secret_arr[i]
				@guess_so_far[i] = letter
			end
		end
	end

	def check_win
		return (@guess_so_far == @secret)
	end
end

def save_game(game)
	puts "Enter a file name to save the game:"
	fname = gets.chomp
	File.open(fname, "w") do |f|
	    f.write(YAML::dump(game))
	end
end

def load_game
	puts "Enter filename to load:"
	fname = gets.chomp
	contents = ""
	File.open(fname, "r") do |f|
		contents = f.read
	end
	return YAML::load(contents)
end

puts "Welcome to Hangman!"
puts "Enter l to load a saved game, anything else for a new game"
choice = gets.chomp.downcase
if choice[0] == "l"
	hangman = load_game
	just_loaded = true
else
	hangman = Hangman.new("5desk.txt")
	hangman.choose_secret
	puts "The secret word is #{hangman.secret_len} letters long."
	win = false
	exit = false
	just_loaded = false
end
while !win && hangman.guesses_left > 0 do
	if just_loaded
		hangman.show_guess_so_far
		just_loaded = false
	end
    puts "You have #{hangman.guesses_left} guesses left."
    print "Enter a single-letter guess or -s to save the game: "
    choice = gets.chomp.downcase
    if choice[0..1] == "-s"
		save_game(hangman)
		exit = true
		break
	end
    hangman.check_guess(choice[0])
    hangman.show_guess_so_far
    win = hangman.check_win
    hangman.guesses_left -= 1
end

if exit
	puts "Your game was saved"
elsif win
	puts "Well done, you won!"
else
	puts "Better luck next time..."
	puts "The word was #{hangman.secret}"
end