defmodule MsgService.Schema.Email do
  @moduledoc """
  Schema representing the email message
  """

  # Example of the payload
  # {
  #   "From": "myUser@theirDomain.com",
  #   "MessageStream": "inbound",
  #   "FromName": "My User",
  #   "FromFull": {
  #     "Email": "myUser@theirDomain.com",
  #     "Name": "John Doe",
  #     "MailboxHash": ""
  #   },
  #   "To": "451d9b70cf9364d23ff6f9d51d870251569e+ahoy@inbound.postmarkapp.com",
  #   "ToFull": [
  #     {
  #       "Email": "451d9b70cf9364d23ff6f9d51d870251569e+ahoy@inbound.postmarkapp.com",
  #       "Name": "",
  #       "MailboxHash": "ahoy"
  #     }
  #   ],
  #   "Cc": "\"Full name\" <sample.cc@emailDomain.com>, \"Another Cc\" <another.cc@emailDomain.com>",
  #   "CcFull": [
  #     {
  #       "Email": "sample.cc@emailDomain.com",
  #       "Name": "Full name",
  #       "MailboxHash": ""
  #     },
  #     {
  #       "Email": "another.cc@emailDomain.com",
  #       "Name": "Another Cc",
  #       "MailboxHash": ""
  #     }
  #   ],
  #   "Bcc": "\"Full name\" <451d9b70cf9364d23ff6f9d51d870251569e@inbound.postmarkapp.com>",
  #   "BccFull": [
  #     {
  #       "Email": "451d9b70cf9364d23ff6f9d51d870251569e@inbound.postmarkapp.com",
  #       "Name": "Full name",
  #       "MailboxHash": ""
  #     }
  #   ],
  #   "OriginalRecipient": "451d9b70cf9364d23ff6f9d51d870251569e+ahoy@inbound.postmarkapp.com",
  #   "ReplyTo": "myUsersReplyAddress@theirDomain.com",
  #   "Subject": "This is an inbound message",
  #   "MessageID": "22c74902-a0c1-4511-804f-341342852c90",
  #   "Date": "Thu, 5 Apr 2012 16:59:01 +0200",
  #   "MailboxHash": "ahoy",
  #   "TextBody": "[ASCII]",
  #   "HtmlBody": "[HTML]",
  #   "StrippedTextReply": "Ok, thanks for letting me know!",
  #   "Tag": "",
  #   "Headers": [
  #     {
  #       "Name": "X-Spam-Checker-Version",
  #       "Value": "SpamAssassin 3.3.1 (2010-03-16) onrs-ord-pm-inbound1.wildbit.com"
  #     },
  #     {
  #       "Name": "X-Spam-Status",
  #       "Value": "No"
  #     },
  #     {
  #       "Name": "X-Spam-Score",
  #       "Value": "-0.1"
  #     },
  #     {
  #       "Name": "X-Spam-Tests",
  #       "Value": "DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,SPF_PASS"
  #     },
  #     {
  #       "Name": "Received-SPF",
  #       "Value": "Pass (sender SPF authorized) identity=mailfrom; client-ip=209.85.160.180; helo=mail-gy0-f180.google.com; envelope-from=myUser@theirDomain.com; receiver=451d9b70cf9364d23ff6f9d51d870251569e+ahoy@inbound.postmarkapp.com"
  #     },
  #     {
  #       "Name": "DKIM-Signature",
  #       "Value": "v=1; a=rsa-sha256; c=relaxed/relaxed;        d=wildbit.com; s=google;        h=mime-version:reply-to:message-id:subject:from:to:cc         :content-type;        bh=cYr/+oQiklaYbBJOQU3CdAnyhCTuvemrU36WT7cPNt0=;        b=QsegXXbTbC4CMirl7A3VjDHyXbEsbCUTPL5vEHa7hNkkUTxXOK+dQA0JwgBHq5C+1u         iuAJMz+SNBoTqEDqte2ckDvG2SeFR+Edip10p80TFGLp5RucaYvkwJTyuwsA7xd78NKT         Q9ou6L1hgy/MbKChnp2kxHOtYNOrrszY3JfQM="
  #     },
  #     {
  #       "Name": "MIME-Version",
  #       "Value": "1.0"
  #     },
  #     {
  #       "Name": "Message-ID",
  #       "Value": "<CAGXpo2WKfxHWZ5UFYCR3H_J9SNMG+5AXUovfEFL6DjWBJSyZaA@mail.gmail.com>"
  #     }
  #   ],
  #   "Attachments": [
  #     {
  #       "Name": "myimage.png",
  #       "Content": "[BASE64-ENCODED CONTENT]",
  #       "ContentType": "image/png",
  #       "ContentLength": 4096,
  #       "ContentID": "myimage.png@01CE7342.75E71F80"
  #     },
  #     {
  #       "Name": "mypaper.doc",
  #       "Content": "[BASE64-ENCODED CONTENT]",
  #       "ContentType": "application/msword",
  #       "ContentLength": 16384,
  #       "ContentID": ""
  #     }
  #   ]
  # }

  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @primary_key false
  embedded_schema do
    # TODO: Add all the fields
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
