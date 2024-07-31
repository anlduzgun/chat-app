defmodule MessagingAppApi.DateTimeUtils do
  @doc """
  Converts a string to a NaiveDateTime.

  ## Examples

      iex> DateTimeUtils.string_to_naive_datetime("2024-07-19 15:30:00")
      {:ok, ~N[2024-07-19 15:30:00]}

      iex> DateTimeUtils.string_to_naive_datetime("invalid datetime")
      {:error, :invalid_format}

  """
  def string_to_naive_datetime(datetime_string) do
    case NaiveDateTime.from_iso8601(datetime_string) do
      {:ok, naive_datetime} -> 
        {:ok, naive_datetime}
      {:error, _} -> 
        {:error, :invalid_format}
    end
  end

end
