(* Read entire content from a file `f` *)
let read_file f =
    let ch = open_in f in
    let s = really_input_string ch (in_channel_length ch) in
    close_in ch;
    s
