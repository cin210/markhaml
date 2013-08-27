markhaml
========

Convert  Markdown => HTML => HAML

#Warning
Running this script will attempt to convert (and subsequently overwrite) pre-existing *.html and *.haml files within an entire directory.

ALL OF THEM.

ALL THE .MD

AND ALL THE .HTML

SIMULTANEOUSLY

IN ALL THE FOLDERS

IN THAT DIRECTORY TREE

The creator is not responsible for your directory getting fubar'd, use version control, hack responsibly

##Howto
```git clone git@github.com:cin210/markhaml.git```

```cd markhaml ```

```ruby markhaml [/path/to/markdown/folder]```

YOU PROBABLY DON'T WANT TO PASS ROOT TO THIS METHOD

Note: get your own PERSONAL APPLICATION TOKEN from github for more  than 50 html conversions

##Dependencies
```gem install html2haml```

```gem install octokit```

Be sure to check permissions of the folder used. sudo is your friend!

