class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from Exception , :with => :handle_exception
  include ApplicationHelper
  #rescue_from Exception, :with => :handle_exception

  def not_found
    render :template => "shared/not_found", :status => 404
  end

  private
  def handle_exception(exception)
    case exception
    when CanCan::AccessDenied
      authenticate_user!
    when ActiveRecord::RecordNotFound
      not_found
    else
      internal_server_error(exception)
    end
  end

  def internal_server_error(exception)
    render :template => "shared/internal_server_error", :status => 500
  end




  

end
