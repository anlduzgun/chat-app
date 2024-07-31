defmodule MessagingAppApi.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :text
      add :start_time, :naive_datetime
      add :end_time, :naive_datetime
      add :location, :string

      timestamps(type: :utc_datetime)
    end

    create index(:events, [:name])
  end
end
