class SongsController < ApplicationController
  before_action :set_song, only: [:show, :edit, :update, :destroy]
  before_action :authority_login, except: [:index, :show, :search, :global_search]
  before_action :authority_user, only: [:edit, :update, :destroy]

  def index
    @songs = Song.all
  end

  def show
    @chords = @song.chords.order("likes_count desc")
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
    if @song.update(update_song_params)
      redirect_to @song, notice: '楽曲を更新しました'
    else
      render :edit
    end
  end

  def destroy
    @song.destroy
    redirect_to root_path, notice: '楽曲を削除しました'
  end

  def search
    @songs = Song.all.includes(:chords)

    if params[:sort] == "practice"
      @songs = @songs.order("practice_songs_count desc, title asc")
    else
      @songs = @songs.order("title asc")
    end

    search_song()

    respond_to do |format|
      format.html
      format.json
    end
  end

  
  def global_search
    @songs = Song.all.includes(:chords)

    exchange_global_search_params()
    search_song()

    respond_to do |format|
      format.html{render :search}
      format.json
    end
  end

  end


  private
    def set_song
      @song = Song.find(params[:id])
    end

    def song_params
      params.permit(:title, :jam, :standard, :beginner, :vocal, :instrumental).merge(user_id: current_user.id)
    end

    def update_song_params
      params.require(:song).permit(:title, :jam, :standard, :beginner, :vocal, :instrumental).merge(user_id: current_user.id)
    end

    def authority_login
      if user_signed_in?
      else
        redirect_to root_path, notice: 'ログイン後、操作してください'
      end
    end

    def authority_user
      if (current_user.id == params[:user_id]) | (current_user.admin == 1)
      else
        redirect_back fallback_location: root_path, notice: 'あなたが作成したデータではありません。'
      end
    end

    def search_song
      params[:keyword].strip!
      keywords = params[:keyword].split(/\s+/)
  
      # 条件検索
      # ifによって条件にチェックされているときのみandで絞り込み
      @songs = @songs.where(jam: params[:jam])  if (params[:jam] == "true")
      @songs = @songs.where(standard: params[:standard])  if (params[:standard] == "true")
      @songs = @songs.where(beginner: params[:beginner])  if (params[:beginner] == "true")
      @songs = @songs.where(vocal: params[:vocal])  if (params[:vocal] == "true")
      @songs = @songs.where(instrumental: params[:instrumental])  if (params[:instrumental] == "true")
      # キーワード検索
  
      keywords.each do |keyword| unless (params[:keyword].nil?)
        @songs = @songs.where("title like ?", "%#{keyword}%")
      end
    end

    def exchange_global_search_params
      params[:jam] = params[:jam_global]
      params[:standard] = params[:standard_global]
      params[:beginner] = params[:beginner_global]
      params[:vocal] = params[:vocal_global]
      params[:instrumental] = params[:instrumental_global]
    end
end
