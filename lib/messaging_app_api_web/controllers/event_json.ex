defmodule MessagingAppApiWeb.EventJSON do
  alias MessagingAppApi.{Event, ChatRoom}

  def list(%{events: events}) do
    %{data: for(event <- events, do: data(event))}
  end


  def show(%{event: event}) do
    %{data: data(event)}
  end

   def show(%{chat_room: chat_room }) do
    %{data: data(chat_room)}
  end

  defp data(%Event{} = event) do
    %{
      id: event.id,
      name: event.name, 
      description: event.description,
      start_time: NaiveDateTime.to_string(event.start_time), 
      end_time: NaiveDateTime.to_string(event.end_time), 
      location: event.location,
    } 
  end

  defp data(%ChatRoom{} = chat_room) do
    %{
      chat_room_id: chat_room.id,
      chat_room_status: chat_room.status
      } 
  end

 end
