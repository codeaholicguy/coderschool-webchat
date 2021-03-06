class MessageMailer < ApplicationMailer

  def new_message(message)
    @message = message
    @url  = ENV['DOMAIN'] + "conversation?friend_id=" + message.sender.id.to_s
    mail(to: @message.recipient.email, subject: 'You have new message')
  end
end
