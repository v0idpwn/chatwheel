(* Search module *)

open Base;;
open Yojson.Safe.Util;;

let get_audios = Yojson.Safe.from_file "./priv/data/audio.json"

let min x y = if x < y then x else y

let audio_match (search : string) (a : Chatwheel_core.Audio.t) =
  let substr = String.is_substring
    ~substring:(String.lowercase search)
    (String.lowercase a.name) in
  let match_tag = Chatwheel_core.Audio.has_tag a search in
  substr || match_tag

let top_search max_results search =
  let audios = Chatwheel_core.Audio.t_list_of_yojson get_audios in
  let filtered =
    List.filter ~f:(audio_match search) audios
  in
  List.take filtered max_results 
