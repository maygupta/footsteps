class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  AUTH_TOKEN = "2fad79af-b24e-48fd-9f0c-8ed849b3646d"

  def is_authorized?
    params[:auth_token].present? and params[:auth_token] == AUTH_TOKEN
  end
end
