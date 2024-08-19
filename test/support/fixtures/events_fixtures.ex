defmodule MessagingAppApi.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MessagingAppApi.Events` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        description: "some description",
        end_time: ~N[2024-07-12 17:07:00],
        link: "some link",
        location: "some location",
        name: "some name",
        qr_code: "some qr_code",
        start_time: ~N[2024-07-12 17:07:00]
      })
      |> MessagingAppApi.Events.create_event()

    event
  end
end
