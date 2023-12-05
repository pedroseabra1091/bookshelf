class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy reserve]

  def index
    @books = Book.all.order(created_at: :asc)
  end

  def show; end

  def new
    @book = Book.new
  end

  def edit; end

  def create
    result = CreateBook.new(book_params).perform

    if result.success?
      respond_to do |format|
        format.html do
          redirect_to(books_path, notice: I18n.t('books.create.success', title: result.book.title))
        end
        format.json { render json: { book: result.book }, status: :created }
      end
    else
      respond_to do |format|
        format.html do
          flash.now[:alert] = result.errors
          render :new, status: :unprocessable_entity
        end
        format.json { render json: { errors: result.errors }, status: :unprocessable_entity }
      end
    end
  end

  def update
    result = UpdateBook.new(@book, book_params).perform

    if result.success?
      respond_to do |format|
        format.html do
          redirect_to(books_path, notice: I18n.t('books.update.success', title: result.book.title))
        end
        format.json { render json: { book: result.book }, status: :ok }
      end
    else
      respond_to do |format|
        format.html do
          flash.now[:alert] = result.errors
          render :edit, status: :unprocessable_entity
        end
        format.json do
          render json: { errors: result&.errors }, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    result = DestroyBook.new(@book).perform

    if result.success?
      respond_to do |format|
        format.turbo_stream
        format.json { head :ok }
      end
    else
      respond_to { |format| format.json { head :unprocessable_entity } }
    end
  end

  def reserve
    result = ReserveBook.new(@book, current_user.id).perform

    if result.success?
      respond_to do |format|
        format.html do
          redirect_to(books_path, notice: I18n.t('books.reserve.success', title: result.reservation.book_title))
        end
        format.json { render json: { reservation: result.reservation }, status: :created }
      end
    else
      respond_to do |format|
        format.html do
          flash.now[:alert] = result&.errors
          render :show, status: :unprocessable_entity
        end
        format.json { render json: { errors: result&.errors }, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :genre, :description, :cover_url)
  end
end
