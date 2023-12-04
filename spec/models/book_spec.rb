require 'rails_helper'

RSpec.describe Book, type: :model do
  subject(:book) { build(:book) }

  describe 'validations' do
    it { expect(book).to be_valid }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:cover_url) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:reservations) }
    it { is_expected.to have_one(:active_reservation) }
    it { is_expected.to have_many(:readers) }
    it { is_expected.to have_one(:active_reader) }
  end

  describe 'scopes' do
    context 'newly added boooks' do
      before { create_list(:book, 5) }

      it 'correctly returns all available books' do
        aggregate_failures do
          expect(Book.available.count).to eq(5)
        end
      end
    end

    context 'books with reservation history' do
      before do
        5.times do
          book = create(:book)
          create(:reservation, :returned, book: book)
          create(:reservation, book: book)
        end

        5.times do
          book = create(:book)
          create(:reservation, book: book)
        end

        5.times do
          book = create(:book)
          create(:reservation, :returned, book: book)
        end
      end

      it 'correctly returns all available and reserved books' do
        aggregate_failures do
          expect(Book.available.count).to eq(5)
          expect(Book.reserved.count).to eq(10)
        end
      end
    end
  end
end
