# make summary file
rm ../SUMMARY.md
touch ../SUMMARY.md
echo "# Summary\n" >> ../SUMMARY.md

echo "* [Introduction](README.md)\n" >> ../SUMMARY.md

mkdir -p ../en
parentfolder='xxxxxxx'
parentfolderTitle=''
foldercount=1

while read line
do
  # turn the spaces into lowerdash _
  newline=$(echo $line | sed 's/ /_/g')

  # turn slash and other characters to lowerdash _
  newline=$(echo $newline | sed 's/\//_/g')
  newline=$(echo $newline | sed 's/(/-/g')
  newline=$(echo $newline | sed 's/)/-/g')
  newline=$(echo $newline | sed 's/|/-/g')

  #filter out & sign
  newline=$(echo $newline | sed 's/&//g')

  # turn all to lowercase
  newline=`echo "${newline}" | tr [A-Z] [a-z]`


  # check if line starts with &&
  if [[ $line == '&&'* ]]
  then
    # replace & signs
    line=$(echo $line | sed 's/&&//g')
    filepath=en/"$parentfolder"/"$newline".md
    summaryline="   * [$line]($filepath)"

    # add title to file
    echo `echo "## ${parentfolderTitle}\n"` >> ../"$filepath"
    echo `echo "### ${line}"` >> ../"$filepath"
    echo "-----" >> ../"$filepath"
  else
    # if line starts with only 1 & then replace by 1 tab and do not add the filepath
    if [[ $line == '&'* ]]
    then
      # replace & sign by tab
      line=$(echo $line | sed 's/&//g')
      parentfolder="${foldercount}_${newline}"
      parentfolderTitle=${line}
      mkdir -p ../en/"$parentfolder"
      summaryline=" * ${foldercount}\\. ${line}"
      foldercount=`expr $foldercount + 1`

    else
      summaryline="\n* $line"
    fi
  fi
  echo summaryline: "$summaryline"

  echo "$summaryline" >> ../SUMMARY.md
done < examtopics.txt
