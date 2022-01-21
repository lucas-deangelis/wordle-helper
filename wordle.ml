let next_line ch =
  match input_line ch with x -> Some (x, ch) | exception End_of_file -> None

let seq_of_file_lines filename = (Seq.unfold next_line) (open_in filename)
let words = "./words.txt" |> seq_of_file_lines

let string_contains_all_characters s characters =
  characters
  |> List.for_all (fun c -> String.contains s c)

let string_contains_no_characters (s: string) (characters: char list) =
  characters
  |> List.exists (fun c -> String.contains s c)
  |> not

let get_or arr idx =
  match Array.get arr idx with el -> el | exception Invalid_argument _ -> ""

let filter_letters f letters seq =
  if letters = [] then seq
  else Seq.filter (fun x -> f x letters) seq

let list_of_arr idx arr = get_or arr idx |> String.to_seq |> List.of_seq
let wildcards_to_regex = Str.global_replace (Str.regexp "\\*") "[a-z]"

let () =
  let argv = Sys.argv in
  let regex = Str.regexp (wildcards_to_regex argv.(1)) in
  words
  |> Seq.filter (fun x -> Str.string_match regex x 0)
  |> filter_letters string_contains_all_characters (list_of_arr 2 argv)
  |> filter_letters string_contains_no_characters (list_of_arr 3 argv)
  |> Seq.iter print_endline
