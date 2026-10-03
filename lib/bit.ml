type t = Zero | One

let to_string b = match b with Zero -> "0" | One -> "1"

let rec list_to_string bs =
  match bs with [] -> "" | b :: bs -> to_string b ^ list_to_string bs
