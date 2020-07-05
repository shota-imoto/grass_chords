# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :test_user_call, only: [:test_create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def test_create
    if current_user
      redirect_to root_path, notice: "お試しログインに成功しました"
    else
      redirect_back fallback_location: :new, notice: "お試しログインに失敗しました"
    end
  end

  protected

  def test_user_call
    @user = User.test_user_find
    sign_in @user
  end
  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  # def after_sign_in_path_for(resource)
  #   root_path(resource)
  # end

  # def after_sign_out_path_for(resource)
  #   root_path(resource)
  # end
end
