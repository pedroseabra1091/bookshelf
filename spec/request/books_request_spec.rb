require 'rails_helper'

RSpec.describe 'Books', type: :request do
  describe 'GET #index' do
    context 'when user is logged in' do
      include_context 'with logged user'

      let(:user) { create(:user) }

      before { create_list(:book, 5) }

      it 'returns existing book collection' do
        get books_path

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('text/html; charset=utf-8')
          expect(response.body).to include(*Book.pluck(:title))
        end
      end
    end

    context "when user is not logged in" do
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

  describe 'POST #create' do
    context 'when user is logged in' do
      include_context 'with logged user'

      context 'when params are valid' do
        let(:books_params) do
          {
            book: {
              title: FFaker::Book.title,
              description: FFaker::Book.description,
              cover_url: FFaker::Book.cover
            }
          }
        end

        it 'creates a new book and redirects' do
          aggregate_failures do
            expect { post books_path(books_params) }.to change(Book, :count).by(1)
            expect(response).to have_http_status(:found)
            expect(response).to redirect_to(books_path)
          end
        end
      end

      context 'when params are invalid' do
        let(:invalid_params) do
          {
            description: FFaker::Book.description
          }
        end

        it 'does not create a new book' do
          aggregate_failures do
            expect { post books_path(invalid_params) }.to raise_error(ActionController::ParameterMissing)
                                                      .and change(Book, :count).by(0)
          end
        end
      end

      context 'when params are missing' do
        let(:missing_params) do
          {
            book: {
              description: FFaker::Book.description
            }
          }
        end

        it 'does not create a new book' do
          aggregate_failures do
            expect { post books_path(missing_params) }.not_to change(Book, :count)
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end
    end

    context "when user is not logged in" do
      it 'redirect to login' do
        aggregate_failures do
          expect { post books_path({}) }.not_to change(Book, :count)
          expect(response).to have_http_status(:found)
        end
      end
    end
  end
end
