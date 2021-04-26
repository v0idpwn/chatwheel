open Opium

let ( let* ) = Lwt.bind

let sys_json _req =
  let json : Yojson.Safe.t =
    `Assoc
      [
        ("os-type", `String Sys.os_type);
        ("ocaml-version", `String Sys.ocaml_version);
      ]
  in
  Response.of_json json |> Lwt.return

let webhook req =
  let* body_json = Request.to_json_exn req in
  let query = Inline_input.build_query body_json in
  let audios = Audio.top_search query.query in
  let json_resp =
    Yojson.Safe.to_string
      (Inline_response.to_json
         (Inline_response.build_inline_query_answer query.id audios))
  in
  let _ = print_endline json_resp in
  let _ = Telegram_client.answer_inline_query (`String json_resp) in
  Lwt.return (Response.of_plain_text "")

let _ =
  App.empty |> App.get "/sys" sys_json
  |> App.post "/webhook" webhook
  |> App.run_command
