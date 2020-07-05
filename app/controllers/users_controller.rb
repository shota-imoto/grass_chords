class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def show
    @practices = @user.practices.includes(:chord)
  end

  private
  def set_user
    @user = User.find(params[:id])
  end
end
