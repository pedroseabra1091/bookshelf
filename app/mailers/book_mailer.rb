class BookMailer < ApplicationMailer
  before_action :set_recipient
  before_action :set_reserver
  before_action :set_book

  default to: -> { @recipient.email }

  def new_reservation
    mail(subject: "New reservation on #{@book.title}")
  end

  def reservation_ending
    mail(subject: "Reservation ending on #{@book.title}")
  end

  private

  def set_recipient
    @recipient = params[:recipient]
  end

  def set_reserver
    @reserver = params[:reserver]
  end

  def set_book
    @book = params[:book]
  end
end
