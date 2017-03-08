class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def id_param
    params.permit(:id).fetch(:id)
  end
end
