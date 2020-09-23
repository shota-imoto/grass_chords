class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def show
    @pagy_practice, @practices = pagy(@user.practices.includes(:chord))
    @pagy_like, @likes = pagy(@user.likes.includes(:chord))
  end

  def search
    @users = User.all
    if params[:song_id].present?
      @song = Song.find(params[:song_id])
      @users = @song.users
    end

    if params[:places].present?
      selected_users = []
      @users = @users.where(place_id: params[:places])
    end

    @pagy, @users = pagy(@users)
  end


  private
  def set_user
    @user = User.find(params[:id])
  end
end
