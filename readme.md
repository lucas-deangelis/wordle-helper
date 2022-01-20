# wordle-helper

Usage: `wordle po*** i`

First argument is letters where you know the place. Has to be exactly 5 letters. Fill with \* if you don't know. Second arguments is all the letters you don't know the place of, but are in the word. Third arguments is the letters that can't be in the word. Example:



## Making of

Two lists of words:

- allowed-guesses.txt
- answers.txt

I want just one list, sorted: `cat allowed-guesses.txt answers.txt | sort > words.txt`. Could add `| uniq` before `> words.txt`: `cat allowed-guesses.txt answers.txt | sort | uniq > words.txt` but wasn't needed here.
