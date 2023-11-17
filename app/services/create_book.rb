class CreateBook
  Result = Struct.new(:success?, :book, :error, keyword_init: true)

  def initialize(book_params)
    @book_params = book_params
  end

  def perform
    book = Book.create!(@book_params)

    Result.new({ success?: true, book: book })
  rescue ActiveRecord::RecordInvalid => error
    Result.new({ success?: false, book: error.record })
  end
end
