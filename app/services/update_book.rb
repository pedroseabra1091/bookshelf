class UpdateBook
  Result = Struct.new(:success?, :book, :errors, keyword_init: true)

  def initialize(book, book_params)
    @book = book
    @book_params = book_params
  end

  def perform
    book.update!(@book_params)

    Result.new({ success?: true, book: book })
  rescue ActiveRecord::RecordInvalid => error
    Result.new({ success?: false, errors: error.record.errors.full_messages })
  end

  private

  attr_accessor :book
end
