class SearchController < ApplicationController

  def index
    @diseases = Disease.all.pluck(:name)
    @search = Search.new
  end

  def create
    @search = Search.create(search_params)
    redirect_to :back
  end

  def diseases
    @diseases = Disease.all.pluck(:name)
    render json: @diseases
  end

  private

  def search_params
    params.require(:search).permit!
  end

end
