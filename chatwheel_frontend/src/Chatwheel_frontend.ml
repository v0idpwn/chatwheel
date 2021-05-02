open! Core_kernel
open! Bonsai_web

(* let (_ : unit) = print_string "Hello, world!"; *)

let component = Bonsai.const (Vdom.Node.text "hello world")

let (_ : _ Start.Handle.t) =
  Start.start_standalone ~initial_input:() ~bind_to_element_with_id:"app"
  component
;;
