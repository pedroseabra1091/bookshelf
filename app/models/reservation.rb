class Reservation < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validate :book_cannot_be_double_reserved, on: :create
  validate :user_cannot_reserve_multiple_books, on: :create
  validate :returned_on_cannot_be_in_the_past
  validate :returned_on_cannot_be_revised, on: :update

  delegate :actively_reading?, to: :user, prefix: :user
  delegate :reserved?, to: :book, prefix: :book, allow_nil: true
  delegate :title, to: :book, prefix: :book, allow_nil: true

  scope :active, -> { where(returned_on: nil) }
  scope :inactive, -> { where.not(returned: nil) }

  def returned?
    returned_on.present?
  end

  private

  def book_cannot_be_double_reserved
    errors.add(:base, :book_already_reserved) if book_reserved?
  end

  def user_cannot_reserve_multiple_books
    errors.add(:base, :user_has_reservations) if user_actively_reading?
  end

  def returned_on_cannot_be_in_the_past
    if(returned_on.present? && returned_on < Date.today)
      errors.add(:returned_on, :past_date)
    end
  end

  def returned_on_cannot_be_revised
    errors.add(:returned_on, :cannot_be_revised) if returned_on_previously_changed?
  end
end
