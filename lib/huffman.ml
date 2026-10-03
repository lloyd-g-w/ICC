open! Core

type 'a t = { data : 'a t_data; height : int }
and 'a t_data = Leaf of 'a * float | Node of 'a t * 'a t * float

let prob (tree : 'a t) =
  match tree.data with Leaf (_, p) -> p | Node (_, _, p) -> p

let height (tree : 'a t) = tree.height

let cmp_tree (t1 : 'a t) (t2 : 'a t) =
  let prob_cmp = Float.compare (prob t1) (prob t2) in
  match prob_cmp with 0 -> Int.compare (height t1) (height t2) | c -> c

let of_list (input : ('a * float) list) =
  let mk_leaf (a, b) = { data = Leaf (a, b); height = 0 } in
  let tree_list = List.map input ~f:mk_leaf in
  let tree_heap = Pairing_heap.of_list tree_list ~cmp:cmp_tree in
  let rec aux tree_heap =
    if Pairing_heap.length tree_heap <= 1 then ()
    else
      match (Pairing_heap.pop tree_heap, Pairing_heap.pop tree_heap) with
      | Some f, Some s ->
          let new_node =
            {
              data = Node (s, f, prob f +. prob s);
              height = 1 + Int.max (height f) (height s);
            }
          in
          Pairing_heap.add tree_heap new_node;
          aux tree_heap
      | _ -> ()
  in
  aux tree_heap;
  Pairing_heap.pop tree_heap

let to_hashtbl (type a) (module Key : Core.Hashtbl.Key with type t = a)
    (tree : a t) =
  let res = Hashtbl.create (module Key) in
  let rec aux code tree =
    match tree.data with
    | Leaf (x, _) -> Hashtbl.add_exn res ~key:x ~data:(List.rev code)
    | Node (l, r, _) ->
        aux (Bit.Zero :: code) l;
        aux (Bit.One :: code) r
  in
  aux [] tree;
  res

let pp to_string ?(pretty = true) tree =
  let rec aux prefix code is_last bit tree =
    let branch = if is_last then "`-- " else "|-- " in
    let next_prefix = prefix ^ if is_last then "    " else "|   " in
    match tree.data with
    | Leaf (x, _) ->
        if pretty then
          printf "%s%s%s  [ %s -> %s ]\n" prefix branch bit code (to_string x)
        else printf "%s -> %s\n" code (to_string x)
    | Node (l, r, _) ->
        if pretty then printf "%s%s%s\n" prefix branch bit;
        aux next_prefix (code ^ "0") false "0" l;
        aux next_prefix (code ^ "1") true "1" r
  in
  match tree.data with
  | Leaf (x, _) -> printf "%s []\n" (to_string x)
  | Node (l, r, _) ->
      aux "" "0" false "0" l;
      aux "" "1" true "1" r

let encode to_encode tree_map = Hashtbl.find tree_map to_encode

let decode codeword tree =
  let rec aux codeword tree =
    match codeword with
    | [] -> ( match tree.data with Leaf (x, _) -> Some x | _ -> None)
    | c :: cs -> (
        match tree.data with
        | Leaf (_, _) -> None
        | Node (l, r, _) -> (
            match c with Bit.Zero -> aux cs l | Bit.One -> aux cs r))
  in
  aux codeword tree
