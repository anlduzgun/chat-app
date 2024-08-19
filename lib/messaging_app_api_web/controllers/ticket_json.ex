defmodule MessagingAppApiWeb.TicketJSON do
  alias MessagingAppApi.Ticket



  def show(%{ticket: ticket}) do
    %{data: data(ticket)}
  end

  def data(%Ticket{} = ticket) do
    %{
      ticket_id: ticket.id,
      ticket_number: ticket.ticket_number,
      event_id: ticket.event_id
    }
  end
end
