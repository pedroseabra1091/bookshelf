require 'rails_helper'

RSpec.describe UpdateBook do
  let(:book) { create(:book) }
  let(:update_book) { described_class.new(book, book_params).perform }

  describe '#perform' do
    context 'when params are valid' do
      let(:new_title) { FFaker::Book.title }
      let(:new_description) { FFaker::Book.description }
      let(:book_params) do
        {
          title: new_title,
          description: new_description,
        }
      end

      it 'updates a book' do
        update_book

        aggregate_failures do
          expect(update_book.success?).to eq(true)
          expect(Book.last.title).to eq(new_title)
          expect(Book.last.description).to eq(new_description)
        end
      end
    end

    context "when params are invalid" do
      let(:book_params) do
        {
          title: nil,
        }
      end

      it 'does not create a book' do
        update_book

        aggregate_failures do
          expect(update_book.success?).to eq(false)
          expect(update_book.errors.first).to eq("Title can't be blank")
        end
      end
    end
  end
end
