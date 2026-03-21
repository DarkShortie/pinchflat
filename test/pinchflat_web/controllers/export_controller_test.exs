defmodule PinchflatWeb.ExportControllerTest do
  use PinchflatWeb.ConnCase

  import Pinchflat.MediaFixtures
  import Pinchflat.SourcesFixtures

  describe "GET /api/exports/media_ids" do
    test "returns media ids grouped by source with type and download status", %{conn: conn} do
      source = source_fixture(custom_name: "Source A")

      _downloaded =
        media_item_fixture(%{
          source_id: source.id,
          media_id: "downloaded123",
          short_form_content: false,
          media_filepath: "/video/downloaded.mp4",
          culled_at: nil,
          prevent_download: false
        })

      _short_pending =
        media_item_fixture(%{
          source_id: source.id,
          media_id: "shortpending456",
          short_form_content: true,
          media_filepath: nil,
          culled_at: nil,
          prevent_download: false
        })

      _prevented =
        media_item_fixture(%{
          source_id: source.id,
          media_id: "prevented789",
          short_form_content: false,
          media_filepath: nil,
          culled_at: nil,
          prevent_download: true
        })

      _culled =
        media_item_fixture(%{
          source_id: source.id,
          media_id: "culled111",
          short_form_content: false,
          media_filepath: nil,
          culled_at: DateTime.utc_now(),
          prevent_download: false
        })

      _prevented_even_if_downloaded =
        media_item_fixture(%{
          source_id: source.id,
          media_id: "prevented222",
          short_form_content: false,
          media_filepath: "/video/already.mp4",
          culled_at: nil,
          prevent_download: true
        })

      conn = get(conn, "/api/exports/media_ids")
      %{"sources" => [export_source | _]} = json_response(conn, 200)

      assert export_source["source"]["id"] == source.id
      assert export_source["source"]["custom_name"] == "Source A"

      assert export_source["media_items"] == [
               %{
                 "download_status" => "downloaded",
                 "media_id" => "downloaded123",
                 "media_type" => "video"
               },
               %{
                 "download_status" => "pending",
                 "media_id" => "shortpending456",
                 "media_type" => "short"
               },
               %{
                 "download_status" => "prevented",
                 "media_id" => "prevented789",
                 "media_type" => "video"
               },
               %{
                 "download_status" => "culled",
                 "media_id" => "culled111",
                 "media_type" => "video"
               },
               %{
                 "download_status" => "prevented",
                 "media_id" => "prevented222",
                 "media_type" => "video"
               }
             ]
    end
  end
end
