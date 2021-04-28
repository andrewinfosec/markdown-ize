### markdown-ize: Convert Markdown files into a portable HTML+CSS package

By Andrew Stewart ([https://andrewinfosec.com](https://andrewinfosec.com))

[markdown-ize](https://github.com/andrewinfosec/markdown-ize) is a Bash script
that creates a directory containing HTML files from a source directory
containing Markdown files. The file names of the Markdown files are used to
generate an `index.html` containing links to each file, and a CSS file is 
placed into the destination directory for portability.

An example use-case is taking notes in plaintext Markdown across several files,
then processing those files so that they can be moved as a single unit onto a
web server.

#### Example

    $ ls 
    default.css md  markdown-ize.sh
    $ ls md
    one.md    three.md  two.md
    $ ./markdown-ize.sh ./md/*.md
    $ ls html
    default.css index.html  one.html  three.html  two.html
    $ open html/index.html

#### Options

    $ ./markdown-ize.sh -h
    usage: markdown-ize.sh [options] <markdown files>

    options: -d <destination directory>  # defaults to ./html
             -c <css file>               # defaults to ./default.css

    e.g. $ ./markdown-ize.sh *.md


#### Enhancements

A possible future enhancement would be to interrogate file timestamps so that
only those Markdown files that have changed since the last run are processed.

#### Style

This project follows the [Google Shell Style
Guide](https://google.github.io/styleguide/shell.xml).
