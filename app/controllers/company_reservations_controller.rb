class CompanyReservationsController < ApplicationController
  before_action :set_active_company_reservations

  def index; end

  private

  def set_active_company_reservations
    @active_company_reservations = Reservation.includes(:user, :book)
                                              .active
                                              .where.not(user_id: current_user.id)
  end
end
