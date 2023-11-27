class ReturnBook
  Result = Struct.new(:success?, :reservation, :errors, keyword_init: true)

  def initialize(reservation_id, user_id)
    @reservation_id = reservation_id
    @user_id = user_id
  end

  def perform
    reservation = Reservation.find(@reservation_id)
    reservation.update(returned_on: Date.today)
    send_return_notification(reservation)

    Result.new({ success?: true, reservation: reservation })
  rescue ActiveRecord::RecordNotFound
    Result.new({ success?: false })
  rescue ActiveRecord::RecordInvalid => error
    Result.new({ success?: false, errors: error.record.errors.full_messages })
  end

  private

  def send_return_notification(reservation)
    User.admin_users.each do |user|
      SendEndingReservationEmailJob.perform_async(@user_id, user.id, reservation.book_id)
    end
  end
end
