open! Core_kernel
open! Bonsai_web
open! Frontend_common

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

let (_ : _ Start.Handle.t) =
  Start.start_standalone ~initial_input:() ~bind_to_element_with_id:"app" application
;;
