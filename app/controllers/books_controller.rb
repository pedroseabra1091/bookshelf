class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
  end

  def edit
    @book = Book.find(params[:id])
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
          render json: { errors: result.errors }, status: :unprocessable_entity
        end
      end
    end
  end


  def update
    result = UpdateBook.new(params[:id], book_params).perform

    if result.success?
      respond_to do |format|
        format.html { redirect_to books_path }
        format.json { render json: { book: result.product }, status: :ok }
      end
    else
      respond_to do |format|
        format.json do
          render json: { errors: result.book.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end

  # TODO: Add turbo
  def destroy
    result = DestroyBook.new(params[:id]).perform

    if result.success?
      respond_to do |format|
        format.json { head :ok }
      end
    else
      respond_to do |format|
        format.json { head :unprocessable_entity }
      end
    end
  end

  def reserve
    result = ReserveBook.new(params[:id], current_user.id).perform

    if result.success?
      respond_to do |format|
        format.html { redirect_to books_path }
        format.json do
          render json: { reservation: result.reservation }, status: :created
        end
      end
    else
      respond_to do |format|
        format.html do
          render json: { errors: result&.errors }, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :genre, :description, :cover_url)
  end
end
