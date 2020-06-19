class ChordsController < ApplicationController
  before_action :set_chord, only: [:show, :edit, :update, :destroy]
  before_action :authority_login, except: [:index, :show]
  before_action :authority_user, only: [:edit, :update, :destroy]

  # GET /chords
  # GET /chords.json
  def index
    @chords = Chord.all.includes(:song, :user).order(id: "DESC").limit(5)
  end

  # GET /chords/1
  # GET /chords/1.json
  def show
    @chord = Chord.find(params[:id])
    @chordunits = @chord.chordunits
  end

  # GET /chords/new
  def new
    @chord = Chord.new
    @chord.chordunits.build
  end

  # GET /chords/1/edit
  def edit
    @chord = Chord.find(params[:id])
  end

  # POST /chords
  # POST /chords.json
  def create
    @chord = Chord.new(chord_params)
    if @chord.save
      redirect_to @chord, notice: 'コード譜を作成しました' 
    else
      redirect_to @chord
    end

  end

  # PATCH/PUT /chords/1
  # PATCH/PUT /chords/1.json
  def update
    @chord.update(chord_params)
    redirect_to @chord, notice: 'コード譜を編集しました'
  end

  # DELETE /chords/1
  # DELETE /chords/1.json
  def destroy
    @chord.destroy
    redirect_to root_path, notice: 'コード譜を削除しました'

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chord
      @chord = Chord.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def chord_params
      params.require(:chord).permit(:song_id, :artist_id, :album_id, :version, chordunits_attributes: [:address, :text, :leftbar, :rightbar, :beat, :id]).merge(user_id: current_user.id)
    end

    def authority_login
      if user_signed_in?
      else
        redirect_to root_path, notice: 'ログイン後、操作してください'
      end
    end


    def authority_user
      if (current_user.id == params[:user_id]) | (current_user.id == 1)
      else
        redirect_back fallback_location: root_path, notice: 'あなたが作成したデータではありません。'
      end
    end
end
