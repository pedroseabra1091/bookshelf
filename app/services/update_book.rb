class UpdateBook
  Result = Struct.new(:success?, :book, :error, keyword_init: true)

  def initialize(book_id, book_params)
    @book_id = book_id
    @book_params = book_params
  end

  def perform
    book = Book.find_by!(id: @book_id)
    book.update!(@book_params)

    Result.new({ success?: true, book: book })
  rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid => error
    Result.new({ success?: false, book: error.record })
  end
end
