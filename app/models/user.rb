class User < ApplicationRecord
  has_many :reservations, dependent: :destroy
  has_one :active_reservation, -> { where(reservations: { returned_on: nil }) }, class_name: 'Reservation'
  has_one :active_reading, through: :active_reservation, source: :book

  devise :database_authenticatable, :registerable, :rememberable, :validatable

  validates :first_name, :last_name, presence: true

  def actively_reading?
    active_reading.present?
  end
end
