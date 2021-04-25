open Opium

let ( let* ) = Lwt.bind

let sys_json _req =
  let json : Yojson.Safe.t =
    `Assoc [ "os-type", `String Sys.os_type; "ocaml-version", `String Sys.ocaml_version ]
  in
  Response.of_json json |> Lwt.return

let show_audios _req =
  let audios = 
    Yojson.Safe.from_file "./priv/data/audio.json"
  in
    Lwt.return (Response.of_json audios)

let webhook req = 
  let* body_json = Request.to_json_exn req in 
  Lwt.return (Response.of_plain_text (Inline_input.build_query body_json).query)

let _ = 
 App.empty
  |> App.get "/sys" sys_json 
  |> App.get "/" show_audios
  |> App.post "/webhook" webhook
  |> App.run_command
