## Commit Comments

Commit Comments automatically create a bulleted list of changes from comments 
in your code. Write comments using `@commit` keyword, and they will be added to your commit message when it's time to commit.

It works by using two [Git hooks]() (prepare-commit-msg and post-commit) to
search your repository for @commit comments and construct a clean list of
changes. 

Once you've successfully committed, @commit comments are removed from
your files

### Installation

Clone the repository and move the `prepare-commit-msg` and `post-commit` files.

```
git clone https://github.com/thebearjew/commit-comments.git
cd commit-comments
chmod a+x prepare-commit-msg post-commit
cp prepare-commit-msg post-commit your-repository/.git/hooks 
```

### Usage

Commit Comments work with C-like comments `//` and `/* */`, as well as Python/Ruby/Perl `#`, and Assembly `;`. Other programming languages (HTML, AppleScript, etc.) coming later.

Example:

```js
foo.js

// @commit: Added a parameter to helloWorld function
function helloWorld(phrase) {
  console.log('Hello World + ' + phrase); /*  @commit - Concatenated strings */
}
```

Output in Git commit message

```
# Commit title goes here

- Added a parameter to helloWorld function
- Concatentated strings
# Changes to be committed:
#	modified:   foo.js 
#
# Changes not staged for commit:
# ...
```

Comments are removed from the original files.

```js
foo.js - after commit


function helloWorld(phrase) {
  console.log('Hello World + ' + phrase); 
}
```

### Compatibility & Required Commands
**Substitution functionality requires GNU sed**. On Mac OS X, the default sed is from the FreeBSD distribution. To download the GNU sed version, use [Brew](http://brew.sh)

`brew install gnu-sed --with-default-names` will replace the existing sed command with the GNU version. Without the `--with-default-names` option, the command will be downloaded as `gsed`.

Search functionality is implemented using pcregrep which is portable to many Linux distributions and OS X. If pcregrep is not available on the system, GNU grep is a backup (not required to use the hooks).

GNU grep is used for the `-P` Perl Regular Expression flag and the `\K` variable loopback symbol.


### Contributing & Todo
Preferred Contributions would be to improve readability and complexity of the Git hooks in this project. If there are useful improvements, tricks, or hacks, please submit a Pull Request and a directory of add-ons and snippets will be created.

**TODO**

- Create more robust regular expression for validating comment syntax
	- [ ] Check for multiline block comments
	- [ ] Check for closing comment symbols (positive look aheads)
- [ ] Rewrite sed commands to be POSIX (BSD) compatible regular expressions
- Programming Languages
	- [ ] HTML
	- [ ] Fortran
	- [ ] AppleScript
- [ ] Develop more test cases (finding edge cases with grep expression)

