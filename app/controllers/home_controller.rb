require 'pry'

class HomeController < ApplicationController

  def index
    @iss_data = call_api
    @astronaut_names = astronaut_names
    @total_astronaut_count = total_astronaut_count
  end

  def call_api
    {"message"=>"success",
    "number"=>7,
    "people"=>
      [{"craft"=>"ISS", "name"=>"Sergey Ryzhikov"},
      {"craft"=>"ISS", "name"=>"Kate Rubins"},
      {"craft"=>"ISS", "name"=>"Sergey Kud-Sverchkov"},
      {"craft"=>"ISS", "name"=>"Mike Hopkins"},
      {"craft"=>"ISS", "name"=>"Victor Glover"},
      {"craft"=>"ISS", "name"=>"Shannon Walker"},
      {"craft"=>"ISS", "name"=>"Soichi Noguchi"}]}
    # HTTParty.get('http://api.open-notify.org/astros.json')
  end

  def astronaut_names
    names = @iss_data["people"].map { |p| p["name"] }
  end

  def total_astronaut_count
    @iss_data["number"]
  end

  def search
    @results = params[:search]
    
    respond_to do |format|
      format.js
    end
  end

end
