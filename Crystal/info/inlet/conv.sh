for file in *.md 
do
 pandoc -t latex < $file > "${file%.md}.tex"
done
