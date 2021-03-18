require 'pry'

class HomeController < ApplicationController

  def index
    @iss_data = call_api
    @astronaut_names = astronaut_names
    # binding.pry
    @total_astronaut_count = total_astronaut_count
  end

  def call_api
    HTTParty.get('http://api.open-notify.org/astros.json')
  end

  def astronaut_names
    names = @iss_data["people"].map { |p| p["name"] }
  end

  def total_astronaut_count
    @iss_data["number"]
  end

end
