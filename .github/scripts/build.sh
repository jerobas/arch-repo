#!/bin/bash
set -e
build_path="$1"
output_path="$GITHUB_WORKSPACE/dist"
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

