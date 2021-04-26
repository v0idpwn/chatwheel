open Yojson.Safe.Util

type audio = { name : string; url : string; tags : string list }

let get_audios = Yojson.Safe.from_file "./priv/data/audio.json"

let from_json (json : Yojson.Safe.t) : audio list =
  List.map (fun item -> 
    let name = to_string (member "name" item) in
    let url = to_string (member "url" item) in
    let tags = List.map to_string (to_list (member "tags" item)) in
    {name; url; tags}
  ) (Yojson.Safe.Util.to_list json)

let is_substr str sub=
    let re = Str.regexp_string sub
    in
        try ignore (Str.search_forward re str 0); true
        with Not_found -> false

let min x y = if x < y then x else y

let rec take n xs = match n with 
  | 0 -> []
  | _ -> List.hd xs :: take (n-1) (List.tl xs)
        
let top_search search =
  let audios = from_json get_audios in
  let filtered = List.filter (fun a -> is_substr a.name search) audios in
  let max_results = min (List.length filtered) 10 in
  let _ = List.map (fun x -> print_endline x.name) filtered in
    take max_results filtered
