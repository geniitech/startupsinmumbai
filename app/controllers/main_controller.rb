class MainController < ApplicationController

  def home
    render layout: nil
  end

  def fetch
    @organizations = Organization.where(approved: true)
    render json: @organizations.to_json(include: [:category], methods: [:logo_json_url])
  end

end