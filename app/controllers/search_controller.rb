require 'open-uri'
require 'json'

class SearchController < ApplicationController

  def index
    @diseases = Disease.all.pluck(:name)
    @search = Search.new
  end

  def create
    @search = Search.create(search_params)
    query = "https://clinicaltrialsapi.cancer.gov/v1/clinical-trials?"
    query += "diseases.synonyms=#{params[:search][:disease_name]}"
    query += "&current_trial_status=Active"
    query += "&include=eligibility.structured.lat"
    query += "&include=eligibility.structured.lon"
    query += "&include=diseases.display_name"
    query += "&include=lead_org"
    query += "&include=principal_investigator"
    query += "&include=sites.contact_email"
    result = open(query)
    result = JSON.parse(result.read)
    result["trials"].each do |trial|
      trial["diseases"].select! {|disease| !disease["display_name"].nil? && !disease["display_name"].empty?}
      trial["sites"].select! {|site| !site["contact_email"].nil? && !site["contact_email"].empty?}
    end
    # result['trials'].first['principal_investigator']
    # render json: result
    @diseases = Disease.all.pluck(:name)
    @search = Search.new
    @result = result
    render partial: 'search_results', locals: {result: @result}
  end

  def diseases
    @diseases = Disease.all.pluck(:name)
    render json: @diseases.to_a
  end

  private

  def search_params
    params.require(:search).permit!
  end

end
