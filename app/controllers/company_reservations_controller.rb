class CompanyReservationsController < ApplicationController
  before_action :set_ongoing_reservations

  def index; end

  private

  def set_ongoing_reservations
    @ongoing_company_reservations = Reservation.includes(:user, :book)
                                               .active
                                               .where.not(user_id: current_user.id)
  end
end
