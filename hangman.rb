# load dictionary
# randomly select word between 5-12 chars long, store as secret word

# turn:
  # player makes guess, case insensitive
  # update display to reflect whether letter was correct or not
  # if out of guesses, player loses

# add option to save game (serialize Game class)

# add option to open a saved game when loads

class Game
  def initialize
    @player = Player.new
    @computer = Computer.new
    @display = Display.new
    play_game(@player, @computer, @display)
  end

  def play_game(player, computer, display)
    display.show_display(computer)
    computer.check_letter(player.make_guess)
    display.show_display(computer)
  end
end

# Player class
class Player
  def initialize
  end

  def make_guess
    # get guess from player, checking it hasn't been guessed already
    gets.chomp
  end
end

# Computer class
class Computer
  attr_reader :visible_letters, :remaining_guesses, :letters_guessed

  def initialize
    @secret_word = generate_secret_word
    @visible_letters = generate_visible_letters # create string of _'s of length @secret_word.length
    @remaining_guesses = 10
    @letters_guessed = []
    puts @secret_word
  end

  def take_turn(letter)
    @visible_letters = check_letter(letter)
    Display.show_display(letter)
  end

  def check_letter(letter)
    # check letter against secret_word,
    # return visible_letters with letter filled in
    @letters_guessed.push(letter)
    i = 0
    @secret_word.each_char do |char|
      @visible_letters[i] = letter if char == letter
      i += 1
    end
    @remaining_guesses -= 1
  end

  def space_out_visible_letters
    @visible_letters.gsub('_', '_ ').rstrip
  end

  private

  def generate_secret_word
    words = []
    File.open('words.txt').readlines.each do |word|
      words.push(word.strip) if word.length.between?(6, 13) # allow for newline chars
    end
    words.sample
  end

  def generate_visible_letters
    @visible_letters = @secret_word.gsub(/[a-zA-Z]/, '_')
  end
end

# Display:
  # remaining guesses
  # correct letters and position
  # incorrect letters already chosen
class Display
  def initialize
  end

  def show_display(comp)
    puts "Word: #{comp.space_out_visible_letters}"
    puts "You have #{comp.remaining_guesses} guesses remaining."
    puts "Letters guessed: #{comp.letters_guessed.join(' ')}" unless comp.letters_guessed.empty?
  end
end

new_game = Game.new
