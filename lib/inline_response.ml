type inline_query_result_audio = {
  audio_url : string;
  title : string;
  caption : string;
  id : string;
}

type answer_inline_query = {
  inline_query_id : string;
  results : inline_query_result_audio list;
}

let from_audio (audio : Audio.audio) : inline_query_result_audio =
  let caption = List.hd audio.tags in
  let id = string_of_int audio.id in
  { audio_url = audio.url; title = audio.name; caption; id }

let build_inline_query_answer (id : string) (audios : Audio.audio list) :
    answer_inline_query =
  let audio_results = List.map from_audio audios in
  { inline_query_id = id; results = audio_results }

let to_json (answer : answer_inline_query) : Yojson.Safe.t =
  `Assoc
    [
      ("inline_query_id", `String answer.inline_query_id);
      ( "results",
        `List
          (List.map
             (fun result ->
               `Assoc
                 [
                   ("type", `String "audio");
                   ("audio_url", `String result.audio_url);
                   ("title", `String result.title);
                   ("id", `String result.id);
                 ])
             answer.results) );
    ]
