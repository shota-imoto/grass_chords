class SongsController < ApplicationController
  before_action :set_song, only: [:show, :edit, :update, :destroy, :id_search]
  before_action :set_owner, only: [:edit, :update, :destroy]
  before_action :authority_login, except: [:index, :show, :search, :global_search]
  before_action :authority_user, only: [:edit, :update, :destroy]

  def index
  end

  def new
    @song = Song.new
  end

  def edit
  end

  def create
    @song = Song.new(song_params)
    if @song.save
      redirect_to @song, notice: '楽曲を登録しました'
    else
      flash.now[:notice] = @song.errors.full_messages
      render :new
    end
  end

  def update
    if @song.update(song_params)
      redirect_to @song, notice: '楽曲を更新しました'
    else
      render :edit
    end
  end

  def destroy
    @song.destroy
    redirect_to root_path, notice: '楽曲を削除しました'
  end

  def show
    @chords = @song.chords.order("likes_count desc")
  end

  def search
    @songs = Song.all.includes(:chords)

    # ソート
    if params[:sort] == "practice"
      @songs = @songs.order("practice_songs_count desc, title asc")
    else
      @songs = @songs.order("title asc")
    end

    search_song
    @count = @songs.length
    @pagy, @songs = pagy(@songs)

    respond_to do |format|
      format.html
      format.json
    end
  end


  def global_search
    @songs = Song.all.includes(:chords)
    @songs = @songs.order("title asc")


    params[:jam] = params[:jam_global]
    params[:standard] = params[:standard_global]
    params[:beginner] = params[:beginner_global]
    params[:vocal] = params[:vocal_global]
    params[:instrumental] = params[:instrumental_global]

    search_song

    @count = @songs.length

    @pagy, @songs = pagy(@songs)

    respond_to do |format|
      format.html{render :search}
      format.json
    end
  end

  def id_search
    # set_songアクションを用いて楽曲レコード取得
  end
  private
    def set_song
      @song = Song.find(params[:id])
    end

    def set_owner
      @owner = User.find(@song.user_id)
    end

    def song_params
      params.require(:song).permit(:title, :jam, :standard, :beginner, :vocal, :instrumental).merge(user_id: current_user.id)
    end

    def search_song
      params[:keyword].strip!
      keywords = params[:keyword].split(/\s+/)

      # 条件検索
      @songs = @songs.where_attributes(params)
      # キーワード検索
      keywords.each do |keyword| unless (params[:keyword].nil?)
        @songs = @songs.title_search(keyword)
      end
    end
  end
end
