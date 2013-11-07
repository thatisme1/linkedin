class SecureController < ApplicationController
  before_filter :authenticate_user!
  layout 'signedin'
  def index
      @users = User.search(params[:search])
  end

  

end
