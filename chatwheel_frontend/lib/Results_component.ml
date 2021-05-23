open! Core_kernel
open! Bonsai_web
open! Frontend_common

let div = Vdom.Node.div
let classes = Vdom.Attr.classes
let article = Vdom.Node.create "article"
let figure = Vdom.Node.create "figure"
let icon attrs = Vdom.Node.create "i" attrs []

let render_result (result : Search_result.t) : Vdom.Node.t =
  article [
    Vdom.Attr.classes ["media"]
  ] [
    figure [ classes ["media-left"] ] [
      Vdom.Node.button [classes ["button"; "is-primary"]] [
        icon [classes ["fas"; "fa-play"]]
      ]
    ];
    div [classes ["media-content"]] [
      div [classes ["content"]] [Vdom.Node.h4 [] [Vdom.Node.text result.name]];
    ];
    div [classes ["media-right"]] [];
  ]

let render (model : Search_bar.Model.t) =
  Vdom.Node.div [] (List.map ~f:render_result model.results)
