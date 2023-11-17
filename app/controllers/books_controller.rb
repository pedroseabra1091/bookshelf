class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def new
    @book = Book.new
  end

  def create
    result = CreateBook.new(book_params).perform

    if result.success?
      respond_to do |format|
        format.html { redirect_to books_path }
        format.json { render json: { book: result.product }, status: :created }
      end
    else
      respond_to do |format|
        format.json do
          render json: { errors: result.book.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end

  def show
    @book = Book.find(params[:id])
  end

  def update; end

  def destroy; end

  private

  def book_params
    params.require(:book).permit(:title, :genre, :description, :cover_url, :price)
  end
end
