defmodule MessagingAppApi.ChatRoom do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "chat_rooms" do
    field :status, :string
    belongs_to :event, MessagingAppApi.Event
    has_many :messages, MessagingAppApi.Message


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chat_room, attrs) do
    chat_room
    |> cast(attrs, [:status, :event_id])
    |> validate_required([:status, :event_id])
  end
end
