defmodule MessagingAppApi.Event do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "events" do
    field :name, :string
    field :description, :string
    field :location, :string
    field :start_time, :naive_datetime
    field :end_time, :naive_datetime
    has_one :chat_room, MessagingAppApi.ChatRoom
    has_many :tickets, MessagingAppApi.Ticket
    
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :description, :start_time, :end_time, :location])
    |> validate_required([:name, :description, :start_time, :end_time, :location])
  end
end
