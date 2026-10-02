open! Core

type 'a t

val of_list : ('a * float) list -> 'a t option
val print : ('a -> string) -> ?pretty:bool -> 'a t -> unit

val to_hashtbl :
  (module Hashtbl.Key with type t = 'a) -> 'a t -> ('a, string) Hashtbl.t
(* val encode : 'a t -> 'a list -> bool list *)
(* val decode : 'a t -> bool list -> 'a list *)
