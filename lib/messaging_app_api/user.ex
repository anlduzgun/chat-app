defmodule MessagingAppApi.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :username, :string
    field :email, :string
    field :password_hash, :string
    has_many :messages, MessagingAppApi.Message
    has_many :tickets, MessagingAppApi.Ticket
    has_many :notifications, MessagingAppApi.Notification

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password_hash])
    |> validate_required([:username, :email, :password_hash])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> validate_length(:username, max: 25)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password_hash: hash_password}} = changeset) do 
    change(changeset, password_hash: Bcrypt.hash_pwd_salt(hash_password))
  end

  defp hash_password(changeset), do: changeset
end
