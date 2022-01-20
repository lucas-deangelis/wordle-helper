let next_line ch =
  match input_line ch with x -> Some (x, ch) | exception End_of_file -> None

let seq_of_file_lines filename = (Seq.unfold next_line) (open_in filename)
let words = "./words.txt" |> seq_of_file_lines

let string_contains_list_good s lst =
  lst
  |> List.map (fun x -> String.contains s x)
  |> List.fold_left (fun x y -> x && y) true

let string_contains_list_bad s lst =
  lst
  |> List.map (fun x -> String.contains s x)
  |> List.fold_left (fun x y -> x || y) false

let get_or arr idx =
  match Array.get arr idx with el -> el | exception Invalid_argument _ -> ""

let filter_good_letters letters seq =
  if letters = [] then seq
  else Seq.filter (fun x -> string_contains_list_good x letters) seq

let filter_bad_letters letters seq =
  if letters = [] then seq
  else Seq.filter (fun x -> not (string_contains_list_bad x letters)) seq

let list_of_arr idx arr = get_or arr idx |> String.to_seq |> List.of_seq
let wildcards_to_regex = Str.global_replace (Str.regexp "\\*") "[a-z]"

let () =
  let argv = Sys.argv in
  let regex = Str.regexp (wildcards_to_regex argv.(1)) in
  words
  |> Seq.filter (fun x -> Str.string_match regex x 0)
  |> filter_good_letters (list_of_arr 2 argv)
  |> filter_bad_letters (list_of_arr 3 argv)
  |> Seq.iter print_endline
