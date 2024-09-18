defmodule MsgService.Client.PostMark do
  @moduledoc """
  HTTP client used to make requests to other services externally
  """
  use Tesla, only: [:post, :get, :delete]

  plug Tesla.Middleware.BaseUrl, config(:postmark).host
  plug Tesla.Middleware.Headers, [{"content-type", "application/json"}, {"X-Postmark-Server-Token", config(:postmark).app_key}]
  plug Tesla.Middleware.JSON
  # plug Tesla.Middleware.Logger

  # explicit but it will default to this for transactional
  @message_stream "outbound"

  @doc """
    Add rule to blacklist email
  """
  @spec add_trigger_rule(String.t()) :: Tesla.Env.result()
  def add_trigger_rule(rule) do
    post("/triggers/inboundrules", %{"Rule" => rule })
  end

  @doc """
    Remove rule to blacklist email
  """
  @spec remove_trigger_rule(Tesla.Env.url()) :: Tesla.Env.result()
  def remove_trigger_rule(id) do
    delete("/triggers/inboundrules/#{id}")
  end

  @doc """
    Get list of current rules
  """
  @spec get_trigger_rules() :: Tesla.Env.result()
  def get_trigger_rules(count \\ 100, offset \\ 0) do
    get("/triggers/inboundrules?count=#{count}&offset=#{offset}")
  end

  @doc """
    Send email
  """
  # TODO: look at html as a body?
  @spec send_email(
    %{
      from: String.t(),
      to: String.t(),
      text_body: String.t(),
      subject: String.t(),
      in_reply_to: String.t(),
      references: String.t(),
    }) :: Tesla.Env.result()
  def send_email(%{ from: from, to: to, text_body: text_body, subject: subject, in_reply_to: in_reply_to, references: references}) do
      payload = %{
        "From" => from,
        "To" => to,
        "Subject" => subject,
        "TextBody" => text_body,
        # We could create a template that will be used for the html_body
        "HtmlBody" => MsgService.Templates.Email.response(text_body, :node),
        "MessageStream" => @message_stream
      }

      client = client([{"In-Reply-To", in_reply_to}, {"References", references}])
      Tesla.post(client, "/email", payload)
  end

   # Helper function to create a Tesla client with custom headers
   defp client(headers) do
    Tesla.client([
      {Tesla.Middleware.BaseUrl, config(:postmark).host},
      {Tesla.Middleware.Headers, [{"content-type", "application/json"}, {"X-Postmark-Server-Token", config(:postmark).app_key}] ++ headers},
      Tesla.Middleware.JSON
    ])
  end

  # Configuration for internal API services calls against main application
  def config do
    Application.get_env(:msg_service, :external_services)
  end

  def config(key) do
    config()[key]
  end
end
