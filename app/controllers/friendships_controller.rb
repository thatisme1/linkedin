class FriendshipsController < ApplicationController

  before_filter :authenticate_user!
  layout 'signedin'
def show
	redirect_to user_path(params[:id])
end
def new
  if params[:id]
    puts '###########################################'
  end
  @friendship=current_user.friendships.new
  @friendship.friend_id=params[:id]
  @friendship.status='pending'
  @friendship.relation='Other'
  if @friendship.valid?
    session[:friend_id]=@friendship.friend_id

    puts session[:friend_id]
    @friendship.relation=''
    respond_to do |format|
      format.html
      format.json {render :json => @friendship}

    end
  end

end
  def index
    @friends=current_user.friends
    @pending =current_user.pending_friends
    @requests = current_user.requested_friends
  end
def create
  puts'bdbdhwamdsbamdhbwmhbadmshudhwiajdij#############################'

  if session[:friend_id].blank?
    puts' --------------------------------------------------------------'

  end
  friend_id=session[:friend_id]
  session.delete(:friend_id)
  @friendship=current_user.connect_with_person(friend_id,params[:friendship][:relation])

  if @friendship.valid?

    @friendship.save
    flash[:notice] = "Added friend."

		redirect_to secure_index_path
  else
    session[:friend_id]=friend_id
		render 'new'
    return
  end
  return

end

	def update
    puts '-------------------------------------------------------------------------------------------------'
    puts params
		@fr=Friendship.find(params[:id])
		if !@fr.nil? && @fr.user_id==current_user.id
      if params[:commit]=='Accept'
			@fr.accept_request
      else
        @fr.ignore
        end
    end

    redirect_to friendships_path

	end

	def ignore
		@f=current_user.friendships.find_by_friend_id(params[:id])
		@f.ignore unless @f.blank?
		
	end

	def destroy
    puts 'Destroy'
    @f=Friendship.find_by_user_id_and_friend_id(current_user.id,params[:id])
    @f.disconnect
    redirect_to friendships_path
	end
end
