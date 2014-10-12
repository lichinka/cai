cat daemon.log | egrep '0 uncovered' | tr -d '[:alpha:]' | cut -d',' -f3 | sort -n | head
