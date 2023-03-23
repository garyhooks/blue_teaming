-r or -R is recursive,
-n is line number, and
-w stands for match the whole word.
-l (lower-case L) can be added to just give the file name of matching files.
-e is the pattern used during the search

Can exclude directory with --exclude-dir

> grep -inRw ./* -e "Access Denied"
