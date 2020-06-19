class SongsController < ApplicationController
  before_action :set_song, only: [:show, :edit, :update, :destroy]
  before_action :authority_login, except: [:index, :show, :search]
  before_action :authority_user, only: [:edit, :update, :destroy]

  def index
    @songs = Song.all
  end

  def show
    @song = Song.find(params[:id])
  end

  def new
    @song = Song.new
    @song.keys.build
  end

  def edit
    @song = Song.find(params[:id])
  end

  def create
    @song = Song.new(song_params)
    respond_to do |format|
      if @song.save
        format.html { redirect_to @song, notice: '楽曲を登録しました' }
        format.json { render :show, status: :created, location: @song }
      else
        format.html { render :new }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @song.update(update_song_params)
        format.html { redirect_to @song, notice: '楽曲を更新しました' }
        format.json { render :show, status: :ok, location: @song }
      else
        format.html { render :edit }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @song.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: '楽曲を削除しました' }
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
    @songs = @songs.where(vocal: params[:vocal])  if (params[:vocal] == "true")
    @songs = @songs.where(instrumental: params[:instrumental])  if (params[:instrumental] == "true")
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
      params.permit(:title, :jam, :standard, :beginner, :vocal, :instrumental).merge(user_id: current_user.id)
    end

        # Only allow a list of trusted parameters through.
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
      if (current_user.id == params[:user_id]) | (current_user.id == 1)
      else
        redirect_back fallback_location: root_path, notice: 'あなたが作成したデータではありません。'
      end
    end

end
