class EnqueueBookProgressEmailJob
  include Sidekiq::Job
  sidekiq_options queue: 'low'

  def perform
    Reservation.active
               .where('created_at < ?', Date.today - 1.month)
               .pluck(:id)
               .each do |reservation_id|
      SendBookProgressEmailJob.perform_async(reservation_id)
    end
  end
end
