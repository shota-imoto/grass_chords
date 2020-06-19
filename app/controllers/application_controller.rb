class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :set_current_user
    # protect_from_forgery with: :exception

    def set_current_user
      if user_signed_in?
        @user = User.find(current_user_permit[:user_id])
      end
    end

    private
    def current_user_permit
      params.merge(user_id: current_user.id)
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    end
end
