class PracticesController < ApplicationController
  def create
    Practice.create(practice_params)
    respond_to do |format|
      format.html {redirect_to chords_url}
      format.json
    end
  end

  private

  def practice_params
    params.permit(:song_id, :practice_key).merge(user_id: current_user.id)
  end
end
