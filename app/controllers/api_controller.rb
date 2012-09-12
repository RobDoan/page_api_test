class ApiController < ActionController::Base
  before_filter :set_content_type

  rescue_from ActiveRecord::RecordNotFound, :with => :not_found

  respond_to :json, :xml

  private
  def set_content_type
    content_type = case params[:format]
                     when "json"
                       "application/json"
                     when "xml"
                       "text/xml"
                   end
    headers["Content-Type"] = content_type
  end

  def invalid_resource!(resource)
    @resource = resource
    render "/api/errors/invalid_resource", :status => 422
  end

  def not_found
    render "/api/errors/not_found", :status => 404 and return
  end
end