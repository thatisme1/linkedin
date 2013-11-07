class FriendshipsController < ApplicationController

  before_filter :authenticate_user!

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
  if @friendship.valid?
    session[:friend_id]=@friendship.friend_id
    flash[:message]="Saved"
    puts session[:friend_id]
  end

end
  def index
    redirect_to root_path
  end
def create

  if session[:friend_id].blank?
    puts' --------------------------------------------------------------'

  end
  if current_user.connect_with_person(session[:friend_id])
    session.delete(:friend_id)
    flash[:notice] = "Added friend."
		redirect_to secure_index_path
	else
		redirect_to user_path(current_user)
  end
  return

end

	def update
		@fr=Friendship.current_user.find_by_friend_id(params[:id])
		if @fr
			@fr.accept_request
		end

		# @user = User.find(current_user)
		# @friend = User.find(params[:id])
		# params[:friendship1] = {:user_id => @user.id, :friend_id => @friend.id, :status => 'accepted'}
		# @friendship1 = Friendship.find_by_user_id_and_friend_id(@user.id, @friend.id)
		# if @friendship1.update_attributes(params[:friendship1]) && @friendship2.update_attributes(params[:friendship2])
		# 	flash[:notice] = 'Friend sucessfully accepted!'
		# 	redirect_to user_friends_path(current_user)
		# else
		# 	redirect_to user_path(current_user)
		# end
	end

	def ignore
		@f=current_user.friendships.find_by_friend_id(params[:id])
		@f.ignore unless @f.blank?
		
	end

	def destroy
		@user = User.find(params[:user_id])
		@friendship1 = @user.friendships.find_by_friend_id(params[:id]).destroy
		redirect_to user_friends_path(:user_id => current_user)
	end
end
