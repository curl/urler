trurl release procedure - how to do a release
==============================================

in the source code repo
-----------------------

- edit `RELEASE-NOTES` to be accurate

- run `./scripts/mkrelease [version]`

- make sure all relevant changes are committed on the master branch

- tag the git repo in this style: `git tag -a trurl-[version]` -a annotates
  the tag

- push the git commits and the new tag

- Go to https://github.com/curl/trurl/tags and edit the tag as a release
  Consider allowing it to make a discussion post about it.

celebrate
---------

- suitable beverage intake is encouraged for the festivities
