module BooksHelper
  def formatted_genres
    Book.genres.keys.map { |genre| [genre.titleize, genre] }
  end

  def format_genre(genre)
    genre.titleize
  end
end
