class ChordsController < ApplicationController
  before_action :set_chord, only: [:show, :edit, :update, :destroy]
  before_action :set_owner, only: [:edit, :update, :destroy]
  before_action :authority_login, except: [:index, :show]
  before_action :authority_user, only: [:edit, :update, :destroy]

  def index
  end

  def show
    @chord = Chord.find(params[:id])
    @chordunits = @chord.chordunits
  end

  def new
    @chord = Chord.new(song_id: params[:song_id])
    @chordunits = []
    $chordunit_num.times do |i|
      @chordunit = @chord.chordunits.build(address: i)
      @chordunits << @chordunit
    end
  end

  def edit
  end

  def create
    @chord = Chord.new(chord_params)
    if @chord.save
      redirect_to @chord, notice: 'コード譜を作成しました'
    else
      @chord.errors.full_messages.each do |message|
        flash.now[:notice] = message
      end
      render :new
    end

  end

  def update
    if @chord.update(chord_params)
      redirect_to @chord, notice: 'コード譜を編集しました'
    else
      render :edit
    end
  end

  def destroy
    @chord.destroy
    redirect_to song_path(@chord.song_id), notice: 'コード譜を削除しました'
  end

  private
    def set_chord
      @chord = Chord.find(params[:id])
    end

    def chord_params
      params.require(:chord).permit(:song_id, :artist_id, :album_id, :version, :key, chordunits_attributes: [:address, :text, :leftbar, :rightbar, :beat, :id, :indicator, :repeat, :part]).merge(user_id: current_user.id)
    end

    def set_owner
      @owner = User.find(@chord.user_id)
    end

end
