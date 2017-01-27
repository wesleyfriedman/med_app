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

    byebug
    # <%= form_for @search, url: '/search' do |f| %>
    #
    #
    #   <%= f.label :lat %>
    #   <%= f.text_field :lat %><br>
    #
    #   <%= f.label :lon %>
    #   <%= f.text_field :lon %><br>
    #
    #   <%= f.label :distance %>
    #   <%= f.text_field :distance %><br>
    #
    #   <%= f.submit :search %>
    #
    # <% end %>
#     Name
# diseases.display_name
# Eligibility
# eligibility.structured.gender
# eligibility.structured.max_age_in_years
# eligibility.structured.min_age_in_years
# Trial Status
# current_trial_status
# Location
# sites.org_coordinates_lat
# sites.org_coordinates_lon
# Sites.org_coordinates_dist (100mi)

    byebug
    redirect_to :back
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
