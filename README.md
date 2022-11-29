My personal Textadept config.

For 3rd party modules instead of using specific releases I just use a git
submodule making it quick and easy to update. When doing a new checkout:

```sh
git clone git@github.com:eric1234/.textadept.git
git submodule init
git submodule update
```

Also set the `EDITOR` environment variable so Textadept can be used for editing
files managed by a program (such as git commit messages or Rails encrypted
credentials). On Mac that ENV variable should be set to:

    export EDITOR="open -W -n -a Textadept.app --args -f"

While on Linux it should just be:

    export EDITOR="textadept -f"
