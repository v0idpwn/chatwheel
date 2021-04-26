type inline_query_result_audio = {
  audio_url : string;
  title : string;
  caption : string;
}

type answer_inline_query = {
  inline_query_id : string;
  results : inline_query_result_audio list;
}

let from_audio (audio : Audio.audio) : inline_query_result_audio =
  let caption = List.hd audio.tags in
  { audio_url = audio.url; title = audio.name; caption }

let build_inline_query_answer (id : string) (audios : Audio.audio list) :
    answer_inline_query =
  let audio_results = List.map from_audio audios in
  { inline_query_id = id; results = audio_results }
