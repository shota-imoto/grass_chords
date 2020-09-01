class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def show
    @practices = @user.practices.includes(:chord)
  end

  def search
    @users = User.all
    if params[:song_id].present?
      @song = Song.find(params[:song_id])
      @users = []
      @song.chords.each do |chord|
        chord.practices.each do |practice|
          @users << practice.user
        end
      end
    end

  end

  private
  def set_user
    @user = User.find(params[:id])
  end
end
