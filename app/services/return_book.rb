class ReturnBook
  Result = Struct.new(:success?, :reservation, :errors, keyword_init: true)

  def initialize(reservation_id, user_id)
    @reservation_id = reservation_id
    @user_id = user_id
  end

  def perform
    reservation = Reservation.find(@reservation_id)
    reservation.update(returned_on: Date.today)
    deliver_return_notification(reservation)

    Result.new({ success?: true, reservation: reservation })
  rescue ActiveRecord::RecordNotFound
    Result.new({ success?: false })
  rescue ActiveRecord::RecordInvalid => error
    Result.new({ success?: false, errors: error.record.errors.full_messages })
  end

  private

  def deliver_return_notification(reservation)
    User.admin_users.each do |user|
      BookMailer.with(reserver: reservation.user, recipient: user, book: reservation.book)
                .reservation_ending
                .deliver_now
    end
  end
end
