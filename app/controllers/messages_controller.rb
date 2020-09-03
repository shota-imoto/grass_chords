class MessagesController < ApplicationController
  def index
    @messages = Message.where(to_user_id: params[:to_user_id], from_user_id: current_user.id).or(Message.where(to_user_id: current_user.id, from_user_id: params[:to_user_id]))
    @to_user = User.find(params[:to_user_id])
    @message = Message.new
  end

  def list
    from_users = Message.where(to_user_id: current_user.id).select("from_user_id").distinct
    to_users = Message.where(from_user_id: current_user.id).select("to_user_id").distinct

    @users = []
    from_users.each do |from_user|
      @user = User.find(from_user.from_user_id)
      from_message = Message.where(to_user_id: current_user.id, from_user_id: @user.id).last
      to_message = Message.where(to_user_id: @user.id, from_user_id: current_user.id).last

      # to_message.present?で相手ユーザ側からのメッセージしかないしかない場合はelseに分岐させる
      # 着信/受信メッセージを比較し、新しい方を@userに結合。
      if to_message.present? && to_message.created_at > from_message.created_at
        @user.latest_message = to_message.text
        @user.latest_message_date = to_message.created_at
      else
        @user.latest_message = from_message.text
        @user.latest_message_date = from_message.created_at
      end
      @users << @user
    end
    # HACK: from_usersのeach文と統合できないか
    # HACK: 具体的には①from_usersとto_usersを相手ユーザについて重複なし結合 ②eachループ実行
    # current_user側からのメッセージしか存在しない相手ユーザの抽出
    to_users.each do |to_user|
      if from_users.where(from_user_id: to_user.to_user_id).blank?
        @user = User.find(to_user.to_user_id)
        to_message = Message.where(to_user_id: @user.id, from_user_id: current_user.id).last
        @user.latest_message = to_message.text
        @user.latest_message_date = to_message.created_at
        @users << @user
      end
    end
    @users = @users.sort_by(&:latest_message_date).reverse
  end

  def create
    @message = Message.new(message_params)
    if @message.save
      redirect_to messages_path(to_user_id: message_params[:to_user_id])
    else
      flash.now[:notice] = "メッセージの送信に失敗しました"
      render :index
    end
  end

  private

  def message_params
    params.require(:message).permit(:text, :to_user_id).merge(from_user_id: current_user.id)
  end
end
