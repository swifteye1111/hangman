# frozen_string_literal: true

# Computer class
class Computer
  attr_reader :visible_letters, :remaining_guesses, :letters_guessed

  def initialize
    @secret_word = generate_secret_word
    @visible_letters = generate_visible_letters
    @letters_guessed = []
    @remaining_guesses = 10
  end

  def check_letter(letter)
    # check letter against secret_word,
    # return visible_letters with letter filled in
    @letters_guessed.push(letter)
    if @secret_word.include?(letter)
      i = 0
      @secret_word.each_char do |char|
        @visible_letters[i] = letter if char == letter
        i += 1
      end
    else
      @remaining_guesses -= 1
    end
  end

  def game_over?
    return true if @visible_letters == @secret_word || @remaining_guesses.zero?

    false
  end

  def send_outcome(display)
    display.show_outcome(self, @secret_word)
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
