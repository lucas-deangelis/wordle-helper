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

let print_help () =
  print_endline "Max two arguments: po*** i";
  print_endline
    "First argument: list of letters found at the right place and wildcards";
  print_endline "Second argument: list of letters found"

let () =
  let argv = Sys.argv in
  if Array.length argv > 3 then print_help ();
  if
    (Array.length argv = 2 || Array.length argv = 3)
    && String.length argv.(1) = 5
  then
    let searched = searched_word_of_pattern argv.(1) in
    let regex = Str.regexp (regex_of_searched_word searched) in
    let rec filter_words w s =
      match s with
      | [] -> w
      | c :: tail ->
          filter_words ((Seq.filter (fun x -> String.contains x c)) w) tail
    in
    filter_words words (List.of_seq (String.to_seq argv.(2)))
    |> Seq.filter (fun x -> Str.string_match regex x 0)
    |> Seq.iter print_endline
