class User < ApplicationRecord
  has_many :reservations, dependent: :destroy
  has_one :active_reservation, -> { active }, class_name: 'Reservation'
  has_one :active_reading, through: :active_reservation, source: :book

  devise :database_authenticatable, :registerable, :rememberable, :validatable

  validates :first_name, :last_name, presence: true
  validates :email, uniqueness: true

  scope :admin_users, -> { where(is_admin: true) }

  def actively_reading?
    active_reading.present?
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
