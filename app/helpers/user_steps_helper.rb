module UserStepsHelper

	def create_employed
		@emp = Employment.new
		@emp = params[:employed]
		@emp.save
	end
	def create_seeker
		@emp = Employment.new
		@emp = params[:seeker]
		@emp.save
	end
end
