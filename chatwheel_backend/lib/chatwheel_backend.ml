open Base;;
open Opium;;

let ( let* ) = Lwt.bind

(* Returns basic info about server, used as a simple health check *)
let sys_json _req =
  let json : Yojson.Safe.t =
    `Assoc
      [
        ("os-type", `String Caml.Sys.os_type);
        ("ocaml-version", `String Caml.Sys.ocaml_version);
      ]
  in
  Response.of_json json |> Lwt.return

(* Telegram webhook endpoint *)
let webhook req =
  let* body_json = Request.to_json_exn req in
  let query = Inline_input.build_query body_json in
  let audios = Search.top_search 10 query.query in
  let json_resp =
    Yojson.Safe.to_string
      (Inline_response.yojson_of_inline_query_answer
         (Inline_response.build_inline_query_answer query.id audios))
  in
  let _ = Telegram_client.answer_inline_query (`String json_resp) in
  Lwt.return (Response.of_plain_text "")

(* API search endpoint *)
let search req =
  let query = Request.query "query" req in
  match query with
  | Some q ->
    let audios = Search.top_search 50 q in
    let json = `List (List.map ~f:Chatwheel_core.Audio.yojson_of_t audios) in
    Response.of_json json |> Lwt.return
  | None ->
    let json = `List [] in
    Response.of_json json |> Lwt.return

let port =
  Sys.getenv "PORT" |> Option.value ~default:"3000" |> Int.of_string

let _ =
  App.empty 
  |> App.port port
  |> App.middleware Middleware.logger
  |> App.get "/sys" sys_json
  |> App.get "/api/search" search
  |> App.post "/webhook" webhook
  |> App.run_command
