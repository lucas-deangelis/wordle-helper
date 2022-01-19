Two lists of words:

- allowed-guesses.txt
- answers.txt

I want just one list, sorted: `cat allowed-guesses.txt answers.txt | sort > words.txt`. Could add `| uniq` before `> words.txt`: `cat allowed-guesses.txt answers.txt | sort | uniq > words.txt` but wasn't needed here.

