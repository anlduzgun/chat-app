defmodule MessagingAppApiWeb.EventChannel do
  use Phoenix.Channel
  alias MessagingAppApi.Context.{Event, Message, Ticket}
  alias MessagingAppApi.{ChatRoom}

  

  def join("event:" <> event_id, _params, socket) do
    case Event.get_chat_room_by_event_id(event_id) do
      nil ->
        {:error, %{reason: "Event not found"}}
      %ChatRoom{} = chat_room ->
        # Check if the user has a valid ticket for this event
        if Ticket.user_has_ticket?(socket.assigns.user, event_id) do
          # Fetch recent messages
          #messages = Message.list_recent_messages(event_id)
          {:ok, assign(socket, :chat_room, chat_room.id)}
        else
          {:error, %{reason: "Unauthorized"}}
        end
    end
  end

  def handle_in("new_message", %{"content" => content}, socket) do
    user_id = socket.assigns.user
    chat_room_id = socket.assigns.chat_room

    case Message.create_message(%{
      user_id: user_id,
      chat_room_id: chat_room_id,
      content: content,
      content_type: "text"
    }) do
      {:ok, message} ->
        broadcast_from!(socket, "new_message", %{
          id: message.id,
          user_id: message.user_id,
          content: message.content,
          inserted_at: message.inserted_at
        })
        {:reply, {:ok, %{id: message.id}}, socket}
      {:error, _changeset} ->
        {:reply, {:error, %{reason: "Failed to create message"}}, socket}
    end
  end

  # Handle user typing indicator
  def handle_in("user_typing", %{"typing" => typing}, socket) do
    broadcast_from!(socket, "user_typing", %{
      user_id: socket.assigns.user,
      typing: typing
    })
    {:noreply, socket}
  end

  # Additional channel-specific functions can be added here
end
