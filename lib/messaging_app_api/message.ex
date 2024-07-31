defmodule MessagingAppApi.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "messages" do
    field :content, :string
    field :content_type, :string
    belongs_to :chat_room, MessagingAppApi.ChatRoom 
    belongs_to :user, MessagingAppApi.User
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :content_type])
    |> validate_required([:content, :content_type])
  end
end
