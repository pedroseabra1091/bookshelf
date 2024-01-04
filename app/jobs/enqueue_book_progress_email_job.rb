class EnqueueBookProgressEmailJob
  include Sidekiq::Job
  sidekiq_options queue: 'low'

  def perform
    Reservation.where.not(returned_on: nil)
               .where('created_at < ?', Date.today - 3.months)
               .pluck(:id)
               .each do |reservation_id|
      SendBookProgressEmailJob.perform_async(reservation_id)
    end
  end
end
