defmodule MessagingAppApi.Repo.Migrations.CreateTickets do
  use Ecto.Migration

  def change do
    create table(:tickets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :ticket_number, :string
      add :event_id, references(:events, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:tickets, [:ticket_number])
    create index(:tickets, [:event_id])
    create index(:tickets, [:user_id])
  end
end
