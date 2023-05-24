class UserAuthenticationController < ApplicationController
  # Uncomment line 3 in this file and line 5 in ApplicationController if you want to force users to sign in before any other actions.
  skip_before_action(:force_user_sign_in, { :only => [:sign_up_form, :create, :sign_in_form, :create_cookie] })

  def sign_in_form
    render({ :template => "user_authentication/sign_in.html.erb" })
  end

  def create_cookie
    user = User.where({ :email => params.fetch("query_email") }).first

    the_supplied_password = params.fetch("query_password")

    if user != nil
      are_they_legit = user.authenticate(the_supplied_password)

      if are_they_legit == false
        redirect_to("/user_sign_in", { :alert => "Incorrect password." })
      else
        session[:user_id] = user.id

        redirect_to("/", { :notice => "Signed in successfully." })
      end
    else
      redirect_to("/user_sign_in", { :alert => "No user with that email address." })
    end
  end

  def destroy_cookies
    reset_session

    redirect_to("/", { :notice => "Signed out successfully." })
  end

  def sign_up_form
    render({ :template => "user_authentication/sign_up.html.erb" })
  end

  def create
    @user = User.new
    @user.email = params.fetch("query_email")
    @user.password = params.fetch("query_password")
    @user.password_confirmation = params.fetch("query_password_confirmation")
    @user.first_name = params.fetch("query_first_name")
    @user.writing_sample = params.fetch("query_writing_sample")
    @user.default_industry = params.fetch("query_default_industry")
    #@user.messages_count = params.fetch("query_messages_count")

    save_status = @user.save

    if save_status == true
      session[:user_id] = @user.id

      redirect_to("/", { :notice => "User account created successfully." })
    else
      redirect_to("/user_sign_up", { :alert => @user.errors.full_messages.to_sentence })
    end
  end

  def edit_profile_form
    render({ :template => "user_authentication/edit_profile.html.erb" })
  end

  def update
    @user = @current_user
    #@user.email = params.fetch("query_email") #not an option to change password

    if !params["query_password"].blank? && !params["query_password_confirmation"].blank? #only update these if the user entered something for both
      @user.password = params.fetch("query_password")
      @user.password_confirmation = params.fetch("query_password_confirmation")
    end

    @user.first_name = params.fetch("query_first_name")
    @user.writing_sample = params.fetch("query_writing_sample")
    @user.default_industry = params.fetch("query_default_industry")
    #@user.messages_count = params.fetch("query_messages_count")

    if @user.valid?
      @user.save

      redirect_to("/edit_user_profile", { :notice => "User account updated successfully." })
    else
      redirect_to("/edit_user_profile", alert: @user.errors.full_messages.to_sentence)
    end

  end

  def destroy
    @current_user.destroy
    reset_session

    redirect_to("/", { :notice => "User account cancelled" })
  end
end
