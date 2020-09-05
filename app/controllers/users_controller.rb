class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def show
    @practices = @user.practices.includes(:chord)
  end

  def search
    # binding.pry
    @users = User.all
    if params[:song_id].present?
      @song = Song.find(params[:song_id])
      practicing_songs = @song.practice_songs.pluck("user_id")
      @users = @users.where(id: practicing_songs)
    end

    if params[:places].present?
      selected_users = []
      @users = @users.where(place_id: params[:places])
    end
  end


  private
  def set_user
    @user = User.find(params[:id])
  end
end
