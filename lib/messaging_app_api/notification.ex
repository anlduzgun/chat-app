defmodule MessagingAppApi.Notification do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "notifications" do
    field :message, :string
    field :status, :string
    belongs_to :user, MessagingAppApi.User
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [:message, :status])
    |> validate_required([:message, :status])
  end
end
