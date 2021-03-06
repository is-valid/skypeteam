#encoding: utf-8
class SessionsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    user = User.where(:provider => auth['provider'],
                      :uid => auth['uid'].to_s).first || User.create_with_omniauth(auth)
    unless user.banned?
      session[:user_id] = user.id
      redirect_to root_path, :notice => "Велкам!!!"
    else
      redirect_to root_path, :alert => "Да Да, ты забанен Оо! причина : #{user.ban_reason}"
    end
  end

  def destroy
    reset_session
    redirect_to root_url, :notice => 'Скатертью дорожка!'
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end

end
