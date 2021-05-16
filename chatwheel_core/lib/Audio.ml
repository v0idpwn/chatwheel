open Yojson.Safe.Util

type audio = { id : Int.t; name : String.t; url : String.t; tags : String.t List.t} [@@deriving yojson]
