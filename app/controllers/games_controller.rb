require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    # TODO: generate random grid of letters
    number = rand(7..10)
    @letters = Array.new(number) { ('A'..'Z').to_a.sample }
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def score
    @guess = params[:word].downcase
    letter = params[:letters].downcase
    @results =
      if included?(@guess, letter)
        if english_word?(@guess)
          'Well done'
        else
          "#{@guess} is not an english word"
        end
      else
        "#{@guess} is not in the grid"
      end
  end


  # def compute_score(attempt, time_taken)
  #   time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  # end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
