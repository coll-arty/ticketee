class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :not_archived, -> { where(archived_at: nil) }

  def to_s
    "#{email} (#{admin? ? 'Admin' : 'User'})"
  end

  def archive
    self.update(archived_at: Time.now)
  end

  # Overwrite Devise's default method.
  def active_for_authentication?
    super && archived_at.nil?
  end

  # Another Devise's overwrite.
  def inactive_message
    archived_at.nil? ? super : :archived
  end
end
