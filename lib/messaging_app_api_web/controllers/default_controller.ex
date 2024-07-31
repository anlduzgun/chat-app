defmodule MessagingAppApiWeb.DefaultController do
  use MessagingAppApiWeb, :controller

  def index(conn, _param) do
    text(conn, "helloworld")
  end 

end 
