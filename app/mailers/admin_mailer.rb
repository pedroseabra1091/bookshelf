class AdminMailer < ApplicationMailer
  before_action :set_reserver
  before_action :set_book

  def new_reservation
    mail(subject: "New reservation on #{@book.title}", to: @reserver.email)
  end

  def reservation_ending
    mail(subject: "Reservation ending on #{@book.title}")
  end

  private

  def set_reserver
    @reserver = params[:reserver]
  end

  def set_book
    @book = params[:book]
  end
end
