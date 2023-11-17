class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def new; end

  def create; end

  def show; end

  def update; end

  def destroy; end
end
