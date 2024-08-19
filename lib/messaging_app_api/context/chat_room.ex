defmodule MessagingAppApi.Context.ChatRoom do

  import Ecto.Query
  alias MessagingAppApi.Repo
  alias MessagingAppApi.ChatRoom


  def create_chat_room(event) do
    event
    |> Ecto.build_assoc(:chat_room)
    |> ChatRoom.changeset(%{:status => "deactive"})
    |> Repo.insert()
  end

  def get_chat_room_by_event(event_id) do
    ChatRoom
    |> where(event: ^event_id)
    |> Repo.one()
  end

end
