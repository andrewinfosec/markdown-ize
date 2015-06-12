#!/usr/bin/env bash
#
# Convert Markdown files into a portable HTML+CSS package

function usage() {
  local PROGRAM=$(basename $0)
  cat << HERE
usage: $PROGRAM [options] <markdown files>

options: -d <destination directory>  # defaults to ./html
         -c <css file>               # defaults to ./default.css

e.g. $ $PROGRAM *.md

HERE
}

DESTINATION_DIR=./html
CSS=./default.css

while getopts hd:c: ARG; do
  case $ARG in
    h|-help)
      usage 
      exit 0
      ;;
    d)
      DESTINATION_DIR=$OPTARG
      ;;
    c)
      CSS=$OPTARG
      ;;
    ?)
      usage
      exit 1
      ;;
  esac
done

shift $(($OPTIND - 1))
SOURCE_FILES=$@

readonly DESTINATION_DIR CSS SOURCE_FILES

# Sanity-check environment
#
if [[ -z "$SOURCE_FILES" ]]; then
  echo "error: no files to process" >&2
  exit 1
fi

if [[ ! -d $DESTINATION_DIR ]]; then
  mkdir $DESTINATION_DIR || { exit 1; }
fi

if [[ ! -w $DESTINATION_DIR ]]; then
  chmod u+rwx $DESTINATION_DIR || { exit 1; }
fi

if [[ ! -r $CSS ]]; then
  echo "error: can't read $CSS" >&2
  exit 1
fi

if ! hash Markdown.pl 2>/dev/null; then # Is Markdown.pl in the path?
  echo "error: no Markdown.pl" >&2
  exit 1
else
  MARKDOWN=Markdown.pl
fi

# Create package = HTML files + HTML index + CSS file
#
cp $CSS $DESTINATION_DIR || { exit 1; }

INDEX_TEXT=

for path_and_file in $SOURCE_FILES; do
  echo "<link href=\"$(basename $CSS)\" rel=\"stylesheet\"></link>" > $$
  $MARKDOWN --html4tags $path_and_file >> $$

  FILENAME=$(basename $path_and_file)
  mv $$ $DESTINATION_DIR/${FILENAME%\.*}.html

  echo -n '.'

  NAME=${FILENAME%\.*}
  INDEX_TEXT=$INDEX_TEXT"[$NAME](./$NAME.html)  \n"
  # (Because a double space creates a newline in Markdown)
done
echo # Create a newline after the earlier use of echo -n

echo "<link href=\"$(basename $CSS)\" rel=\"stylesheet\"></link>" > $$

IFS='%' # Preserve whitespace to preserve double spaces in Markdown
echo -e $INDEX_TEXT >> $$
unset IFS

$MARKDOWN --html4tags $$ > $DESTINATION_DIR/index.html
rm $$

# EOF
