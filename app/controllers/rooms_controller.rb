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
      room = Room.create(room: params[:room], user: params[:user], messages: Swearjar.default.censor(params[:messages]))
      render json: room
      if params[:messages] == "amiright"
        room = Room.create(room: params[:room], user: "room master", messages: "you are so right")
        # render json: room
      end
    rescue ActionController::ParameterMissing => error
      render json: { error: error.message }, status: 422
    end
  end

  def get_time
    # logger.debug "[" + params[:display_range_seconds].to_s + "]"
    if params[:display_range_seconds] == nil
      display_range_seconds = 300 # defaul to display the last 5 minutes
    else
      display_range_seconds = params[:display_range_seconds].to_i
    end
    time = Time.new
    room = Room.all
    display_messages = []
    room.each do |element|
      if (time - element.created_at) <= display_range_seconds
        display_messages << element
      end
    end
    render json: display_messages
  end

  def top_user
    top_users = Room.all
                   .group_by { |room| room.user }
                   .sort_by  { |user, messages| messages.count }
                   .reverse
                   .take(10)
                   .map { |rooms| rooms.first }
    top_users = top_users - ["room master"]
    render json: top_users
  end

  def top_room
    room =  Room.all.group_by { |room| room.room }
                    .sort_by  { |room| room.count }
                    .take(3)
                    .map { |rooms| rooms.first }
    render json: room
  end

  def chatted_recently
    if params[:display_range_seconds] == nil
      display_range_seconds = 14400 # defaul to display the last 4 hours
    else
      display_range_seconds = params[:display_range_seconds].to_i
    end
    time = Time.new
    room = Room.all
    recent_chats = []
    room.each do |element|
      if (time - element.created_at) <= display_range_seconds
        recent_chats << element
      end
    end
    recent_chats = recent_chats.group_by { |room| room.user }
                               .map { |rooms| rooms.first }
    recent_chats = recent_chats - ["room master"]
    render json: recent_chats
  end

  # def get_history
  #   render json: Room.where(created_at: < params[:created_at],  updated_at: > params[:updated_at])
  # end
end
