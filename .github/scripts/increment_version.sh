PUBSPEC="../../pubspec.yaml"

VERSION_RAW=$(grep version: $PUBSPEC)
VERSION=$(echo "$VERSION_RAW" | cut -d " " -f 2)

MAJOR=$(echo "$VERSION" | cut -d "." -f 1)
MINOR=$(echo "$VERSION" | cut -d "." -f 2)
PATCH_AND_BUILD=$(echo "$VERSION" | cut -d "." -f 3)
PATCH=$(echo "$PATCH_AND_BUILD" | cut -d "+" -f 1)
BUILD=$(echo "$PATCH_AND_BUILD" | cut -d "+" -f 2)


if [ "$HAS_BREAKING_LABEL" = true ] ; then
  MAJOR=$($MAJOR + 1)
fi
if [ "$HAS_FEATURE_LABEL" = true ] ; then
  MINOR=$($MINOR + 1)
fi
if [ "$HAS_BUG_FIX_LABEL" = true ] ; then
  PATCH=$($PATCH + 1)
fi


echo "$MAJOR"
echo "$MINOR"
echo "$PATCH"
echo "$BUILD"

NEW_VERSION=$MAJOR.$MINOR.$PATCH+$BUILD

if [ "$VERSION" != "$NEW_VERSION" ]; then
  # Mac OS: sed -i '' -e "s/$VERSION_RAW/version: $NEW_VERSION/g" $PUBSPEC
  sed -i -e "s/$VERSION_RAW/version: $NEW_VERSION/g" $PUBSPEC
  git config user.name github-actions
  git config user.email github-actions@github.com
  git add .
  git commit -m "Increment Version to $NEW_VERSION"
  git push
fi