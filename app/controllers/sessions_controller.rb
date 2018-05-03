class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :destroy, :forgot_password]

  def new
  end

  def create
    if params[:email].blank? || params[:password].blank?
      @message = "Email or Password can't be empty"
      render '_error'
      return
    end

    if params[:commit] == "Sign Up"
      user = User.find_by(email: params[:session][:email].downcase)
      if user.present?
        @message = 'Account with this email already exists'
        render '_error'
        return
      end
    else
      user = User.find_by(email: params[:session][:email].downcase)
      if !user
        @message = 'No account exists with provided email, Please sign up!'
        render '_error'
        return
      end
    end

    user = User.find_by(email: params[:session][:email].downcase)

    if !user
      @user = User.new(email: params[:session][:email], 
        encrypted_password: params[:session][:password],
        name: params[:session][:name])
      @user.save
      log_in @user
      redirect_to '/'
    else
      if user && user.authenticate(params[:session][:password])
        # Log the user in and redirect to the user's show page.
        log_in user
        redirect_to '/', :flash => { :notice  => "Welcome #{user.email}" }
      else
        # Create an error message.
        @message = 'Invalid email/password combination'
        render '_error'
        return
      end
    end
  end

  def destroy
    reset_session
    redirect_to '/login'
  end
end