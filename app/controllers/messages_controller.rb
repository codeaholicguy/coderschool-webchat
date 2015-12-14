class MessagesController < ApplicationController

  def index
  end

  def show
    @friend = User.find(params[:friend_id])
    @messages = Message.conversation(current_user, User.find(params[:friend_id]))
    mark_as_read(@friend)
  end

  def create
    message = Message.new(message_params)
    message.sender = current_user
    message.recipient = User.find(params[:friend_id])
    if !message.save
      MessageMailer.new_messages(message).deliver_later
      flash[:error] = "Something went wrong, try again later."
    end
    redirect_to conversation_path(friend_id: params[:friend_id], friends_page: params[:friends_page], friend_requests_page: params[:friend_requests_page])
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
