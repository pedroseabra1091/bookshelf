require 'rails_helper'

RSpec.describe 'Books', type: :request do
  describe 'GET #index' do
    context 'when user is logged in' do
      include_context 'with logged user'

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
        let(:title) { FFaker::Book.title }
        let(:books_params) do
          {
            book: {
              title: title,
              description: FFaker::Book.description,
              cover_url: FFaker::Book.cover
            }
          }
        end

        it 'creates a new book and redirects' do
          aggregate_failures do
            expect { post books_path(books_params) }.to change(Book, :count).by(1)
            expect(response).to redirect_to(books_path)
            expect(response).to have_http_status(:found)
            expect(flash[:notice]).to eq("#{title} was successfully added to the collection!")
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
        let(:validation_errors) { ["Title can't be blank", "Cover url can't be blank"] }

        it 'does not create a new book' do
          aggregate_failures do
            expect { post books_path(missing_params) }.not_to change(Book, :count)
            expect(response).to have_http_status(:unprocessable_entity)
            expect(flash[:alert]).to eq(validation_errors)
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

  describe 'PATCH #update' do
    let!(:book) { create(:book) }

    context 'when user is logged in' do
      include_context 'with logged user'

      context 'when params are valid' do
        let(:new_title) { FFaker::Book.title }
        let(:new_books_params) do
          {
            book: {
              title: new_title,
            }
          }
        end

        it 'creates a new book and redirects' do
          aggregate_failures do
            expect { patch book_path(book, new_books_params) }.to change(Book, :count).by(0)
            expect(response).to redirect_to(books_path)
            expect(response).to have_http_status(:found)
            expect(flash[:notice]).to eq("#{new_title} was successfully updated!")
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
            expect { patch book_path(book, invalid_params) }.to raise_error(ActionController::ParameterMissing)
          end
        end
      end

      context 'when params are missing' do
        let(:missing_params) do
          {
            book: {
              title: nil
            }
          }
        end
        let(:validation_errors) { ["Title can't be blank"] }

        it 'does not create a new book' do
          aggregate_failures do
            expect { patch book_path(book, missing_params) }.not_to change(book, :title)
            expect(response).to have_http_status(:unprocessable_entity)
            expect(flash[:alert]).to eq(validation_errors)
          end
        end
      end
    end

    context "when user is not logged in" do
      let(:new_title) { FFaker::Book.title }

      it 'redirect to login' do
        aggregate_failures do
          expect { post books_path({ book: { title: new_title } }) }.not_to change(book, :title)
          expect(response).to have_http_status(:found)
        end
      end
    end
  end

  describe 'POST #reserve' do
    let(:book) { create(:book) }

    context 'when user is logged in' do
      include_context 'with logged user'

      context 'when params are valid' do
        it 'creates a new reservation and redirects' do
          aggregate_failures do
            expect { post reserve_book_path(book.id) }.to change(Reservation, :count).by(1)
            expect(response).to redirect_to(books_path)
            expect(response).to have_http_status(:found)
            expect(flash[:notice]).to eq("#{book.title} was successfully reserved!")
          end
        end
      end
    end

    context "when user is not logged in" do
      it 'redirect to login' do
        aggregate_failures do
          expect { post reserve_book_path(book.id), as: :json }.to change(Reservation, :count).by(0)
          expect(response).to have_http_status(:unauthorized)
          expect(JSON.parse(response.body)['error']).to eq('You need to sign in or sign up before continuing.')
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:book) { create(:book) }

    context 'when user is logged in' do
      include_context 'with logged user'

      context 'when book exists' do
        it 'destroy books' do
          aggregate_failures do
            expect { delete(book_path(book.id), as: :json) }.to change(Book, :count).by(-1)
            expect(response).to have_http_status(:ok)
          end
        end
      end

      context 'when book does not exist' do
        it 'destroy books' do
          aggregate_failures do
            expect { delete book_path(FFaker::Number.number(digits: 10)) }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end
    end

    context "when user is not logged in" do
      it 'redirect to login' do
        aggregate_failures do
          expect { delete book_path(book.id), as: :json }.to change(Book, :count).by(0)
          expect(response).to have_http_status(:unauthorized)
          expect(JSON.parse(response.body)['error']).to eq('You need to sign in or sign up before continuing.')
        end
      end
    end
  end
end
