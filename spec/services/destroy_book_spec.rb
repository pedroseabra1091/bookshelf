require 'rails_helper'

RSpec.describe DestroyBook do
  let(:book) { create(:book) }
  let(:destroy_book) { described_class.new(book).perform }

  describe '#perform' do
    context 'when book exists' do
      it 'destroys book' do
        destroy_book

        aggregate_failures do
          expect(destroy_book.success?).to eq(true)
        end
      end
    end

    context "when book doesn't exist" do
      it 'does not destroy book' do
        book.destroy
        destroy_book

        aggregate_failures do
          expect(destroy_book.success?).to eq(false)
        end
      end
    end
  end
end
