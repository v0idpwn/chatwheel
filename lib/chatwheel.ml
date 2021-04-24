open Opium

let sys_json _req =
  let json : Yojson.Safe.t =
    `Assoc [ "os-type", `String Sys.os_type; "ocaml-version", `String Sys.ocaml_version ]
  in
  Response.of_json json |> Lwt.return

let show_audios _req =
  let audios = 
    Yojson.Safe.from_string (Utils.read_file "./priv/data/audio.json")
  in
    Lwt.return (Response.of_json audios)

let _ = 
  App.empty
  |> App.get "/sys" sys_json 
  |> App.get "/" show_audios
  |> App.run_command
