type t = {
  query: string option [@default None]; 
  tags: string list [@default []];
  limit: int [@default 50];
} [@@deriving yojson]

