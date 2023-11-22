class ReserveBook
  Result = Struct.new(:success?, :reservation, :errors, keyword_init: true)

  def initialize(book_id, user_id)
    @book_id = book_id
    @user_id = user_id
  end

  def perform
    book = Book.find(@book_id)
    reservation = Reservation.create!(book: book, user_id: @user_id)
    deliver_reservation_notification(reservation)

    Result.new({ success?: true, reservation: reservation })
  rescue ActiveRecord::RecordNotFound
    Result.new({ success?: false })
  rescue ActiveRecord::RecordInvalid => error
    Result.new({ success?: false, errors: error.record.full_messages })
  end

  private

  def deliver_reservation_notification(reservation)
    User.admin_users.each do |user|
      BookMailer.with(reserver: reservation.user, recipient: user, book: reservation.book)
                .new_reservation
                .deliver_now
    end
  end
end
