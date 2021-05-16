open! Core_kernel
open! Bonsai_web
open! Frontend_common

module Input = Unit

module Model = struct
  type t = {text: String.t; results: Search_result.t List.t} [@@deriving sexp, equal]
  let default = {text = ""; results = []}
end

module Result = struct
  type t = Model.t * Vdom.Node.t
end

module Action = struct
  type t =
    | ChangeText of String.t
    | Search
  [@@deriving sexp_of]
end

let search (text : String.t) : Search_result.t = {id= 1; name= text; url= "#"}

let apply_action ~inject:_ ~schedule_event:_ () (model : Model.t) action =
  match action with
  | Action.ChangeText new_text -> 
      { model with text = new_text }
  | Action.Search -> 
      let new_result = search model.text in
      { model with results = new_result::model.results}

let compute ~inject () (model : Model.t) =
  let button = Vdom.Node.button [
    Vdom.Attr.on_click (fun _ -> inject Action.Search);
    Vdom.Attr.classes ["button"; "is-primary"]
  ] [ Vdom.Node.text "Search" ] in
  let text_field = Vdom.Node.input [
    Vdom.Attr.on_input (fun _ input_text -> inject (Action.ChangeText input_text));
    Vdom.Attr.classes ["input"];
    Vdom.Attr.value model.text
  ]
  [] in
  (model, Vdom.Node.div [Vdom.Attr.classes ["field"; "has-addons"]] [
    Vdom.Node.div [Vdom.Attr.classes ["control"]] [text_field]; 
    Vdom.Node.div [Vdom.Attr.classes ["control"]] [button];
  ])
  ;;

let name = Source_code_position.to_string[%here]
