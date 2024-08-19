defmodule MessagingAppApi.Ticket do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tickets" do
    field :ticket_number, :string
    belongs_to :event, MessagingAppApi.Event
    belongs_to :user, MessagingAppApi.User
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [:ticket_number, :event_id, :user_id])
    |> validate_required([:ticket_number, :event_id])
    |> unique_constraint(:ticket_number)
    |> foreign_key_constraint(:user_id)
  end
end
