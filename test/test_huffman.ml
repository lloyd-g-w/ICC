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
  | Some tree -> Huffman.print Fun.id tree
