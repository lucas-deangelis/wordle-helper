type searched_word = {
  a : char option;
  b : char option;
  c : char option;
  d : char option;
  e : char option;
}

exception Pattern_not_5_characters

let letter_or_none (c : char) =
  if Char.code c >= 97 && Char.code c <= 122 then Some c else None

let searched_word_of_pattern (pattern : string) =
  if String.length pattern != 5 then raise Pattern_not_5_characters
  else
    {
      a = letter_or_none pattern.[0];
      b = letter_or_none pattern.[1];
      c = letter_or_none pattern.[2];
      d = letter_or_none pattern.[3];
      e = letter_or_none pattern.[4];
    }

let toto = Buffer.of_seq (String.to_seq "[a-z]")

let regex_of_searched_word (word : searched_word) : string =
  let buffer = Buffer.create 16 in
  if word.a = None then Buffer.add_buffer buffer toto
  else Buffer.add_char buffer (Option.get word.a);
  if word.b = None then Buffer.add_buffer buffer toto
  else Buffer.add_char buffer (Option.get word.b);
  if word.c = None then Buffer.add_buffer buffer toto
  else Buffer.add_char buffer (Option.get word.c);
  if word.d = None then Buffer.add_buffer buffer toto
  else Buffer.add_char buffer (Option.get word.d);
  if word.e = None then Buffer.add_buffer buffer toto
  else Buffer.add_char buffer (Option.get word.e);
  Bytes.to_string (Buffer.to_bytes buffer)

let next_line ch =
  match input_line ch with x -> Some (x, ch) | exception End_of_file -> None

let seq_of_file_lines filename = (Seq.unfold next_line) (open_in filename)
let words = "./words.txt" |> seq_of_file_lines

let string_contains_list s lst =
  lst
  |> List.map (fun x -> String.contains s x)
  |> List.fold_left (fun x y -> x && y) true

let get_or arr idx =
  match Array.get arr idx with el -> el | exception Invalid_argument _ -> ""

let filter_good_letters letters seq =
  if letters = [] then seq
  else Seq.filter (fun x -> string_contains_list x letters) seq

let filter_bad_letters letters seq =
  if letters = [] then seq
  else Seq.filter (fun x -> not (string_contains_list x letters)) seq

let list_of_arr idx arr = get_or arr idx |> String.to_seq |> List.of_seq

let () =
  let argv = Sys.argv in
  let searched = searched_word_of_pattern argv.(1) in
  let regex = Str.regexp (regex_of_searched_word searched) in
  words
  |> Seq.filter (fun x -> Str.string_match regex x 0)
  |> filter_good_letters (list_of_arr 2 argv)
  |> filter_bad_letters (list_of_arr 3 argv)
  |> Seq.iter print_endline
