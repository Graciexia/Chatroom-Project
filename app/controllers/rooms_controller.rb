class RoomsController < ApplicationController
  def index
    render json: Room.all
  end

  def show
    render json: Room.where(user: params[:user])
  end

   def get_room
    render json: Room.where(room: params[:room])
  end


  def create
    begin
      filter_words = ["fuck","shit","ass","bitch"]
      if filter_words.includes?(params[:messages])
        room = Room.create(room: params[:room], user: params[:user], messages: "*******")
        render json: room
      else
        room = Room.create(room: params[:room], user: params[:user], messages: params[:messages])
        render json: room
      end
    rescue ActionController::ParameterMissing => error
      render json: { error: error.message }, status: 422
    end
  end

  def get_time
     time = Time.new
     room = Room.all
     last_five_minutes = []
      room.each do |element|
        if (time - element.created_at) <= 300
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

  def top_room
     room =  Room.all.group_by { |room| room.room }.sort_by  { |room| room.count }.take(3).map { |rooms| rooms.first }
    render json: room
    end

  def last_four_hours_users
     time = Time.new
     room = Room.all
     last_four_hours_users = []
      room.each do |element|
        if (time - element.created_at) <= 14400
          last_four_hours_users << element.user
        end
      end
      render json: last_four_hours_users
  end

  def filter
    room =


end
