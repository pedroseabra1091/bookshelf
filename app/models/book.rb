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
    finance: 9,
    productivity: 10,
  }

  has_many :reservations, dependent: :destroy
  has_one :active_reservation, -> { where(reservations: { returned_on: nil }) }, class_name: 'Reservation'
  has_many :readers, through: :reservations, source: :user
  has_one :active_reader, through: :active_reservation, source: :user

  validates :title, :cover_url, presence: true

  scope :available, -> { where.not(id: Reservation.where(returned_on: nil).pluck(:book_id)) }
  scope :reserved, -> { joins(:reservations).where(reservations: { returned_on: nil }) }

  def available?
    return true if reservations.blank?

    reservations.order(:id).last.returned_on.present?
  end

  def reserved?
    return false if reservations.blank?

    reservations.order(:id).last.returned_on.blank?
  end
end
