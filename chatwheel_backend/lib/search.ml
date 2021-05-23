(* Search module *)

open Base;;
open Yojson.Safe.Util;;

type t = {
  query: string option [@default None]; 
  tags: string list [@default []];
  limit: int [@default 50];
} [@@deriving yojson]

let get_audios = Yojson.Safe.from_file "./priv/data/audio.json"

let audio_match (search : t) (a : Chatwheel_core.Audio.t) =
  let match_tag = Chatwheel_core.Audio.has_a_tag a search.tags in
  let substr = 
    match search.query with
    | Some q -> String.is_substring ~substring:(String.lowercase q) (String.lowercase a.name)
    | None -> true
  in
  substr || match_tag

let top_search search =
  let audios = Chatwheel_core.Audio.t_list_of_yojson get_audios in
  let filtered =
    List.filter ~f:(audio_match search) audios
  in
  List.take filtered search.limit

let t_of_inline_input (inline_query : Inline_input.inline_query) =
  { query = Option.some inline_query.query; tags=[]; limit = 10 }
