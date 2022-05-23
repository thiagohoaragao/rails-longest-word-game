require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    @answer = params[:answer]
    @result = if valid_word?
                if valid_english_word?
                  "Congratulations! #{params[:answer].upcase} is a valid english word!"
                else
                  "Sorry but #{params[:answer].upcase} does not seem to be a valid english word."
                end
              else
                "Sorry but #{params[:answer].upcase} cant be built out of #{@letters}"
              end
  end

  def valid_english_word?
    url = "https://wagon-dictionary.herokuapp.com/#{params[:answer]}"
    validation_serialized = URI.open(url).read
    validation = JSON.parse(validation_serialized)
    validation['found']
  end

  def valid_word?
    @letters = params[:letters].split(' ')
    @answer = params[:answer].split(//)
    @answer.all? { |letter| @letters.count(letter) >= @answer.count(letter) }
  end
end
