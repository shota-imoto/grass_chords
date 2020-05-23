class SongsController < ApplicationController
  before_action :set_song, only: [:show, :edit, :update, :destroy]

  # GET /songs
  # GET /songs.json
  def index
    @songs = Song.all
  end

  # GET /songs/1
  # GET /songs/1.json
  def show
    @song = Song.find(params[:id])
  end

  # GET /songs/new
  def new
    @song = Song.new
    @song.keys.build
  end

  # GET /songs/1/edit
  def edit
  end

  # POST /songs
  # POST /songs.json
  def create
    @song = Song.new(song_params)
    respond_to do |format|
      if @song.save
        format.html { redirect_to @song, notice: 'Song was successfully created.' }
        format.json { render :show, status: :created, location: @song }
      else
        format.html { render :new }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /songs/1
  # PATCH/PUT /songs/1.json
  def update
    respond_to do |format|
      if @song.update(song_params)
        format.html { redirect_to @song, notice: 'Song was successfully updated.' }
        format.json { render :show, status: :ok, location: @song }
      else
        format.html { render :edit }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    @song.destroy
    respond_to do |format|
      format.html { redirect_to songs_url, notice: 'Song was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search
    params[:keyword].strip!
    keywords = params[:keyword].split(/\s+/)
    @songs = Song.all.includes(:chords)
    # 条件検索
    # ifによって条件にチェックされているときのみandで絞り込み
    @songs = @songs.where(jam: params[:jam])  if (params[:jam] == "true")
    @songs = @songs.where(standard: params[:standard])  if (params[:standard] == "true")
    @songs = @songs.where(beginner: params[:beginner])  if (params[:beginner] == "true")
    # キーワード検索

    keywords.each do |keyword| unless (params[:keyword].nil?)
      @songs = @songs.where("title like ?", "%#{keyword}%")
    end

    respond_to do |format|
      format.html
      format.json
    end
    
  end
    # if (params[:keyword].nil?)
    # else
    #   keywords.each do |keyword|
    #     @songs = @songs.where("title like ?", "%#{keyword}%")
    #   end
    # end
  end

  def search_page
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def song_params
      params.permit(:title, :jam, :standard, :beginner, keys: [:name, :instrumental, :male, :female]).merge(user_id: current_user.id)
    end

end
