class SecureController < ApplicationController
  before_filter :authenticate_user!
  layout 'signedin'

  def index

    @current_user=User.find(current_user)
    if params[:Adv_Search]!='Submit'

      @users = User.search(params[:search])
    else



    @users=User.find_all_by_id(User.advanced_search(params[:fname],params[:lname],params[:company]\
    ,params[:school],params[:country]).select('distinct users.id'))

    end
  end



  def alumini
    @current_user=User.find(current_user)
    if @current_user.students.any?
      params[:school]= @current_user.students.first.inst_name if params[:school].blank?
      params[:start_date]= 1900 if params[:start_date].blank?
      params[:end_date]= 2015 if params[:end_date].blank?
    @users=@current_user.alumini( params[:school],params[:start_date],params[:end_date])

    end

  end

end
