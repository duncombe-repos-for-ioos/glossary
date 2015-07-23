#! /bin/bash



numdefs=$(
	cat README.md | awk '
	BEGIN{count=0; content=1}
        /<!--/{content=0}
	/<DT>/ && content{count++}
	/<DT>.*name=.*href=#contents/ && content{count--}
	/<DT>.*<DT>/ && content{print "Warning: Two DT tags on the same line (" NR ")" > "/dev/stderr" }
	/<DD>.*<DD>/ && content{print "Warning: Two DD tags on the same line (" NR ")" > "/dev/stderr" }
        /-->/{content=1}
	END{print count}
	' )

# README.md might be a symlink. We have to avoid overwriting that, 
# so do not do sed in place!
if true; then
tmpfile=`mktemp`
cat README.md > $tmpfile 
cat $tmpfile | sed '/A glossary of[0-9 ]\+.*data management terms/s/\(A glossary of\)[0-9 ]\+\(\(environmental \)\?data management terms\)/\1 '$numdefs' \2/' > README.md 
rm $tmpfile
fi

>&2 echo Found $numdefs definitions 

# vim: se nowrap tw=0 : 
