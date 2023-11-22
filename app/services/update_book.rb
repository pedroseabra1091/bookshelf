class UpdateBook
  Result = Struct.new(:success?, :book, :errors, keyword_init: true)

  def initialize(book_id, book_params)
    @book_id = book_id
    @book_params = book_params
  end

  def perform
    book = Book.find(@book_id)
    book.update!(@book_params)

    Result.new({ success?: true, book: book })
  rescue ActiveRecord::RecordNotFound
    Result.new({ success?: false })
  rescue ActiveRecord::RecordInvalid => error
    Result.new({ success?: false, errors: error.record.errors.full_messages })
  end
end
