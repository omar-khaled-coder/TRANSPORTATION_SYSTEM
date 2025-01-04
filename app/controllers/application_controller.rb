class ApplicationController < ActionController::Base
  helper_method :driver_signed_in?, :current_driver

  def driver_signed_in?
    # Check if the session contains a driver ID (or you could decode JWT)
    session[:driver_id].present?
  end

  def current_driver
    @current_driver ||= Driver.find_by(id: session[:driver_id]) if session[:driver_id]
  end

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    begin
      decoded = JsonWebToken.decode(token)
      @current_driver = Driver.find(decoded[:driver_id])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { errors: ['Unauthorized'] }, status: :unauthorized
    end
  end
end
