class PracticesController < ApplicationController
  before_action :authority_login
  def create
    ActiveRecord::Base.transaction do
      PracticeSong.create_practice_song!(practice_song_params)
      @practice = Practice.new(practice_params)
      @practice.save!
    end
    @chord = Chord.find(@practice.chord_id)
  rescue => e
    logger.error "Transaction Error: practice#create"
    logger.error e
    @error = "システムエラー。画面リロード後に再実行してください"
    # User notices exception error by js.
    #TODO: make "logging error function" DRY.
  end


  def destroy
    @practice = Practice.find_by(practice_destroy_params)
    ActiveRecord::Base.transaction do
      @practice.destroy!
      PracticeSong.destroy_practice_song!(@practice.practice_song_id)
    end
    @chord = @practice.chord
  rescue => e
    logger.error "Transaction Error: practice#destroy"
    logger.error e
    @error = "システムエラー。画面リロード後に再実行してください"
    # User notices exception error by js.
    #TODO: make "logging error function" DRY.
  end


  private
    def practice_params
      params.permit(:chord_id).merge(practice_song_id: PracticeSong.find_by(practice_song_params).id, user_id: current_user.id)
      # params.permit(:chord_id).merge(user_id: current_user.id)
    end

    def practice_song_params
      params.permit.merge(song_id: Chord.find(params[:chord_id]).song.id, user_id: current_user.id)
    end

    def practice_destroy_params
      params.permit(:chord_id).merge(user_id: current_user.id)
    end
end
