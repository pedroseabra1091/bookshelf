require 'rails_helper'

RSpec.describe 'Books', type: :request do
  describe 'GET #index' do
    context 'when logged in' do
      let(:user) { create(:user) }

      before do
        sign_in(user)
        create_list(:book, 5)
      end

      it 'returns existing book collection' do
        get books_path

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('text/html; charset=utf-8')
          expect(response.body).to include(*Book.pluck(:title))
        end
      end
    end

    context 'when logged out' do
      it 'redirects to login' do
        aggregate_failures do
          get books_path

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
