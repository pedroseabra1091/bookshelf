# Preview all emails at http://localhost:3000/rails/mailers/book
class BookPreview < ActionMailer::Preview
  def new_reservation
    BookMailer.with(reserver: User.second, recipient: User.first, book: Book.first)
              .new_reservation
  end
end
