class SendBookProgressEmailJob
  include Sidekiq::Job

  def perform(reservation_id)
    reservation = Reservation.find(reservation_id)
    UserMailer.with(recipient: reservation.user, book: reservation.book).reading_progress
                                                                        .deliver_now
  end
end
