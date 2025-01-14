defmodule MsgService.Templates.Email do
  @moduledoc """
  Email Templates
  """

  @doc """
  Generate the response email for different types
  """
  @spec response(String.t(), atom()) :: String.t()
  def response(text, :node) do
    """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Leafnode Response</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                line-height: 1.6;
                color: #333;
            }
            .footer {
                margin-top: 20px;
                font-size: 0.9em;
                color: #777;
            }
        </style>
    </head>
    <body>
        <p>Hi,</p>
        <p>#{text}</p>
        <p class="footer">Response was generated by <a href="https://use.leafnode.app" target="_blank">use.leafnode.app</a></p>
    </body>
    </html>
    """
  end

end
