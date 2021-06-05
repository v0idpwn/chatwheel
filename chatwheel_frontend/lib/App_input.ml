open! Core_kernel
open! Bonsai_web

type t = {
  uri : Uri.t;
  search_query : String.t -> unit Effect.t;
  play_audio : String.t -> unit Effect.t;
  search_results : Chatwheel_core.Audio.t List.t Option.t
}

let default uri =
  {
    uri = uri;
    search_query = (fun _query -> Effect.never);
    play_audio = (fun _url -> Effect.never);
    search_results = None
  }
