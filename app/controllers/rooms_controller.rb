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

  def get_time
     time = Time.new
     room = Room.all
     last_five_minutes = []
      room.each do |element|
        if (time - element.created_by) <= 300
          last_five_minutes << element
        end
      end
      render json: last_five_minutes
    end

  def top_user
    room =  Room.all.group_by { |room| room.user }
                    .sort_by  { |user, messages| messages.count }
                    .reverse
                    .take(10)
                    .map { |rooms| rooms.first }
    render json: room
  end
end
