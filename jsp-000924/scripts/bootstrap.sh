#!/bin/sh
# Install the pinned local Lean stack on Apple Silicon macOS.
set -eu

jsp_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$jsp_root"

if [ "$(uname -s)" != "Darwin" ] || [ "$(uname -m)" != "arm64" ]; then
  printf '%s\n' 'bootstrap.sh supports arm64 macOS only.' >&2
  exit 2
fi

for jsp_command in curl tar shasum git grep; do
  if ! command -v "$jsp_command" >/dev/null 2>&1; then
    printf 'Required command is unavailable: %s\n' "$jsp_command" >&2
    exit 2
  fi
done

jsp_toolchain='leanprover/lean4:v4.33.1'
jsp_elan_version='4.2.4'
jsp_archive_sha='7ad829861392c718dfebde3a83b5c8508df47be02af68894b094b0b3952616e5'
jsp_archive="$jsp_root/.tools/downloads/elan-aarch64-apple-darwin.tar.gz"
jsp_archive_url='https://github.com/leanprover/elan/releases/download/v4.2.4/elan-aarch64-apple-darwin.tar.gz'

if [ ! -f lake-manifest.json ]; then
  printf '%s\n' 'The committed lake-manifest.json is required; restore it before bootstrapping.' >&2
  exit 2
fi
if [ "$(cat lean-toolchain)" != "$jsp_toolchain" ]; then
  printf '%s\n' 'lean-toolchain does not match the pinned bootstrap version.' >&2
  exit 2
fi
jsp_manifest_before=$(shasum -a 256 lake-manifest.json)

export ELAN_HOME="$jsp_root/.tools/elan"
export PATH="$ELAN_HOME/bin:$PATH"
mkdir -p "$jsp_root/.tools/downloads"

jsp_need_elan=true
if [ -x "$ELAN_HOME/bin/elan" ]; then
  case "$("$ELAN_HOME/bin/elan" --version)" in
    "elan $jsp_elan_version "*|"elan $jsp_elan_version") jsp_need_elan=false ;;
  esac
fi

if [ "$jsp_need_elan" = true ]; then
  if [ ! -f "$jsp_archive" ]; then
    curl --fail --location --retry 3 --output "$jsp_archive.part" "$jsp_archive_url"
    mv "$jsp_archive.part" "$jsp_archive"
  fi
fi

# Verify any cached installer before it can be extracted or executed.
if [ -f "$jsp_archive" ]; then
  printf '%s  %s\n' "$jsp_archive_sha" ".tools/downloads/elan-aarch64-apple-darwin.tar.gz" | shasum -a 256 -c -
fi

if [ "$jsp_need_elan" = true ]; then
  jsp_extract="$jsp_root/.tools/downloads/elan-v$jsp_elan_version-aarch64-apple-darwin"
  mkdir -p "$jsp_extract"
  tar -xzf "$jsp_archive" -C "$jsp_extract"
  "$jsp_extract/elan-init" -y --no-modify-path --default-toolchain none
fi

if ! elan toolchain list | grep -Eq '^leanprover/lean4:v4\.33\.1([[:space:]]|$)'; then
  elan toolchain install "$jsp_toolchain"
fi

elan --version
lean --version
lake --version

# Lake resolves the existing lockfile; no default dependency update is performed.
lake exe cache get
lake --wfail build JSP924.EnvironmentCheck

if [ "$(shasum -a 256 lake-manifest.json)" != "$jsp_manifest_before" ]; then
  printf '%s\n' 'Dependency setup changed lake-manifest.json; inspect the change before verifying.' >&2
  exit 1
fi

printf '%s\n' 'Pinned local Lean stack is ready.' 'From the project root, run: . scripts/env.sh'
