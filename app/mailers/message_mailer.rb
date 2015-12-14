class MessageMailer < ApplicationMailer

  def new_messages(message)
    @message = message
    @url  = ENV['DOMAIN'] + "conversation?friend_id=" + message.sender.id
    mail(to: @message.recipient.email, subject: 'You have new message')
  end

end
