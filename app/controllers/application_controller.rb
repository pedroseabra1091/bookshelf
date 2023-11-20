class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :current_user
end
