require 'pry'

class HomeController < ApplicationController

  def index
    @iss_data = call_api
  end

  def call_api
    process_response_data({"message"=>"success",
    "number"=>7,
    "people"=>
      [{"craft"=>"ISS", "name"=>"Sergey Ryzhikov"},
      {"craft"=>"ISS", "name"=>"Kate Rubins"},
      {"craft"=>"ISS", "name"=>"Sergey Kud-Sverchkov"},
      {"craft"=>"ISS", "name"=>"Mike Hopkins"},
      {"craft"=>"ISS", "name"=>"Victor Glover"},
      {"craft"=>"ISS", "name"=>"Shannon Walker"},
      {"craft"=>"ISS", "name"=>"Soichi Noguchi"}]})
    # response_data = HTTParty.get('http://api.open-notify.org/astros.json')
    # process_response_data(response_data)
  end

  def process_response_data(response_data)
    if response_data["message"] == "success"
      @astronaut_names = response_data["people"].map { |p| p["name"] }
      @total_astronaut_count = response_data["number"]
    else
      @astronaut_names = ["No name data is available at this time"]
      @total_astronaut_count = ["No count data is available at this time"]
    end
  end

  def search
    search_query = params[:search]
    @results = get_search_results(search_query)
    @location_data = @results["display_name"]
    @lat = @results["lat"]
    @lon = @results["lon"]
    @iss_pass_data = find_iss_passes(@lat, @lon)

    respond_to do |format|
      format.js
    end
  end

  def get_search_results(search_query)
    base_path = "https://nominatim.openstreetmap.org/search?q="
    query = "#{search_query}"
    return_format = "json"
    url = base_path + "'#{query}'" + "&format=" + return_format
    responses = HTTParty.get(url)
    responses.first
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
    response = HTTParty.get(url)
    @duration = response["response"].first["duration"]
    @risetime = time_parse(response["response"].first["risetime"])
  end

  def time_parse(time)
    Time.at(time).utc.to_datetime
  end

end
