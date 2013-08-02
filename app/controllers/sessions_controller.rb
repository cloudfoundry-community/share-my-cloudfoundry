class SessionsController < ApplicationController

  ##
  # Deals with Omniauth failures
  #
  def failure
    flash[:error] = "There was an error at the #{params[:strategy]} authentication service: #{params[:message]} "
    redirect_to root_url
  end

end
