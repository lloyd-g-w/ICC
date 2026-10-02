open! Core

type 'a huff_tree =
  | Leaf of 'a * float
  | Node of 'a huff_tree * 'a huff_tree * float

(* returns probability associated with a tree's root node *)
let prob (tree : 'a huff_tree) =
  match tree with Leaf (_, p) -> p | Node (_, _, p) -> p

(* compares 2nd element of pair (the probability) -- for descending order  *)
let cmp_snd_dec (_, b1) (_, b2) = Float.compare b2 b1

let make_huff_tree (input : ('a * float) list) =
  let h = Pairing_heap.of_list input ~cmp:cmp_snd_dec in
  let f = Pairing_heap.pop h in
  let s = Pairing_heap.pop h in
  (f, s)
