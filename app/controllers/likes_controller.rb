class LikesController < ApplicationController
  def create
    @like = Like.new(like_params)
    @like.save
    @chord = Chord.find(@like.chord_id)

  end

  def destroy
    @like = Like.find_by(like_params)
    @like.destroy

    @chord = @like.chord
  end


  private
    def like_params
      params.permit(:chord_id).merge(user_id: current_user.id)
    end

end