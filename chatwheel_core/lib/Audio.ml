open Yojson.Safe.Util

type t = { id : Int.t; name : String.t; url : String.t; tags : String.t List.t} [@@deriving yojson]
