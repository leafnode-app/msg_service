defmodule MsgService.Schema.Email do
  @moduledoc """
  Schema representing the email message
  """

  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{
    from: String.t(),
    message_stream: String.t(),
    from_name: String.t(),
    from_full: map(),
    to: String.t(),
    to_full: map(),
    cc: String.t(),
    cc_full: map(),
    bcc: String.t(),
    bcc_full: map(),
    original_recipient: String.t(),
    reply_to: String.t(),
    subject: String.t(),
    message_id: String.t(),
    date: String.t(),
    mailbox_hash: String.t(),
    text_body: String.t(),
    html_body: String.t(),
    stripped_text_reply: String.t(),
    tag: String.t(),
    headers: map(),
    attachments: map()
  }

  @primary_key false
  embedded_schema do
    field :from, :string
    field :message_stream, :string
    field :from_name, :string
    field :from_full, :map
    field :to, :string
    field :to_full, :map
    field :cc, :string
    field :cc_full, :map
    field :bcc, :string
    field :bcc_full, :map
    field :original_recipient, :string
    field :reply_to, :string
    field :subject, :string
    field :message_id, :string
    field :date, :string
    field :mailbox_hash, :string
    field :text_body, :string
    field :html_body, :string
    field :stripped_text_reply, :string
    field :tag, :string
    field :headers, :map
    field :attachments, :map
  end

  @doc false
  def changeset(mail, attrs) do
    mail
    |> cast(attrs, [
      :from,
      :message_stream,
      :from_name,
      :from_full,
      :to,
      :to_full,
      :cc,
      :cc_full,
      :bcc,
      :bcc_full,
      :original_recipient,
      :reply_to,
      :subject,
      :message_id,
      :date,
      :mailbox_hash,
      :text_body,
      :html_body,
      :stripped_text_reply,
      :tag,
      :headers,
      :attachments
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
