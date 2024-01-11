require 'rails_helper'

RSpec.describe 'Reservation', type: :request do
  describe 'GET #index' do
    context 'when user is logged in' do
      include_context 'with logged user'

      let(:user) { create(:user) }

      before { create(:reservation, user: user) }

      it 'returns existing book collection' do
        get reservations_path

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('text/html; charset=utf-8')
          expect(response.body).to include(*Reservation.find_by(user: user).book.title)
        end
      end
    end

    context "when user is not logged in" do
      it 'redirects to login' do
        aggregate_failures do
          get reservations_path

          aggregate_failures do
            expect(response).to redirect_to(new_user_session_path)
            expect(response).to have_http_status(:found)
            expect(response.content_type).to eq('text/html; charset=utf-8')
          end
        end
      end
    end
  end
end
