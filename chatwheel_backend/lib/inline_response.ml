open Base;;

type inline_query_result_audio = {
  audio_url : string;
  title : string;
  id : string;
} [@@deriving yojson]

type inline_query_answer = {
  inline_query_id : string;
  results : inline_query_result_audio list;
} [@@deriving yojson]

let from_audio (audio : Chatwheel_core.Audio.t) : inline_query_result_audio =
  let id : (String.t) = Int.to_string audio.id in
  { audio_url = audio.url; title = audio.name; id }

let build_inline_query_answer (id : string) (audios : Chatwheel_core.Audio.t list) :
    inline_query_answer =
  let audio_results = List.map ~f:from_audio audios in
  { inline_query_id = id; results = audio_results }
