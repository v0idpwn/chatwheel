open! Core_kernel
open! Bonsai_web

let search_component : ('input, 'result) Bonsai.t = 
  Bonsai.of_module (module Search_bar) ~default_model: Search_bar.Model.default

let results_component = 
  Bonsai.pure ~f:Results_component.render

let application : ('input, 'result) Bonsai.t =
  let open Bonsai.Let_syntax in
  let%map results_list, search_bar = search_component >>> Bonsai.Arrow.first results_component
  in
  Vdom.Node.div [] [search_bar; results_list]
;;

let json_post url yojson =
  let open Async_kernel in
  let open Async_js in
  let body = Yojson.Safe.to_string yojson in
  let headers = [("Content-Type", "application/json")] in
  Deferred.Or_error.map
    ~f:(fun resp -> resp.content)
    (Http.request ~headers ~url ~response_type:Default (Post (Some (String body))))
;;

(* Requests a search to the backend and updates the app input with the result *)
let search ~app_handle ~uri =
  let open Async_kernel in
  let open Deferred.Let_syntax in
  let target = Uri.to_string (Uri.with_path uri "/api/search") in
  let on_request query = 
    let body = `Assoc [("query", `String query)] in
    let%map resp = json_post target body in 
    Start.Handle.update_input app_handle ~f:(fun (input : App_input.t) -> 
      match resp with
      | Error _ -> input
      | resp_body ->
        let body_json = Yojson.Safe.from_string (Or_error.ok_exn resp_body) in
        { input with search_results = Some (Chatwheel_core.Audio.t_list_of_yojson body_json)}
    )
  in
  let dispatch = on_request |> Effect.of_deferred_fun |> unstage in
  fun query -> dispatch query
;;

let play_from_url ~app_handle:_ =
  let open Async_kernel in
  let open Js_of_ocaml in
  let play target =
    let audio_constructor = Js.Unsafe.global##._Audio in
    let audio = new%js audio_constructor target in
    let () = (Js.Unsafe.coerce audio)##play in
    Deferred.unit
  in
  let dispatch = play |> Effect.of_deferred_fun |> unstage in
  fun url -> dispatch url
;;

let run () =
  let open Async_kernel in
  Async_js.init ();
  don't_wait_for
  @@
  let uri =
    let open Js_of_ocaml in
    let scheme = if String.equal Url.Current.protocol "https:" then "https" else "http" in
    let port =
      match Url.Current.port with
      | Some port -> port
      | None ->
        if String.equal Url.Current.protocol "https:"
        then Url.default_https_port
        else Url.default_http_port
    in
    let host = Url.Current.host in
    let path = Url.Current.path_string in
    Uri.make ~scheme ~host ~port ~path ()
  in
  let app_handle =
    Start.start_standalone
      ~initial_input:(App_input.default uri)
      ~bind_to_element_with_id:"app" 
      application
  in
  Start.Handle.update_input app_handle ~f:(fun input -> 
    {input with
      search_query = search ~app_handle ~uri;
      play_audio = play_from_url ~app_handle
    });
  Deferred.unit

let () = run ()
