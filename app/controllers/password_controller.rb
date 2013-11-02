class PasswordController < Devise::PasswordsController
  protected

  def after_sending_reset_password_instructions_path_for(resource_name)
    
    return '/ahmad7'
  end
  def new
  	super
  end
  def edit
  	super
  end
end
