#!/usr/bin/env bash
# Build a LaTeX project to PDF. Copies palette + macros beside the source
# so the folder still compiles later. Prefers latexmk, then tectonic, then npx.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ASSET_DIR="$SCRIPT_DIR/../assets"

ROOT="${1:-.}"
if [[ -f "$ROOT" && "$ROOT" == *.tex ]]; then
  TEX_FILE="$(cd "$(dirname "$ROOT")" && pwd)/$(basename "$ROOT")"
  ROOT="$(dirname "$TEX_FILE")"
else
  ROOT="$(cd "$ROOT" && pwd)"
  if [[ -f "$ROOT/main.tex" ]]; then
    TEX_FILE="$ROOT/main.tex"
  else
    TEX_FILE="$(find "$ROOT" -maxdepth 1 -name '*.tex' ! -name 'packages.tex' ! -name 'palette.tex' ! -name 'macros.tex' | sort | head -1)"
    if [[ -z "$TEX_FILE" ]]; then
      echo "error: pass a .tex file or a directory containing main.tex" >&2
      exit 1
    fi
  fi
fi

for asset in packages.tex palette.tex macros.tex; do
  if [[ ! -f "$ASSET_DIR/$asset" ]]; then
    echo "error: missing $ASSET_DIR/$asset" >&2
    exit 1
  fi
  cp "$ASSET_DIR/$asset" "$ROOT/$asset"
done

BASE="$(basename "$TEX_FILE" .tex)"
PDF="$ROOT/${BASE}.pdf"

# MacTeX / TeX Live often install outside default PATH
export PATH="/Library/TeX/texbin:/usr/local/texlive/2026/bin/universal-darwin:/usr/local/texlive/2025/bin/universal-darwin:${PATH:-}"

run_latexmk() {
  command -v latexmk >/dev/null 2>&1 || return 1
  echo "engine: latexmk"
  (cd "$ROOT" && latexmk -pdf -interaction=nonstopmode -halt-on-error "$TEX_FILE")
}

run_tectonic() {
  command -v tectonic >/dev/null 2>&1 || return 1
  echo "engine: tectonic"
  (cd "$ROOT" && tectonic "$TEX_FILE")
}

run_platex() {
  command -v npx >/dev/null 2>&1 || return 1
  echo "engine: npx @nandan-varma/platex"
  (cd "$ROOT" && npx --yes @nandan-varma/platex "$TEX_FILE")
}

if run_latexmk || run_tectonic || run_platex; then
  if [[ -f "$PDF" ]]; then
    BYTES="$(wc -c < "$PDF" | tr -d ' ')"
    echo "ok: $PDF ($BYTES bytes)"
    exit 0
  fi
  echo "error: compile finished but $PDF not found" >&2
  exit 1
fi

echo "error: no LaTeX engine found. Install one of:" >&2
echo "  brew install --cask mactex-no-gui   # then: export PATH=\"/Library/TeX/texbin:\$PATH\"" >&2
echo "  brew install tectonic" >&2
echo "  npx @nandan-varma/platex <file.tex>" >&2
exit 1
