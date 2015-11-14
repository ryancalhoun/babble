require 'markov'

class MainController < ApplicationController
  def create_sentence
    markov = Markov.new Chain
    render :text => markov.create_sentence
  end

  def parse_sentence
    markov = Markov.new Chain
    markov.parse! params[:text]
    render :nothing => true, :status => :accepted
  end
end
