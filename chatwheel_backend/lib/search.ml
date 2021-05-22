(* Search module *)

open Yojson.Safe.Util

let get_audios = Yojson.Safe.from_file "./priv/data/audio.json"

let is_substr str sub =
  let re = Str.regexp_string sub in
  try
    ignore (Str.search_forward re str 0);
    true
  with Not_found -> false

let min x y = if x < y then x else y

let rec take n xs =
  match n with 0 -> [] | _ -> List.hd xs :: take (n - 1) (List.tl xs)

let audio_match (search : string) (a : Chatwheel_core.Audio.t) =
  let substr = is_substr
    (String.lowercase_ascii a.name)
    (String.lowercase_ascii search) in
  let match_tag = Chatwheel_core.Audio.has_tag a search in
  substr || match_tag

let top_search max_results search =
  let audios = Chatwheel_core.Audio.t_list_of_yojson get_audios in
  let filtered =
    List.filter (audio_match search) audios
  in
  let take_amount = min (List.length filtered) max_results in
  take take_amount filtered
