# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  # before_action :set_owner, only: [:edit, :update, :destroy]
  before_action :authority_login, only:[:edit, :update, :destroy]
  # before_action :authority_user, only: [:edit, :update, :destroy]
  before_action :test_user_protection, only: [:update, :destroy]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    super
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    super
  end

  # DELETE /resource
  def destroy
    # super
    @user.destroy
    redirect_to new_user_registration_path, notice: 'ご利用ありがとうございました。アカウント情報が削除されました'
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    root_path(resource)
  end

  def after_update_path_for(resource)
    root_path(resource)
  end

  def test_user_protection
    if current_user.id == 0 || current_user.admin.present?
      redirect_back fallback_location: root_path, notice: 'テストユーザーは編集できません'
    end
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
