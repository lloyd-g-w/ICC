open! Core

type 'a t

val of_list : ('a * float) list -> 'a t option
val pp : ('a -> string) -> ?pretty:bool -> 'a t -> unit

val to_hashtbl :
  (module Hashtbl.Key with type t = 'a) -> 'a t -> ('a, Bit.t list) Hashtbl.t

val encode : 'a -> ('a, Bit.t list) Hashtbl.t -> Bit.t list option
val decode : Bit.t list -> 'a t -> 'a option
