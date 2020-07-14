class PracticesController < ApplicationController
  before_action :authority_login
  def create
    PracticeSong.create(practice_song_params) unless PracticeSong.where(practice_song_params).exists?
    @practice = Practice.new(practice_params)
    @practice.save

    @chord = Chord.find(@practice.chord_id)
  end


  def destroy
    @practice = Practice.find_by(practice_destroy_params)

    @practice.destroy
    @practice.practice_song.destroy unless Practice.where(practice_song_id: @practice.practice_song_id).exists?

    @chord = @practice.chord
  end


  private
    def practice_params
      params.permit(:chord_id).merge(practice_song_id: PracticeSong.find_by(practice_song_params).id ,user_id: current_user.id)
    end

    def practice_song_params
      params.permit.merge(song_id: Chord.find(params[:chord_id]).song.id, user_id: current_user.id)
    end

    def practice_destroy_params
      params.permit(:chord_id).merge(user_id: current_user.id)
    end
end
