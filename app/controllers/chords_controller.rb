class ChordsController < ApplicationController
  before_action :set_chord, only: [:show, :edit, :update, :destroy]
  before_action :authority_login, except: [:index, :show]
  before_action :authority_user, only: [:edit, :update, :destroy]

  def index
    @chords = Chord.all.includes(:song, :user).order(id: "DESC").limit(5)
  end

  def show
    @chord = Chord.find(params[:id])
    @chordunits = @chord.chordunits
  end

  def new
    @chord = Chord.new

    @chordunits = []
    48.times do |i|
      @chordunit = @chord.chordunits.build(address: i)
      @chordunits << @chordunit
    end
  end

  def edit
    @chord = Chord.find(params[:id])
  end

  def create
    @chord = Chord.new(chord_params)
    if @chord.save
      redirect_to @chord, notice: 'コード譜を作成しました' 
    else
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
      params.require(:chord).permit(:song_id, :artist_id, :album_id, :version, :key, chordunits_attributes: [:address, :text, :leftbar, :rightbar, :beat, :id]).merge(user_id: current_user.id)
    end

    def authority_login
      if user_signed_in?
      else
        redirect_to root_path, notice: 'ログイン後、操作してください'
      end
    end

    def authority_user
      if (current_user.id == @chord.user_id) | (current_user.id == 1)
      else
        redirect_back fallback_location: root_path, notice: 'あなたが作成したデータではありません。'
      end
    end

end
