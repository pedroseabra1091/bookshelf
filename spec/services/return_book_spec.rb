require 'rails_helper'

RSpec.describe ReturnBook do
  let!(:admin_user) { create(:user, :is_admin) }
  let(:return_book) { described_class.new(reservation).perform }

  describe '#perform' do
    context 'on a active reservation' do
      let(:reservation) { create(:reservation) }

      it 'a returned date is imprinted in the reservation' do
        return_book

        aggregate_failures do
          expect(reservation.returned_on).to eq(Date.today)
          expect(SendEndingReservationEmailJob).to have_enqueued_sidekiq_job(
            reservation.user_id, admin_user.id, reservation.book_id
          )
          expect(return_book.success?).to eq(true)
        end
      end
    end

    context 'on a closed reservation' do
      let!(:reservation) { create(:reservation, returned_on: Date.tomorrow) }

      it 'a cannot be closed twice validation is raised' do
        return_book

        aggregate_failures do
          expect(reservation.reload.returned_on).to eq(Date.tomorrow)
          expect(SendEndingReservationEmailJob).not_to have_enqueued_sidekiq_job(any_args)
          expect(return_book.success?).to eq(false)
          expect(return_book.errors.first).to eq('Returned on cannot be revised.')
        end
      end
    end
  end
end
