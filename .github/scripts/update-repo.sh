#!/bin/bash
set -e

echo "🚀 Running Arch container to update repo..."
docker run --rm \
  -v "$PWD/repo:/repo" \
  -v "$PWD/pkg:/pkg" \
  archlinux bash -c "
    set -e
    pacman -Sy --noconfirm pacman-contrib >/dev/null

    cd /repo/x86_64

    for file in /pkg/*.pkg.tar.zst; do
      pkgfile=\$(basename \"\$file\")
      nameverarch=\${pkgfile%.pkg.tar.zst}
      pkgname=\$(echo \"\$nameverarch\" | sed -E 's/-[0-9]+(\.[0-9]+)*-[0-9]+-[^-]+$//')

      echo \"🔎 Removing previous versions of \$pkgname from DB...\"
      repo-remove jerobas.db.tar.gz \"\$pkgname\" || true

      echo \"📦 Copying \$pkgfile into repository...\"
      cp \"\$file\" .
    done

    echo \"📚 Rebuilding repo database...\"
    repo-add jerobas.db.tar.gz *.pkg.tar.zst
  "
