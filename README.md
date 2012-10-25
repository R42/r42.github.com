This is the source of my the website http://r42.in/. The only interesting branch in this repo will be the fork-me branch as GitHub expects the generated website to live in master.

Steps to publish:

* Fork the [repository](https://github.com/R42/r42.github.com)
* Make changes in the _fork-me_ branch
* Build and test the site locally
* Pull request your changes :)

* After each change to the branch something magic happens and the static files of the _master_ branch change.

	The magic is in these commands:
	```
git update-ref refs/heads/master $(echo 'Add commit message here!' | git commit-tree fork-me^{tree}:_site -p $(cat .git/refs/heads/master))
git push
	```
	