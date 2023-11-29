class DestroyBook
  Result = Struct.new(:success?, :book, keyword_init: true)

  def initialize(book)
    @book = book
  end

  def perform
    book.destroy!

    Result.new({ success?: true, book: book })
  rescue ActiveRecord::RecordNotFound
    Result.new({ success?: false })
  end

  private

  attr_accessor :book
end
