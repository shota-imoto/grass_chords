class ApplicationController < ActionController::Base
    include Pagy::Backend

    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :set_current_user

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
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :place_id])
    end

    def authority_login
      if user_signed_in?
      else
        redirect_to root_path, notice: 'ログイン後、操作してください'
      end
    end

    def authority_user
      if current_user.id == @owner.id || current_user.admin.present?
      else
        redirect_back fallback_location: root_path, notice: 'あなたが作成したデータではありません。'
      end
    end

end
