open! Core_kernel
open! Bonsai_web

let div = Vdom.Node.div
let classes = Vdom.Attr.classes
let article = Vdom.Node.create "article"
let figure = Vdom.Node.create "figure"
let icon attrs = Vdom.Node.create "i" attrs []

let render_result (input : App_input.t) (result : Chatwheel_core.Audio.t) : Vdom.Node.t =
  article [
    Vdom.Attr.classes ["media"]
  ] [
    figure [ classes ["media-left"] ] [
      Vdom.Node.button [
        classes ["button"; "is-primary"];
        Vdom.Attr.on_click (fun _ -> Effect.inject_ignoring_response (input.play_audio result.url));
      ] [
        icon [classes ["fas"; "fa-play"]]
      ]
    ];
    div [classes ["media-content"]] [
      div [classes ["content"]] [Vdom.Node.h4 [] [Vdom.Node.text result.name]];
    ];
    div [classes ["media-right"]] [];
  ]

let render (input : App_input.t) =
  match input.search_results with
  | Some audios ->
    Vdom.Node.div [] (List.map ~f:(render_result input) audios)
  | None -> Vdom.Node.div [] []
