class RoomsController < ApplicationController
  def index
    render json: Room.all
  end

  def show
    render json: Room.where(user: params[:user])
  end

  def create
    begin
      room = Room.create(room: params[:room], user: params[:user], messages: params[:messages])
      render json: room
      rescue ActionController::ParameterMissing => error
      render json: { error: error.message }, status: 422
    end
  end

  # def top_users
  #   romm = Room.select('user').order("count('messages') desc").limit(5)
  # end
end
