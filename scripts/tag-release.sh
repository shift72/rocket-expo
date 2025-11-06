# Creates a stable build by:
# Check clean
# Bump version
# Tag release
# Push to main

RED='\033[0;31m'
NC='\033[0m' # No Color

fatal_error()
{
  echo "${RED}$@${NC}" >&2
  exit 1
}

on_failure()
{
  if [ $? -gt 0 ] ; then
    fatal_error $@
  fi
}

# get and verify params
LEVEL=`echo $1 | tr '[:upper:]' '[:lower:]'`
if [ "$LEVEL" != "major" ] && [ "$LEVEL" != "minor" ] && [ "$LEVEL" != "patch" ] ; then
  echo "Usage: $0 [major|minor|patch]"
  exit 1
fi

# confirm git clean
STATUS_OUTPUT=`git status --porcelain | tr -cd '[:print:]'`
if [ $? -gt 0 ] || [ -n "$STATUS_OUTPUT" ] ; then
  fatal_error "Uncommitted changes, aborting"
fi

# fetch before checking branch state
git fetch > /dev/null
on_failure "Failed to fetch"

# checkout main
git checkout main > /dev/null
on_failure "Failed to checkout main"

# pull main
main_MY_COMMITS=`git rev-list origin/main..main`
if [ -n "$main_MY_COMMITS" ] ; then
  fatal_error "Unpushed changes on main, aborting"
fi
main_THEIR_COMMITS=`git rev-list main..origin/main`
if [ -n "$main_THEIR_COMMITS" ] ; then
  git merge
  on_failure "Failed to merge main commits from remote"
fi

# merge main into stable
git merge main > /dev/null
on_failure "Failed to merge main into stable"

# bump version, update changelog
BUMP_OUT=`ruby ./scripts/version-bumper.rb $LEVEL`
on_failure "Failed to bump version"

# commit version change
git add ./package.json
git commit -m "Tag release v$BUMP_OUT" > /dev/null
on_failure "Failed to commit version bump"

# tag current as v(build version)
git tag "v$BUMP_OUT" > /dev/null
on_failure "Failed to tag version"

# push
git push origin main --tags
on_failure "Failed to push main"