(* Sample inline input 
  ```
    {
      "update_id": 559465958,
      "inline_query": {
        "id": "1281875166009689372",
        "from": {
          "id": 298459819,
          "is_bot": false,
          "first_name": "felipe",
          "last_name": "༼ つ ◕_◕ ༽つ v0idpwn",
          "username": "v0idpwn",
          "language_code": "en"
        },
        "query": "kok",
        "offset": ""
      }
    }
  ```
*)

open Base;;

type inline_query = { id : string; query : string }

let build_query json =
  let inline_query = Yojson.Safe.Util.member "inline_query" json in
  let query =
    Yojson.Safe.Util.to_string (Yojson.Safe.Util.member "query" inline_query)
  in
  let id =
    Yojson.Safe.Util.to_string (Yojson.Safe.Util.member "id" inline_query)
  in
  { id; query }
