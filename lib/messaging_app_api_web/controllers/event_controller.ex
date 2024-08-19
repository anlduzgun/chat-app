defmodule MessagingAppApiWeb.EventController do
  use MessagingAppApiWeb, :controller
  
  alias MessagingAppApi.{ChatRoom, Event, DateTimeUtils}
    
  alias MessagingAppApi.Context.ChatRoom, as: ChatRoom_context
  alias MessagingAppApi.Context.Event, as: Event_context
  action_fallback MessagingAppApiWeb.FallbackController


  @doc """
  Creates an event along with its associated chat room.

  ## Parameters:
  - `name` (string): The name of the event.
  - `description` (string): A brief description of the event.
  - `location` (string): The location where the event will take place.
  - `start_time` (string): The start time of the event in the format "YYYY-MM-DD HH:MM:SS".
  - `end_time` (string): The end time of the event in the format "YYYY-MM-DD HH:MM:SS".

  ## Example Usage:

  Request Body:

  ```json
  {
    "event": {
      "name": "concert",
      "description": "A great music concert",
      "location": "Antalya",
      "start_time": "2025-01-01 19:00:07",
      "end_time": "2025-01-01 23:00:07"
    }
  }```


  Response:
  201 Created: The event was successfully created and returned in the response body.
  422 Unprocessable Entity: The request body contains invalid data.
  
  """

  def create(conn, %{"event" => event_params}) do
    with {:ok, start_time} <- DateTimeUtils.string_to_naive_datetime(event_params["start_time"]),
        {:ok, end_time} <- DateTimeUtils.string_to_naive_datetime(event_params["end_time"]),
        {:ok, %Event{} = event} <- Event_context.create_event(Map.put(event_params, "start_time", start_time) |> Map.put("end_time", end_time)),
        {:ok,%ChatRoom{} = _chat_room} <- ChatRoom_context.create_chat_room(event) do
      conn
      |> put_status(:created)
      |> render(:show, event: event)
    end
  end


  @doc """
  Updates an event with the given parameters.

  ## Parameters:
  - `id` (string): The ID of the event to be updated.
  - `event` (map): A map containing the event parameters to be updated.

  ### Event Parameters:
  - `name` (string, optional): The updated name of the event.
  - `description` (string, optional): The updated description of the event.
  - `location` (string, optional): The updated location of the event.
  - `start_time` (string, optional): The updated start time of the event in the format "YYYY-MM-DD HH:MM:SS".
  - `end_time` (string, optional): The updated end time of the event in the format "YYYY-MM-DD HH:MM:SS".

  ## Example Usage:

  Request Body:
  ```json
  {
    "id": "44d2557e-ec2b-4dc5-a0cc-f8b5cb83bc6f",
    "event": {
      "name": "Updated Concert",
      "description": "An updated great music concert",
      "location": "Updated Antalya",
      "start_time": "2025-01-01 20:00:00",
      "end_time": "2025-01-01 23:30:00"
    }
  }
  ```
  Response:

  200 OK: The event was successfully updated and returned in the response body.

  404 Not Found: The event with the given ID was not found.

  422 Unprocessable Entity: The request body contains invalid data.
  """
  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Event_context.get_event_by_id(id)

    with {:ok, %Event{} = event} <- Event_context.update_event(event, event_params) do
      render(conn, :show, event: event)
    end
  end

  @doc """
  
  Deletes an event based on the given event ID.

 
  ## Parameters
  - `event_id`: The ID of the event to be deleted.

  ## Examples

      `DELETE /api/events/:id`
      
  Response:

  204 No Content: The event was successfully deleted.
  404 Not Found: No event found with the given ID.
  500 Internal Server Error: Server error during event deletion
  """
  def delete(conn, %{"event_id" => event_id}) do
    event = Event_context.get_event_by_id(event_id)

    with {:ok, %Event{}} <- Event_context.delete_event(event) do
      send_resp(conn, :no_content, "")
    end
  end
 
  @doc """
  Retrieves the chat room associated with the given event ID.

  ## Parameters:
  - `event_id` (string): The ID of the event.

  ## Example Usage:

  Request Body:
  ```json
  {
    "event_id": "44d2557e-ec2b-4dc5-a0cc-f8b5cb83bc6f"
  }```

  Response:
  200 OK: The chat room ID and status are returned.
  404 Not Found: No chat room found for the given event ID.
  """  
  def get_chat_room(conn, %{"event_id" => event_id}) do
    case Event_context.get_chat_room_by_event_id(event_id) do
      {:ok, %ChatRoom{} = chat_room} ->
        conn
        |> put_status(:ok)
        |> render(:show, chat_room: chat_room) 
      {:error, message} -> raise message
    end
  end
 
end
