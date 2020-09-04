class LikesController < ApplicationController
  before_action :authority_login, only: [:create, :destroy]

  def create
    @like = Like.new(like_params)
    @like.save

    respond_to do |format|
      format.json
    end
  end

  def destroy
    @like = Like.find_by(like_params)
    @like.destroy
    @chord = @like.chord
    respond_to do |format|
      format.json
    end
  end

  private
    def like_params
      params.permit(:chord_id).merge(user_id: current_user.id)
    end
end
