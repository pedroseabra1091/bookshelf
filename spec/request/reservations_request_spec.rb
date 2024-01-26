require 'rails_helper'

RSpec.describe 'Reservation', type: :request do
  describe 'GET #index' do
    context 'when user is logged in' do
      include_context 'with logged user'

      before { create(:reservation, user: user) }

      it 'returns existing book collection' do
        get reservations_path

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('text/html; charset=utf-8')
          expect(response.body).to include(Reservation.find_by(user: user).book.title)
        end
      end
    end

    context "when user is not logged in" do
      it 'redirects to login' do
        get reservations_path

        aggregate_failures do
          expect(response).to redirect_to(new_user_session_path)
          expect(response).to have_http_status(:found)
          expect(response.content_type).to eq('text/html; charset=utf-8')
        end
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user is logged in' do
      include_context 'with logged user'

      context 'when reservation is active' do
        let(:reservation) { create(:reservation, user: user) }

        it 'finishes a reservation' do
          patch(reservation_path(reservation.id), as: :json)

          aggregate_failures do
            expect(reservation.reload.returned_on).to_not eq(nil)
            expect(response).to have_http_status(:ok)
          end
        end
      end

      context 'when reservation is inactive' do
        let(:reservation) { create(:reservation, :returned, user: user) }

        it 'raises an exception' do
          patch reservation_path(reservation.id)

          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'when is not logged in' do
      let(:reservation) { create(:reservation) }

      it 'redirects to login' do
        patch reservation_path(reservation.id)

        aggregate_failures do
          expect(response).to redirect_to(new_user_session_path)
          expect(response).to have_http_status(:found)
          expect(response.content_type).to eq('text/html; charset=utf-8')
        end
      end
    end
  end
end
