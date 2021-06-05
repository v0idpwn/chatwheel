open! Core_kernel
open! Bonsai_web

module Input = App_input

module Model = struct
  type t = {text: String.t; results: Chatwheel_core.Audio.t List.t} [@@deriving sexp, equal]
  let default = {text = ""; results = []}
end

module Result = struct
  type t = Input.t * Vdom.Node.t
end

module Action = struct
  type t =
    | ChangeText of String.t
    | Search
  [@@deriving sexp_of]
end

let search (text : String.t) : Chatwheel_core.Audio.t = {id= 1; name= text; url= "#"; tags=[]}

let apply_action ~inject:_ ~schedule_event:_ _input (model : Model.t) action =
  match action with
  | Action.ChangeText new_text -> 
      { model with text = new_text }
  | Action.Search -> 
      { model with results = []}

let compute ~inject (input : Input.t) (model : Model.t) =
  let button = Vdom.Node.button [
    Vdom.Attr.on_click (fun _ -> Effect.inject_ignoring_response (input.search_query model.text));
    Vdom.Attr.classes ["button"; "is-primary"]
  ] [ Vdom.Node.text "Search" ] in
  let text_field = Vdom.Node.input [
    Vdom.Attr.on_input (fun _ input_text -> inject (Action.ChangeText input_text));
    Vdom.Attr.classes ["input"];
    Vdom.Attr.value model.text
  ]
  [] in
  (input, Vdom.Node.div [Vdom.Attr.classes ["field"; "has-addons"]] [
    Vdom.Node.div [Vdom.Attr.classes ["control"]] [text_field]; 
    Vdom.Node.div [Vdom.Attr.classes ["control"]] [button];
  ])
  ;;

let name = Source_code_position.to_string[%here]
