class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :signed_in?, :sign_in, :is_friend, :is_me,
                :is_request_sent, :is_waiting_for_accept, :is_blocked,
                :mark_as_read

  def current_user
    return if !session[:user_id].present?
    @current_user ||= User.find(session[:user_id])
  end

  def signed_in?
    !current_user.nil?
  end

  def require_sign_in
    unless signed_in?
      flash[:warning] = "You must sign in to see this page!"
      redirect_to signin_path
    end
  end

  def skip_if_signed_in
    if signed_in?
      redirect_to messages_path
    end
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def is_friend(user)
    current_user.friendships.find_by(friend: user).present?
  end

  def is_me(user)
    current_user == user
  end

  def is_request_sent(user)
    user.friend_requests.find_by(friend: current_user).present?
  end

  def is_waiting_for_accept(user)
    current_user.friend_requests.find_by(friend: user).present?
  end

  def is_blocked(user)
    current_user.blocked_users.find_by(friend: user).present?
  end

  def mark_as_read(friend)
    messages = Message.unread_message(friend)
    messages.each do |message|
      message.seen = true
      message.save
    end
  end
end
