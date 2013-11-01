class CitiesController < ApplicationController
  def index
    @cities = City.select_city params
    render_with_json data: @cities
  end
end
