require 'rails_helper'

RSpec.describe ReserveBook do
  let(:book) { create(:book) }
  let(:user) { create(:user) }
  let!(:admin_user) { create(:user, :is_admin) }
  let(:reserve_book) { described_class.new(book, user.id).perform }

  describe '#perform' do
    context "when book and user meet reservation criteria" do
      it 'a new reservation is created' do
        aggregate_failures do
          expect { reserve_book }.to change(Reservation, :count).by(1)
          expect(reserve_book.success?).to eq(true)
          expect(SendNewReservationEmailJob).to have_enqueued_sidekiq_job(user.id, admin_user.id, book.id)
        end
      end
    end

    context 'when user already has an active reservation' do
      before { create(:reservation, user: user) }

      it 'a user double booking validation is raised' do
        aggregate_failures do
          expect { reserve_book }.not_to change(Reservation, :count)
          expect(reserve_book.success?).to eq(false)
          expect(*reserve_book.errors).to eq('You already have a ongoing reservation.')
          expect(SendNewReservationEmailJob).not_to have_enqueued_sidekiq_job(any_args)
        end
      end
    end

    context "when book isn't available" do
      before { create(:reservation, book: book) }

      it 'a book double booking validation is raised' do
        aggregate_failures do
          book.reload
          expect { reserve_book }.not_to change(Reservation, :count)
          expect(reserve_book.success?).to eq(false)
          expect(*reserve_book.errors).to eq('Book is already reserved.')
          expect(SendNewReservationEmailJob).not_to have_enqueued_sidekiq_job(any_args)
        end
      end
    end
  end
end
