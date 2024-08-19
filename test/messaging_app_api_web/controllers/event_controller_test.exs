defmodule MessagingAppApiWeb.EventControllerTest do
  use MessagingAppApiWeb.ConnCase

  import MessagingAppApi.EventsFixtures

  alias MessagingAppApi.Events.Event

  @create_attrs %{
    name: "some name",
    link: "some link",
    description: "some description",
    location: "some location",
    start_time: ~N[2024-07-12 17:07:00],
    end_time: ~N[2024-07-12 17:07:00],
    qr_code: "some qr_code"
  }
  @update_attrs %{
    name: "some updated name",
    link: "some updated link",
    description: "some updated description",
    location: "some updated location",
    start_time: ~N[2024-07-13 17:07:00],
    end_time: ~N[2024-07-13 17:07:00],
    qr_code: "some updated qr_code"
  }
  @invalid_attrs %{name: nil, link: nil, description: nil, location: nil, start_time: nil, end_time: nil, qr_code: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all events", %{conn: conn} do
      conn = get(conn, ~p"/api/events")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create event" do
    test "renders event when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/events", event: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/events/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some description",
               "end_time" => "2024-07-12T17:07:00",
               "link" => "some link",
               "location" => "some location",
               "name" => "some name",
               "qr_code" => "some qr_code",
               "start_time" => "2024-07-12T17:07:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/events", event: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update event" do
    setup [:create_event]

    test "renders event when data is valid", %{conn: conn, event: %Event{id: id} = event} do
      conn = put(conn, ~p"/api/events/#{event}", event: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/events/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "end_time" => "2024-07-13T17:07:00",
               "link" => "some updated link",
               "location" => "some updated location",
               "name" => "some updated name",
               "qr_code" => "some updated qr_code",
               "start_time" => "2024-07-13T17:07:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put(conn, ~p"/api/events/#{event}", event: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete event" do
    setup [:create_event]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete(conn, ~p"/api/events/#{event}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/events/#{event}")
      end
    end
  end

  defp create_event(_) do
    event = event_fixture()
    %{event: event}
  end
end
