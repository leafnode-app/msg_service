defmodule MsgService.Schema.Email do
  @moduledoc """
  Schema representing the email message
  """

  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @primary_key false
  embedded_schema do
    # TODO: Add all the fields
  end

  @doc false
  def changeset(mail, attrs) do
    mail
    |> cast(attrs, [
      # TODO: Add all the fields
    ])
  end

  @doc """
  Convert the WhatsApp message to a struct
  """
  def to_struct(payload) when is_map(payload) do
    resp = Map.to_list(payload)
    |> Enum.map(fn {key, value} -> {
        # We make sure it matches ths struct and create the relevant type
        Macro.underscore(key) |> String.to_atom,
        value
      }
    end)
    |> Enum.reduce(%__MODULE__{}, fn {key, value}, acc ->
      Map.put(acc, key, value)
    end)

    {:ok, resp}
  end
  def to_struct(_payload) do
    {:error, "There was a problem converting the payload to a struct"}
  end
end
