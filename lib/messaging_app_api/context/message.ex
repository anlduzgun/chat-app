defmodule MessagingAppApi.Context.Message do
  import Ecto.Query
  alias MessagingAppApi.Repo
  alias MessagingAppApi.Message

  
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  def list_recent_messages(chat_room_id, limit \\ 50) do
    query = from m in Message,
      where: m.chat_room_id == ^chat_room_id,
      order_by: [desc: m.inserted_at],
      limit: ^limit,
      preload: [:user]

    Repo.all(query)
  end


end
