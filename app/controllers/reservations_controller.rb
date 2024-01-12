class ReservationsController < ApplicationController
  before_action :set_reservations, only: [:index]
  before_action :set_active_reservation, only: [:show, :update]

  def index; end

  def show; end

  # TODO: Update errors to use turbo frames
  def update
    result = ReturnBook.new(@active_reservation).perform

    if result.success?
      respond_to do |format|
        format.turbo_stream
        format.json { render json: { reservation: result.reservation }, status: :ok }
      end
    else
      respond_to do |format|
        format.json { render json: { errors: result.errors }, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_reservations
    @reservations = current_user.reservations.includes(:book).order(created_at: :desc)
  end

  def set_active_reservation
    @active_reservation = Reservation.find_by!(user: current_user, returned_on: nil)
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end
end
