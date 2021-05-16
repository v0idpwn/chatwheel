open! Core_kernel
open! Bonsai_web

module Search_result = struct
  type t = {id: Int.t; name: String.t; url: String.t} [@@deriving sexp, equal]
end

module Search_bar = struct
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
end

let search_component : ('input, 'result) Bonsai.t = 
  Bonsai.of_module (module Search_bar) ~default_model: Search_bar.Model.default

let results_component = 
  let render_result (result : Search_result.t) : Vdom.Node.t =
    Vdom.Node.div [
      Vdom.Attr.classes ["columns"]
    ] [
      Vdom.Node.div [Vdom.Attr.classes ["column"]] [Vdom.Node.text "Picture"];
      Vdom.Node.div [Vdom.Attr.classes ["column"]] [Vdom.Node.text result.name];
    ]
  in
  Bonsai.pure ~f:(fun (model : Search_bar.Model.t) ->
    Vdom.Node.div [] (List.map ~f:render_result model.results)
  )
;;

let application : ('input, 'result) Bonsai.t =
  let open Bonsai.Let_syntax in
  let%map results_list, search_bar = search_component >>> Bonsai.Arrow.first results_component
  in
  Vdom.Node.div [] [search_bar; results_list]
;;

let (_ : _ Start.Handle.t) =
  Start.start_standalone ~initial_input:() ~bind_to_element_with_id:"app" application
;;
