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
    begin
      if display_range_seconds <= 0
        raise InvalidData
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
    rescue Exception => error
      render json: { error: error.message + " --- time range must be expressed as seconds >= 1."}, status: 422
    end
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
    begin
      if display_range_seconds <= 0
        raise InvalidData
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
    rescue Exception => error
      render json: { error: error.message + " --- time range must be expressed as seconds >= 1."}, status: 422
    end
  end

  def get_history
    room = Room.all
    chat_history = []
    begin
      time_start = Time.parse(params[:start_date])
      time_end = Time.parse(params[:end_date])

      if time_start == time_end
        room.each do |element|
          if element.created_at.strftime("%m-%d-%Y") == time_start.strftime("%m-%d-%Y")
            chat_history << element
          end
        end

        render json:  chat_history

      else
        room.each do |element|
          if (time_start - element.created_at) < 0 && (element.created_at - time_end) < 0
            chat_history << element
          end
        end
        render json: chat_history
        logger.debug "hihihi"
      end
    rescue Exception => error
      render json: { error: error.message + " --- specified date format is not valid."}, status: 422
    end
  end

  def show_error
    begin
      raise InvalidPage
    rescue Exception => error
      render json: { error: error.message + " --- the specified URL is not valid."}, status: 422
    end
  end
end
