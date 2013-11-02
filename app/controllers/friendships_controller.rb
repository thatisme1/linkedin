class FriendshipsController < ApplicationController
def index
	@user = User.find(params[:user_id])
end
def show
	redirect_to user_path(params[:id])
end
def new
	@friendship1 = Friendship.new

end
def create
	@friend = User.find(params[:friend_id])
	params[:friendship1] = {:user_id => @current_user.id, :friend_id => @friend.id, :status => 'requested'}
	@friendship1 = Friendship.new(params[:friendship1])

	if @friendship1.valid?
		@friendship1.save
		redirect_to user_friends_path(current_user)
	else
		redirect_to user_path(current_user)
	end
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
