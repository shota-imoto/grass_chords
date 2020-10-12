class MessagesController < ApplicationController
  def index
    @to_user = User.find(params[:to_user_id])
    @messages = current_user.conversates_with(@to_user.id)
    @message = Message.new
  end

  def list
    from_users = current_user.from_users
    to_users = current_user.to_users

    @users = []
    from_users.each do |from_user|
      from_message = from_user.sent_messages.where(to_user_id: current_user.id).last
      to_message = from_user.received_messages.where(from_user_id: current_user.id).last

      # to_message.present?で相手ユーザ側からのメッセージしかないしかない場合はelseに分岐させる
      # 着信/受信メッセージを比較し、新しい方をuserに結合。
      if to_message.present? && to_message.created_at > from_message.created_at
        from_user.latest_message = to_message.text
        from_user.latest_message_date = to_message.created_at
      else
        from_user.latest_message = from_message.text
        from_user.latest_message_date = from_message.created_at
      end
      @users << from_user
    end
    # HACK: from_usersのeach文と統合できないか
    # HACK: 具体的には①from_usersとto_usersを相手ユーザについて重複なし結合 ②eachループ実行
    # current_user側からのメッセージしか存在しない相手ユーザの抽出
    to_users.each do |to_user|
      unless from_users.include?(to_user)
        to_message = to_user.received_messages.where(from_user_id: current_user.id).last
        to_user.latest_message = to_message.text
        to_user.latest_message_date = to_message.created_at
        @users << to_user
      end
    end
    @users = @users.sort_by(&:latest_message_date).reverse
  end

  def create
    # binding.pry
    @message = Message.new(message_params)
    if @message.save
    else
      flash[:notice] = "メッセージの送信に失敗しました"
    end
    redirect_to messages_path(to_user_id: message_params[:to_user_id])
  end

  private

  def message_params
    params.require(:message).permit(:text, :to_user_id).merge(from_user_id: current_user.id)
  end
end
