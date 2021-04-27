(lang dune 2.8)

(name chatwheel)
(version 0.1.0)

(generate_opam_files true)

(source (github v0idpwn/chatwheel))
(authors "Felipe Stival")
(maintainers "Felipe Stival <v0idpwn@gmail.com>")
(license MIT)

(package
 (name chatwheel)
 (synopsis "A dota 2 audio bot for telegram")
 (depends
   (cohttp-lwt-unix (= 4.0))
   (dune (= 2.8))
   (lwt_ssl (= 1.1.3))
   (ocaml-lsp-server (= 1.5.0))
   (ocamlformat (= 0.18.0))
   (opium (= 0.20.0))
   (ocaml (= 4.12))
   (str (= 1.2.3))
))
