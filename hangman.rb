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
  end
end

# Player class
class Player
  def initialize
  end

  def make_guess
    # get guess from player, checking it hasn't been guessed already
    # computer.check_letter(guess)
  end
end

# Computer class
class Computer
  attr_reader :visible_letters, :remaining_guesses, :letters_guessed

  def initialize
    @secret_word = ''
    @visible_letters = '' # create string of _'s of length @secret_word.length
    @remaining_guesses = 10
    @letters_guessed = []
  end

  def take_turn(letter)
    @visible_letters = check_letter(letter)
  end

  def check_letter
      # check letter against secret_word,
      # return visible_letters with letter filled in
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
    puts comp.visible_letters
    puts "You have #{comp.remaining_guesses} remaining."
    puts "Letters guessed: #{comp.letters_guessed.join(' ')}" if comp.letters_guessed
  end
end

new_game = Game.new