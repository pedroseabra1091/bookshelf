class DestroyBook
  Result = Struct.new(:success?, :book, keyword_init: true)

  def initialize(book_id)
    @book_id = book_id
  end

  def perform
    book = Book.find_by!(id: @book_id)
    book.destroy!

    Result.new({ success?: true, book: book })
  rescue ActiveRecord::RecordNotFound
    Result.new({ success?: false })
  end
end
