defmodule MessagingAppApi.EventsTest do
  use MessagingAppApi.DataCase

  alias MessagingAppApi.Events

  describe "events" do
    alias MessagingAppApi.Events.Event

    import MessagingAppApi.EventsFixtures

    @invalid_attrs %{name: nil, link: nil, description: nil, location: nil, start_time: nil, end_time: nil, qr_code: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{name: "some name", link: "some link", description: "some description", location: "some location", start_time: ~N[2024-07-12 17:07:00], end_time: ~N[2024-07-12 17:07:00], qr_code: "some qr_code"}

      assert {:ok, %Event{} = event} = Events.create_event(valid_attrs)
      assert event.name == "some name"
      assert event.link == "some link"
      assert event.description == "some description"
      assert event.location == "some location"
      assert event.start_time == ~N[2024-07-12 17:07:00]
      assert event.end_time == ~N[2024-07-12 17:07:00]
      assert event.qr_code == "some qr_code"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      update_attrs = %{name: "some updated name", link: "some updated link", description: "some updated description", location: "some updated location", start_time: ~N[2024-07-13 17:07:00], end_time: ~N[2024-07-13 17:07:00], qr_code: "some updated qr_code"}

      assert {:ok, %Event{} = event} = Events.update_event(event, update_attrs)
      assert event.name == "some updated name"
      assert event.link == "some updated link"
      assert event.description == "some updated description"
      assert event.location == "some updated location"
      assert event.start_time == ~N[2024-07-13 17:07:00]
      assert event.end_time == ~N[2024-07-13 17:07:00]
      assert event.qr_code == "some updated qr_code"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event == Events.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end
end
