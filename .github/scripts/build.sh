#!/bin/bash
set -e
build_path="$1"
caller_repo="$2"
output_path="/tmp/dist"

git clone "https://github.com/$caller_repo" repo
cd repo

mkdir -p "$output_path"

for dir in $build_path/*; do
  [[ -d "$dir" ]] || continue

  name=$(basename "$dir")
  for file in $build_path/*; do
    [[ -f "$file" ]] || continue
    cp "$file" "$dir" 2>/dev/null || true
  done

  pushd "$dir"

  if [[ -f target ]]; then
    target=$(cat target)
  else
    if grep -q '^pkgname=.*-bin' PKGBUILD; then
      target="repo"
    else
      target="aur"
    fi
  fi

  deps=$(source PKGBUILD && echo "${depends[@]}")
  sudo pacman -S --noconfirm --asdeps ${deps}

  case "$target" in
    aur)
      makepkg --source --noconfirm
      cp *.tar.gz "$output_path"
      ;;
    repo)
      makepkg -f --noconfirm
      cp *.pkg.tar.zst "$output_path"
      ;;
    both)
      makepkg -f --noconfirm
      cp *.pkg.tar.zst "$output_path"
      makepkg --source --noconfirm
      cp *.tar.gz "$output_path"
      ;;
    *)
      echo "❌ Unknown target: $target"
      exit 1
      ;;
  esac

  popd
done

