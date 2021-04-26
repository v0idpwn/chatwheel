open Lwt
open Cohttp
open Cohttp_lwt_unix

let ( let* ) = Lwt.bind

let url token = String.concat "" 
  ["https://api.telegram.org/bot/"; token; "/answerInlineQuery"]

let answer_inline_query (body : Cohttp_lwt.Body.t) : Unit.t Lwt.t =
  let token = Sys.getenv("TELEGRAM_BOT_TOKEN") in
  let uri = Uri.of_string (url token) in
  let* (_resp, _body) = Client.post uri ~body:body in
  Lwt.return ()
