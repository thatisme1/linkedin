class UserStepsController < ApplicationController
	include Wicked::Wizard
	before_filter :authenticate_user!
	layout 'header2'
	steps :professional ,:email ,:authenticate,:confirm ,:share,:add
	def show
		@user = current_user
		@radio = 'seeker'
		@emp = Employment.new
		@emp.user_id =@user.id
    @user.country_id=163 if @user.country.nil?

		@email = @user.email
		@flag=true


		render_wizard
	end

	def update

		@flag=true
		if params[:id]=='professional'
			@radio=params[:'status-chooser']
			@emp
			@user= current_user
			@user.country_id = params[:user][:country_id]
			@user.postcode = params[:user][:postcode]
			if params[:'status-chooser']=='employed'
				@emp = Employment.new
						@emp.user_id =current_user.id
						@emp.attributes = params[:employed]
						@emp.start_date = 2013
						@emp.end_date = 0


			elsif params[:'status-chooser']=='seeker'
						@emp = Employment.new
						@emp.user_id =current_user.id
						puts "===================================================================="
						@emp.attributes = params[:seeker]
						
						puts "====================================================================="
						puts @emp
			
			else
				@emp= Student.new
				@emp.user_id =current_user.id
				@emp.attributes = params[:student]
						
			end

			if @user.valid? && @emp.valid?
				@user.save
				@emp.save
				redirect_to next_wizard_path
				return

			else 
				render 'professional'
				return
			end

		elsif params[:id]=='email'

			@user = User.new
			@user.email = params[:email]
			if @user.email!=current_user.email
				@user.save
				@email = @user.email
				if @user.errors[:email].any?
					@flag=false
					@email = @user.email
					@user = current_user
					render 'email'
					return
				end
			 
			else

				redirect_to next_wizard_path
				return
			end

    elsif param[:id] =='confirm'

		end


		
		render_wizard
	end

end
