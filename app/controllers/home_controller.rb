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
    search_query = params[:search]
    @results = find_lat_and_long(search_query)
    respond_to do |format|
      format.js
    end
  end

  def find_lat_and_long(search_query)
    base_path = "https://nominatim.openstreetmap.org/search?q="
    query = "#{search_query}"
    return_format = "json"
    url = base_path + "'#{query}'" + "&format=" + return_format
    responses = HTTParty.get(url)
    @response = responses.first
    lat = responses.first["lat"]
    lon = responses.first["lon"]

    find_iss_passes(lat, lon)
  end

  def find_iss_passes(lat, lon)
    url = "http://api.open-notify.org/iss-pass.json?lat=#{lat}&lon=#{lon}&n=3"
    responses = HTTParty.get(url)
  end

end
