class Book < ApplicationRecord
  enum genre: {
    software_engineering: 0,
    design: 1,
    project_management: 2,
    ruby: 3,
    rails: 4,
    elixir: 5,
    phoenix: 6,
    android: 7,
    ios: 8,
    finances: 9,
    productivity: 10,
  }

  has_many :reservations, dependent: :destroy
  has_one :active_reservation, -> { where(reservations: { returned_on: nil }) }, class_name: 'Reservation'
  has_many :readers, through: :reservations, source: :user
  has_one :active_reader, :through => :active_reservation, :source => :user

  validates :title, :cover_url, presence: true

  scope :available, -> { left_joins(:reservations).where('reservations.returned_on IS NOT NULL OR reservations.book_id IS NULL') }
  scope :reserved, -> { joins(:reservations).where(reservations: { returned_on: nil }) }

  def available?
    return true if reservations.blank?

    reservations.where.not(returned_on: nil).present?
  end

  def reserved?
    reservations.where(returned_on: nil).present?
  end
end
