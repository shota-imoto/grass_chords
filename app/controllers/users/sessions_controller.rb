# frozen_string_literal: true
require "uri"
require "net/http"
require "json"
class Users::SessionsController < Devise::SessionsController
  include UsersHelper
  before_action :test_user_call, only: [:test_create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    # error: before access sessions/create action, automatically sign in even if email & password are correct.
    judge_bot_score = 0.5
    json_response = get_recaptcha_response(params[:user][:token])

    if json_response["success"] && json_response["score"] > judge_bot_score
      user = User.find_by(email: params[:user][:email])
      if user && user.valid_password?(params[:user][:password])
        redirect_to root_path, notice: 'ログインしました'
      else
        @user = User.new
        flash.now[:notice] = "メールアドレスもしくはパスワードに誤りがあります"
        render :new
      end
    else
      # by error, user has already signed in
      # if recaptcha authority is failed, i need user sign out.
      sign_out
      @user = User.new
      flash.now[:notice] = "Googleによって、アクセスが中止されました"
      render :new
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def test_create
    sign_in(@user)
    if current_user
      redirect_to root_path, notice: "お試しログインに成功しました"
    else
      redirect_back fallback_location: :new, notice: "お試しログインに失敗しました：システムエラー：管理者に連絡してください"
    end
  end

  protected

  # def session_params
  #   params.permit(:email, :password)
  # end

  def test_user_call
    @user = User.test_user_find
  end
end
