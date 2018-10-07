class User < ApplicationRecord
  rolify
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?

  belongs_to :company, optional: true

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  def add_points company
    points = self.points
    points = 0 if points.nil?
    multiplier = company.get_overal_rating
    points = points + multiplier
    self.points = points
    self.save
  end

end
