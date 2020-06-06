class KeysController < ApplicationController
  def create
    @key = Key.new(key_params)
    @key[:name] = @key[:name].delete!("key of ")
    @key.save

    redirect_to "/songs/#{params[:song_id]}"
  end

  private

  def key_params
    params.permit(:name, :instrumental, :male, :female, :song_id)
  end
end
