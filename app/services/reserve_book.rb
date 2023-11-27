class ReserveBook
  Result = Struct.new(:success?, :reservation, :errors, :book, keyword_init: true)

  def initialize(book_id, user_id)
    @book_id = book_id
    @user_id = user_id
  end

  def perform
    book = Book.find(@book_id)
    reservation = Reservation.create!(book: book, user_id: @user_id)
    send_reservation_notification(reservation)

    Result.new({ success?: true, reservation: reservation })
  rescue ActiveRecord::RecordNotFound
    Result.new({ success?: false })
  rescue ActiveRecord::RecordInvalid => error
    Result.new({ success?: false, errors: error.record.errors.full_messages, book: book })
  end

  private

  def send_reservation_notification(reservation)
    User.admin_users.each do |user|
      SendNewReservationEmailJob.perform_async(reservation.user_id, user.id, reservation.book_id)
    end
  end
end
