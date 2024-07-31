defmodule MessagingAppApi.Context.Event do
  
  import Ecto.Query
  alias MessagingAppApi.Repo
  alias MessagingAppApi.{Event, ChatRoom}

  def create_event(params) do
    %Event{}
    |> Event.changeset(params)
    |> Repo.insert()
  end

  def get_event_by_name(event_name) do
    Event
    |> where(name: ^event_name)
    |> Repo.all()
  end
  

  def get_event_by_id(id) do
    Repo.one!(Event,id)
  end

  def update_event(%Event{} = event, attrs) do
   event
    |> Event.changeset(attrs)
    |> Repo.update!()
  end

  def delete_event(%Event{} = event) do
    Repo.delete!(event)
  end
  
  def get_chat_room_id_by_event_id(event_id) do
    query = from e in Event,
            join: c in assoc(e, :chat_room),
            where: e.id == ^event_id,
            select: c 
    """
    case Repo.one(query) do
      nil -> {:error, "Chat room not found for the given event ID"}
      chat_room = %ChatRoom{} -> {:ok, chat_room}
    end
    """
    Repo.one!(query)
  end

end
