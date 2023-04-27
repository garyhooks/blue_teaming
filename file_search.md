find . -type f -exec grep -e "GET " -e "POST " {} \; | grep -v -e "failed login" -e "POST /directory/file/login.php HTTP/1.1" -e "/directory/file/login.php HTTP/1.1;sessionid=" > results.txt


-r or -R is recursive,
-n is line number, and
-w stands for match the whole word.
-l (lower-case L) can be added to just give the file name of matching files.
-e is the pattern used during the search

Can exclude directory with --exclude-dir

> grep -inRw ./* -e "Access Denied"
