# frozen_string_literal: true
require "uri"
require "net/http"
require "json"
class Users::RegistrationsController < Devise::RegistrationsController
  include UsersHelper
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
    # [FixMe]
    # error: before access sessions/create action, automatically sign in even if email & password are correct.
    judge_bot_score = 0.5
    json_response = get_recaptcha_response(params[:user][:token])

    if json_response["success"] && json_response["score"] > judge_bot_score

      # 既に登録済みのユーザ情報でエラー発生しないようカラム追加時にデフォルト設定を行った
      # 活動拠点の未登録ユーザがいなくなった時点で下記を削除すること
      params[:user][:place_id] = 0 if params[:user][:place_id] == ""
      @user = User.new(user_params)
      if @user.save
        bypass_sign_in(@user)
        redirect_to root_path, notice: "ようこそ！ アカウントが登録されました"
      else
        render :new
      end

    else
      # [FixMe]
      # by error, user has already signed in
      # if recaptcha authority is failed, i need user sign out.
      @user = User.new
      flash.now[:notice] = "Googleによって、アクセスが中止されました"
      render :new
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    # 既に登録済みのユーザ情報でエラー発生しないようカラム追加時にデフォルト設定を行った
    # 活動拠点の未登録ユーザがいなくなった時点で下記を削除すること
    params[:user][:place_id] = 0 if params[:user][:place_id] == ""
    # because breadcrumb function needs "params[:id]"
    params[:id] = current_user.id

    if params[:user][:password].present? && params[:user][:password_confirmation].present? && params[:user][:current_password].blank?
      redirect_to edit_user_registration_path(id: current_user.id), notice: "パスワードを変更する際は、現在のパスワードを入力してください" and return
    end

    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    yield resource if block_given?
    if resource.update_without_current_password(account_update_params)
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end

    # #if update_resource(resource, account_update_params)
    # if resource.update_without_current_password(account_update_params)
    #   yield resource if block_given?
    #   if is_flashing_format?
    #     flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
    #       :update_needs_confirmation : :updated
    #     set_flash_message :notice, flash_key
    #   end
    #   bypass_sign_in(resource_name, resource)
    #   respond_with resource, :location => after_update_path_for(resource)
    # else
    #   clean_up_passwords resource
    #   respond_with resource
    # end
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
  def user_params
    params.require(:user).permit(:name, :place_id, :email, :password, :password_confirmation).merge(encrypted_password: Devise::Encryptor.digest(User, params[:user][:password]))
  end
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

  # def update_resource(resource, params)

  #   resource.update_without_current_password(params)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
