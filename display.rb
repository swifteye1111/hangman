# frozen_string_literal: true

require_relative 'computer'

# Display class
class Display
  def show_display(comp)
    puts "Word: #{comp.visible_letters}"
    puts "You have #{comp.remaining_guesses} guesses remaining."
    puts "Letters guessed: #{comp.letters_guessed.join(' ')}" unless comp.letters_guessed.empty?
  end

  def show_outcome(comp, secret_word)
    if comp.remaining_guesses.zero?
      puts "You lost with #{comp.remaining_guesses} guess(es) remaining. The secret word was #{secret_word.upcase}."
    else
      puts "You won! You guessed the secret word #{secret_word.upcase} with #{comp.remaining_guesses} guess(es) remaining!"
    end
  end
end
