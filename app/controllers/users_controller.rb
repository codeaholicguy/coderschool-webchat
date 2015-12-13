class UsersController < ApplicationController
  before_action :require_sign_in, only: [:index]
  before_action :skip_if_signed_in, only: [:create, :new]

  def new
    @user = User.new
  end

  def index
    @users = User.who_not(current_user).page params[:users_page]
  end

  def show
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to messages_path
    else
      render 'new'
    end
  end

  def send_friend_request
    user = User.find(params[:friend_id])
    friendship = Friendship.new()
    friendship.friend = current_user
    friendship.user = user
    user.friend_requests << friendship
    if user.save
      flash[:success] = "Request sent to #{friendship.friend.name}."
    else
      flash[:error] = "Something went wrong, try again later."
    end
    redirect_to users_path(users_page: params[:users_page])
  end

  def accept_friend_request
    friendship = current_user.friend_requests.find_by(friend_id: params[:friend_id])
    friendship.accepted = true
    current_user.friendships << friendship
    friend = User.find(params[:friend_id])
    friend.friendships << Friendship.new(user: friend, friend: current_user, accepted: true)

    if current_user.save && friend.save
      flash[:success] = "#{friendship.friend.name} added to your friend list."
    else
      flash[:error] = "Something went wrong, try again later."
    end

    if params[:on] == 'user'
      redirect_to users_path
    else
      redirect_to messages_path
    end
  end

  def reject_friend_request
    friendship = current_user.friend_requests.find_by(friend_id: params[:friend_id])

    if !friendship.destroy
      flash[:error] = "Something went wrong, try again later."
    end

    if params[:on] == 'user'
      redirect_to users_path
    else
      redirect_to messages_path
    end
  end

  def cancel_friend_request
    friendship = User.find(params[:friend_id]).friend_requests.find_by(friend_id: current_user.id)

    if !friendship.destroy
      flash[:error] = "Something went wrong, try again later."
    end
    redirect_to users_path(users_page: params[:users_page])
  end

  private

  def user_params
    params.require(:user).permit(:name, :password, :email)
  end

end
