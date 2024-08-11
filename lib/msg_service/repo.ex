defmodule MsgService.Repo do
  use Ecto.Repo,
    otp_app: :msg_service,
    adapter: Ecto.Adapters.Postgres
end
