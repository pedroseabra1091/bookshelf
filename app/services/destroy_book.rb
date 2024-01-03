class DestroyBook
  Result = Struct.new(:success?, :book, keyword_init: true)

  def initialize(book)
    @book = book
  end

  def perform
    book.destroy!

    Result.new({ success?: true, book: book })
  end

  private

  attr_accessor :book
end
