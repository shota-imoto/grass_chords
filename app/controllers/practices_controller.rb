class PracticesController < ApplicationController
  def create
    @practice = Practice.new(practice_params)
    @practice.save
    @chord = Chord.find(@practice.chord_id)

  end

  def destroy
    @practice = Practice.find_by(practice_params)
    @practice.destroy

    @chord = @practice.chord
  end


  private
    def practice_params
      params.permit(:chord_id).merge(user_id: current_user.id)
    end

end
