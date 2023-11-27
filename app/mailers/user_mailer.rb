class UserMailer < ApplicationMailer
  before_action :set_recipient
  before_action :set_book

  default to: -> { @recipient.email }

  def reading_progress
    mail(subject: "Enjoying #{@book.title}?")
  end

  private

  def set_recipient
    @recipient = params[:recipient]
  end

  def set_book
    @book = params[:book]
  end
end
