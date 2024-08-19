defmodule MessagingAppApiWeb.TicketController do
  @moduledoc """
  The `TicketController` is responsible for managing ticket-related actions within the MessagingAppApi application.

  ## Responsibilities

  - Creating a new ticket.
  - Assigning a ticket to a user.

  This controller interacts with the `Context_ticket` module for database operations related to tickets.
  """
  use MessagingAppApiWeb, :controller
  
  alias MessagingAppApi.Ticket
  alias MessagingAppApi.Context.Ticket, as: Context_ticket
  action_fallback MessagingAppApiWeb.FallbackController

  @doc """
  Creates a new ticket.

  `POST /api/tickets/create`

  **Parameters**:

  - `ticket_params` (map): A map containing the ticket details.

  **Example Usage**:

  ```json
  {
    "ticket": {
      "ticket_number": "123456789",
      "event_id": "44d2557e-ehb0-a45e-a0cc-f8b5cb83bc6f"
    }
  }```

  `Response`:
  - `201 Created`: Returns the created ticket.
  """
  def create_ticket(conn, %{"ticket" => ticket_params}) do
    with {:ok, %Ticket{} = ticket} <- Context_ticket.create_ticket(ticket_params) do
      conn 
      |> put_status(:created)
      |> render(:show, ticket: ticket)
    end
  end

  @doc """
  Assigns a ticket to a user.

  `POST /api/tickets/assign`

  **Parameters**:

  `ticket_id` (string): The ID of the ticket to be assigned.
  `user_id` (string): The ID of the user to whom the ticket will be assigned.
  
  **Example Usage**:

  ```json
  Copy code
  {
    "ticket_id": "44d2557e-ehb0-a45e-a0cc-f8b5cb83bc6f",
    "user_id": "78f9b11e-bc90-45e2-9f7f-5d4df4c7e5bb"
  }```

  `Response`:
  - `200 OK`: Returns the updated ticket with the assigned user.
  - `404 Not Found`: Returns an error if the ticket does not exist.
  """
  def assign_ticket_to_user(conn, %{"ticket_id" => ticket_id, "user_id" => user_id}) do 
    with {:ok, %Ticket{} = ticket} <- Context_ticket.assign_ticket_to_user(ticket_id, user_id) do
      conn
      |> put_status(:ok)
      |> render(:show, %{ticket: ticket})
    end
  end
  
end
