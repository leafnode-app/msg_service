defmodule MsgService.Schema.Whatsapp do
  @moduledoc """
  Schema representing the WhatsApp message
  """

  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
    account_sid: String.t(),
    api_version: String.t(),
    body: String.t(),
    from: String.t(),
    message_sid: String.t(),
    message_type: String.t(),
    num_media: String.t(),
    num_segments: String.t(),
    profile_name: String.t(),
    referral_num_media: String.t(),
    sms_message_sid: String.t(),
    sms_sid: String.t(),
    sms_status: String.t(),
    to: String.t(),
    wa_id: String.t()
  }

  @primary_key false
  embedded_schema do
    field :account_sid, :string
    field :api_version, :string
    field :body, :string
    field :from, :string
    field :message_sid, :string
    field :message_type, :string
    field :num_media, :string
    field :num_segments, :string
    field :profile_name, :string
    field :referral_num_media, :string
    field :sms_message_sid, :string
    field :sms_sid, :string
    field :sms_status, :string
    field :to, :string
    field :wa_id, :string
  end

  @doc false
  def changeset(whatsapp_msg, attrs) do
    whatsapp_msg
    |> cast(attrs, [
      :account_sid,
      :api_version,
      :body,
      :from,
      :message_sid,
      :message_type,
      :num_media,
      :num_segments,
      :profile_name,
      :referral_num_media,
      :sms_message_sid,
      :sms_sid,
      :sms_status,
      :to,
      :wa_id
    ])
  end

  @doc """
  Convert the WhatsApp message to a struct
  """
  def to_struct(payload) when is_map(payload) do
    Map.to_list(payload)
    |> Enum.map(fn {key, value} -> {
        # We make sure it matches ths struct and create the relevant type
        Macro.underscore(key) |> String.to_atom,
        value
      }
    end)
    |> Enum.reduce(%__MODULE__{}, fn {key, value}, acc ->
      Map.put(acc, key, value)
    end)
  end
  def to_struct(_payload) do
    {:error, "There was a problem converting the payload to a struct"}
  end
end
