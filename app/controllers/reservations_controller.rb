class ReservationsController < ApplicationController
  before_action :set_reservations, on: [:index]

  def index; end

  def update
    result = ReturnBook.new(params[:id], current_user.id).perform

    if result.success?
      respond_to do |format|
        format.json { render json: { reservation: result.reservation }, status: :ok }
      end
    else
      respond_to do |format|
        format.json do
          render json: { errors: result.errors }, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def set_reservations
    @reservations = current_user.reservations.includes(:book).order(:created_at)
  end
end
