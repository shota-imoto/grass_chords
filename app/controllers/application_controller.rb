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

    def authority_login
      if user_signed_in?
      else
        redirect_to root_path, notice: 'ログイン後、操作してください'
      end
    end

    def authority_user
      binding.pry
      if (current_user.id == @user.id) | (current_user.admin == 1)
      else
        redirect_back fallback_location: root_path, notice: 'あなたが作成したデータではありません。'
      end
    end
end
