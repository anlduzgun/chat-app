defmodule MessagingAppApi.Context.Ticket do
  
  import Ecto.Query
  alias MessagingAppApi.Repo
  alias MessagingAppApi.Ticket

  def create_ticket(params) do
   %Ticket{}
    |> Ticket.changeset(params)
    |> Repo.insert()
  end


  def get_ticket_by_number(ticket_number) do
   Ticket 
    |> where(ticket_number: ^ticket_number)
    |> Repo.one()
  end
    
end
