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
 

  def get_ticket_by_id(id) do
    Repo.get(Ticket, id)
  end

  # i should implement user_id == conn.user.id check
  def assign_ticket_to_user(ticket_id, user_id) do
    ticket = Repo.get(Ticket, ticket_id)

    case ticket do
      nil ->
        {:error, :ticket_not_found}
      ticket ->
        ticket
        |> Ticket.changeset(%{user_id: user_id})
        |> Repo.update()
    end
  end
 
  def get_preloads(%Ticket{} = ticket, preloads \\ [] ) do
    Repo.preload(ticket, preloads)
  end


  def user_has_ticket?(user_id, event_id) do
    query = from t in Ticket,
      where: t.user_id == ^user_id and t.event_id == ^event_id,
      select: count(t.id)

    Repo.one!(query)
  end


 end
