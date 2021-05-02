open Cohttp
open Cohttp_lwt_unix

let ( let* ) = Lwt.bind

let url token =
  String.concat ""
    [ "https://api.telegram.org/bot"; token; "/answerInlineQuery" ]

let header : Cohttp.Header.t =
  Header.add (Header.init ()) "Content-Type" "application/json"

let answer_inline_query (body : Cohttp_lwt.Body.t) : Unit.t Lwt.t =
  let token = Sys.getenv "TELEGRAM_BOT_TOKEN" in
  let uri = Uri.of_string (url token) in
  let* response, _body = Client.post uri ~body ~headers:header in
  let status = Response.status response in
  if status <> `OK then Lwt.ignore_result (Cohttp_lwt.Body.drain_body body);
  Lwt.return ()