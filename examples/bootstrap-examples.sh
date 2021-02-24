ROOT_FOLDER_PATH=$(echo "$PWD" | sed "s/\/examples//g")
echo $ROOT_FOLDER_PATH

for d in */; do
  if [[ -d "$d" && ! -L "$d" ]]; then
    # TO DELETE
#    [ $d == "aurelia-kitchen-sink/" ] && exit

    echo "--- 🚀 Starting bootstrap for $d ---"
    cd $d || exit

    # Create yarn.lock if it doesn't exist
    [ ! -f yarn.lock ] && touch yarn.lock

    # Init Yarn config if `.yarnrc.yml` doesn't exist
    if [[ ! -f .yarnrc.yml ]]; then
      echo "$d: It looks like Yarn 2 has never been configured, will do it right now"
      yarn config set nodeLinker node-modules
      yarn config set enableGlobalCache true
    fi

    echo "🎛 Setup 'resolutions' field"
    yarn link ../../storybook --all
    sed -i.bak "s|$ROOT_FOLDER_PATH|../..|g" package.json && rm package.json.bak

    echo "📡 Running 'yarn install'"
    yarn

    echo "--- ✅  Everything worked fine for $d ---"
    cd ..
  fi
done
