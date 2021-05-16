open! Core_kernel
open! Bonsai_web

module Search_result = struct
  type t = {id: Int.t; name: String.t; url: String.t} [@@deriving sexp, equal]
end
