open! Core
open ICC

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
