open Base;;
open Cohttp;;
open Cohttp_lwt_unix;;

let ( let* ) = Lwt.bind

let url token =
  String.concat ~sep:""
    [ "https://api.telegram.org/bot"; token; "/answerInlineQuery" ]

let header : Cohttp.Header.t =
  Header.add (Header.init ()) "Content-Type" "application/json"

let token : String.t =
  Sys.getenv_exn "TELEGRAM_BOT_TOKEN"

let answer_inline_query (body : Cohttp_lwt.Body.t) : Unit.t Lwt.t =
  let uri = Uri.of_string (url token) in
  let* response, _body = Client.post uri ~body ~headers:header in
  let status = Response.status response in
  match status with
  | `OK -> Lwt.return ()
  | _ -> Lwt.return (Lwt.ignore_result (Cohttp_lwt.Body.drain_body body));
