open! Core_kernel
open! Bonsai_web
open! Frontend_common

let render_result (result : Search_result.t) : Vdom.Node.t =
  Vdom.Node.div [
    Vdom.Attr.classes ["columns"]
  ] [
    Vdom.Node.div [Vdom.Attr.classes ["column"]] [Vdom.Node.text "Picture"];
    Vdom.Node.div [Vdom.Attr.classes ["column"]] [Vdom.Node.text result.name];
  ]

let render (model : Search_bar.Model.t) =
  Vdom.Node.div [] (List.map ~f:render_result model.results)
