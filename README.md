## Commit Comments

Commit Comments automatically create a bulleted list of changes from comments in your code. Write comments using `@commit` keyword, and they will be added to your commit message when it's time to commit.

It works by using two [Git hooks](https://www.kernel.org/pub/software/scm/git/docs/githooks.html) (**prepare-commit-m   sg** and **post-commit**) to
search your repository for @commit comments and construct a clean list of
changes. 

Once you've successfully committed, @commit comments are removed from
your files

### Installation

Clone the repository and move the `prepare-commit-msg` and `post-commit` files.

```
$ git clone https://github.com/thebearjew/commit-comments.git
$ cd commit-comments
$ chmod a+x prepare-commit-msg post-commit
$ cp prepare-commit-msg post-commit your-repository/.git/hooks 
```

### Usage

As you're writing code, drop `// @commit` comments anywhere a significant change has been made. 

Commit comments work with (inline & standalone):

- C-like comments (C/C++, Java, JavaScript, etc.) `//`, `/* */`
- Python/Ruby/Perl `#`
- Assembly `;`

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

- [foo.js#1] Added a parameter to helloWorld function
- [foo.js#3] Concatenated strings
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

### Ignoring Files
To ignore some files from being searched, create a `.ccignore` file in your repository and add file names/types.

```
README.md
build.sh
.cpp
```

### Dependencies
1. **GNU sed** is required to remove @commit comments in post-commit. 

  On Mac OS X, the default sed is from the FreeBSD distribution. To download the GNU sed version, use [Brew](http://brew.sh)

  ```
  $ brew install gnu-sed --with-default-names
  ```

  Without the `--with-default-names` option, the command will be downloaded as `gsed`.

2. **pcregrep** is the primary search utility due to its widespread
  portability. 

  If pcregrep is not available, GNU grep is used (for Perl RegEx & variable
  lookback). 


### Contributing & Todo
Contributions to improve simplicity/resolve compatibility would be preferred. If there are useful improvements, tricks, or hacks, please submit a Pull Request and a directory of add-ons and snippets will be created.

**TODO**

- [x] Add filename and line number to bulleted commit commets - [suggestion by
  joncalhoun](https://news.ycombinator.com/item?id=10904142) on HN 
- [ ] Use `git diff --cached --name-status --diff-filter=ACM` in place of `git
  ls-files`
- [ ] Develop more test cases (finding edge cases with grep expression)
- [ ] Rewrite sed commands to be POSIX (BSD) compatible regular expressions
- Create more robust regular expression for validating comment syntax
	- [ ] Check for multiline block comments
	- [ ] Check for closing comment symbols (positive look aheads)
- Programming Languages
	- [ ] HTML
	- [ ] Fortran
	- [ ] AppleScript

--

Special Thanks to Bryan Wyatt for feedback and bug fixes - [@brwyatt](https://twitter.com/brwyatt)
