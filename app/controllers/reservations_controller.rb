class ReservationsController < ApplicationController
  before_action :set_reservations

  def index; end

  private

  def set_reservations
    @reservations = current_user.reservations.includes(:book)
  end
end
