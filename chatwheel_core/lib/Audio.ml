open Base;;

type t = { id : int; name : string; url : string; tags : string list} [@@deriving yojson]


let has_a_tag (audio : t) (search : String.t List.t) : Bool.t =
  let open Base.String in
  let result = List.find audio.tags ~f:(List.mem search ~equal:(fun a b -> a = b)) in
  match result with
  | Some _ -> true
  | None -> false

let t_list_of_yojson json =
  let json_list = Yojson.Safe.Util.to_list json in
  List.map ~f:t_of_yojson json_list
