class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password

  paginates_per 3

  has_many :sent_messages, :class_name => 'Message', :foreign_key => 'sender_id'
  has_many :received_messages, :class_name => 'Message', :foreign_key => 'recipient_id'
  has_many :new_messages, -> { where(:seen => false) }, :class_name => 'Message', :foreign_key => 'recipient_id'
  has_many :friendships, -> { where(:accepted => true, :blocked => false) }
  has_many :blocked_users, -> { where(:blocked => true) }, :class_name => 'Friendship', :foreign_key => 'user_id'
  has_many :friend_requests, -> { where(:accepted => false) }, :class_name => 'Friendship', :foreign_key => 'user_id'

  def self.from_omniauth(auth)
    # Check out the Auth Hash function at https://github.com/mkdynamic/omniauth-facebook#auth-hash
    # and figure out how to get email for this user.
    # Note that Facebook sometimes does not return email,
    # in that case you can use facebook-id@facebook.com as a workaround
    email = auth[:info][:email] || "#{auth[:uid]}@facebook.com"
    # debugger
    # name = auth[:info][:email] || "#{auth[:uid]}@facebook.com"
    user = where(email: email).first_or_initialize
    user.name = auth[:info][:name]
    user.avatar_url = auth[:info][:image]
    user.password = "123456"
    #
    # Set other properties on user here.
    # You may want to call user.save! to figure out why user can't save
    #
    # Finally, return user
    user.save && user
  end

  def self.who_not(user)
    where.not(id: user.id)
  end

end
