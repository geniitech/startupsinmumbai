class MainController < ApplicationController

  def home
    @organization = Organization.new
    render layout: nil
  end

  def fetch
    @organizations = Organization.where(approved: true)
    render json: @organizations.to_json(include: [:category], methods: [:logo_json_url])
  end

  def submission
    @organization = Organization.new
    @organization.name = params[:organization][:name]
    @organization.address = params[:organization][:address]
    @organization.website = params[:organization][:website]
    @organization.logo = params[:organization][:logo]
    @organization.description = params[:organization][:description]
    @organization.founded_in = params[:organization][:founded_in]
    @organization.submitter_email = params[:organization][:submitter_email]
    @organization.submitter_name = params[:organization][:submitter_name]
    @organization.category_id = params[:organization][:category_id]
    @organization.approved = false
    if @organization.save
      render json: "success", status: 200
    else
      render json: "fail", status: 402
    end
  end

end