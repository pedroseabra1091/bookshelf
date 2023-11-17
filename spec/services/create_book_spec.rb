require 'rails_helper'

RSpec.describe CreateBook do
  let(:create_book) { described_class.new(book_params).perform }

  describe '#perform' do
    context 'when params are valid' do
      let(:book_params) do
        {
          title: FFaker::Book.title,
          genre: Book.genres.keys.sample,
          description: FFaker::Book.description,
          cover_url: FFaker::Book.cover,
          price: FFaker::Number.decimal
        }
      end

      it 'creates a book' do
        aggregate_failures do
          expect { create_book }.to change(Book, :count).by(1)
          expect(create_book.success?).to eq(true)
          expect(Book.last.title).to eq(book_params[:title])
          expect(Book.last.genre).to eq(book_params[:genre])
          expect(Book.last.description).to eq(book_params[:description])
          expect(Book.last.cover_url).to eq(book_params[:cover_url])
          expect(Book.last.price).to eq(book_params[:price])
        end
      end
    end

    context "when params are invalid" do
      let(:book_params) do
        {
          title: nil,
          genre: Book.genres.keys.sample,
          description: FFaker::Book.description,
          cover_url: nil,
          price: -10.50
        }
      end
      let(:expected_error_messages) do
        ["Title can't be blank", "Cover url can't be blank", "Price must be greater than 0"]
      end

      it 'does not create a book' do
        aggregate_failures do
          expect { create_book }.not_to change(Book, :count)
          expect(create_book.success?).to eq(false)
          expect(create_book.book.errors.full_messages).to eq(expected_error_messages)
        end
      end
    end
  end
end
