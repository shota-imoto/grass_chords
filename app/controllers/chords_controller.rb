class ChordsController < ApplicationController
  before_action :set_chord, only: [:show, :edit, :update, :destroy]

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
end
