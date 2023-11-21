class Book < ApplicationRecord
  enum genre: {
    software_engineering: 0,
    science_fiction: 1,
    thriller: 2,
    horror_fiction: 3,
    finances: 4,
    productivity: 5,
  }

  has_many :reservations, dependent: :destroy
  has_one :active_reservation, -> { where(reservations: { returned_on: nil }) }, class_name: 'Reservation'
  has_many :readers, through: :reservations, source: :user
  has_one :active_reader, :through => :active_reservation, :source => :user

  validates :title, :cover_url, presence: true

  scope :available, -> { left_joins(:reservations).where('reservations.returned_on IS NOT NULL OR reservations.book_id IS NULL') }
  scope :reserved, -> { joins(:reservations).where(reservations: { returned_on: nil }) }

  def reserved?
    reservations.where(returned_on: nil).present?
  end
end
