class HomeController < ApplicationController
  
  def index
    if user_signed_in?
      redirect_to secure_index_path
      return
    end
    @show_full_footer=true
    @user=User.new
    @fuck='2'
	    respond_to do |format|
	      format.html # new.html.erb
	      format.json { render json: @user}
        
	  end

  end

  def secure

  end
  def temp
    render layout:'signedin'
  end

end
