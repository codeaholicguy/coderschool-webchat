class Message < ActiveRecord::Base
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"

  validates :sender, presence: true
  validates :recipient, presence: true
  validates :body, presence: true

  paginates_per 4

  def self.conversation(user1, user2)
    where(:sender => [user1, user2], :recipient => [user1, user2]).order(created_at: :desc)
  end

  def self.unread_message(friend)
    where(:sender => friend, :seen => false)
  end

end
