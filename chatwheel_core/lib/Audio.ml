open Base;;

type t = { id : int; name : string; url : string; tags : string list} [@@deriving yojson]

let has_tag (audio : t) (search : String.t) : Bool.t =
  let open Base.String in
  let result = List.find audio.tags ~f:(fun tag -> tag = search) in
  match result with
  | Some _ -> true
  | None -> false

let t_list_of_yojson json =
  let json_list = Yojson.Safe.Util.to_list json in
  List.map ~f:t_of_yojson json_list
