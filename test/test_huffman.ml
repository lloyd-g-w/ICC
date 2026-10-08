open! Core
open ICC

(*

output of the test:

=== Tree ===
|-- 0
|   |-- 0
|   |   |-- 0  [ 000 -> s3 ]
|   |   `-- 1  [ 001 -> s4 ]
|   `-- 1  [ 01 -> s1 ]
`-- 1
    |-- 0
    |   |-- 0  [ 100 -> s5 ]
    |   `-- 1  [ 101 -> s6 ]
    `-- 1  [ 11 -> s2 ]

=== Codes ===
s1 -> 01
s2 -> 11
s3 -> 000
s4 -> 001
s5 -> 100
s6 -> 101

=== Encode / Decode ===
s1 -> 01 -> s1
s2 -> 11 -> s2
s3 -> 000 -> s3
s4 -> 001 -> s4
s5 -> 100 -> s5
s6 -> 101 -> s6

=== Non-pretty output ===
000 -> s3
001 -> s4
01 -> s1
100 -> s5
101 -> s6
11 -> s2

*)

let () =
  let input =
    [
      ("s1", 0.3);
      ("s2", 0.2);
      ("s3", 0.2);
      ("s4", 0.1);
      ("s5", 0.1);
      ("s6", 0.1);
    ]
  in
  match Huffman.of_list input with
  | None -> printf "Invalid Tree\n"
  | Some tree ->
      printf "=== Tree ===\n";
      Huffman.pp Fun.id tree;

      let table = Huffman.to_hashtbl (module String) tree in

      printf "\n=== Codes ===\n";
      List.iter input ~f:(fun (symbol, _) ->
          match Huffman.encode symbol table with
          | None -> printf "%s -> NOT FOUND\n" symbol
          | Some code -> printf "%s -> %s\n" symbol (Bit.list_to_string code));

      printf "\n=== Encode / Decode ===\n";
      List.iter input ~f:(fun (symbol, _) ->
          match Huffman.encode symbol table with
          | None -> printf "%s -> NOT FOUND\n" symbol
          | Some code -> (
              match Huffman.decode code tree with
              | Some x ->
                  printf "%s -> %s -> %s\n" symbol (Bit.list_to_string code) x
              | None ->
                  printf "%s -> %s -> INVALID\n" symbol
                    (Bit.list_to_string code)));

      printf "\n=== Non-pretty output ===\n";
      Huffman.pp Fun.id ~pretty:false tree
