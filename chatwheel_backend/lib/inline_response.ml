open Base;;

type inline_query_result_audio = {
  audio_url : string;
  title : string;
  id : string;
}

type answer_inline_query = {
  inline_query_id : string;
  results : inline_query_result_audio list;
}

let from_audio (audio : Chatwheel_core.Audio.t) : inline_query_result_audio =
  let id : (String.t) = Int.to_string audio.id in
  { audio_url = audio.url; title = audio.name; id }

let build_inline_query_answer (id : string) (audios : Chatwheel_core.Audio.t list) :
    answer_inline_query =
  let audio_results = List.map ~f:from_audio audios in
  { inline_query_id = id; results = audio_results }

let to_json (answer : answer_inline_query) : Yojson.Safe.t =
  `Assoc
    [
      ("inline_query_id", `String answer.inline_query_id);
      ( "results",
        `List
          (List.map
             ~f:(fun result ->
               `Assoc
                 [
                   ("type", `String "audio");
                   ("audio_url", `String result.audio_url);
                   ("title", `String result.title);
                   ("id", `String result.id);
                 ])
             answer.results) );
    ]
