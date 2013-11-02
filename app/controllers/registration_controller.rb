class RegistrationController < Devise::RegistrationsController
	before_filter !:user_signed_in

	layout 'header2'


	def new

		@fuck='1'

		@user = User.new 
		
#		respond_to do |format|
#			format.html
#			format.json {render :json => @user}
#
#		end

		

		

	end



	def step2 

		@user = User.new(params[:user])

		puts "=====================>"+params[:abc]

			if	@user.save
				#make session
				sign_in(User,@user)
				redirect_to user_steps_path
			else  
				if params[:abc]=='1'
					@fuck=1
					#raise ArgumentError,"sad"
					render  'new' 
					return
					
				else
					@fuck=2

					@show_full_footer=true

					
					render 'home/index' ,layout:'application'
					return
				end
			end
	end

	def update
		super
	end

end
