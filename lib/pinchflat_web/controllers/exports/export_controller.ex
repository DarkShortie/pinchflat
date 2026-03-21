defmodule PinchflatWeb.Exports.ExportController do
  use PinchflatWeb, :controller

  alias Pinchflat.Sources

  def media_ids(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{sources: Sources.export_media_ids_by_source()})
  end
end
