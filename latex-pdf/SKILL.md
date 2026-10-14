---
name: latex-pdf
description: >
  Generate a print-ready PDF with LaTeX. The color palette follows the
  document kind: review (client check), release (app release sheet),
  finance (invoice or statement), update (work update), plan (internal
  spec), or brief (anything else). Use when the user asks for a PDF, a
  LaTeX document, a client handout, a one-pager, or when another skill
  needs a PDF built — including DineBD review rounds.
---

# LaTeX PDF

Build one self-contained PDF. Colors come from the document kind, not from
whatever the last PDF used. Layout macros and the build script live in this
skill; the calling skill owns the words.

Paths below are relative to this skill folder unless they start with `docs/`.

## Pick the kind first

Read [references/palettes.md](references/palettes.md) and set exactly one:

| Kind | Use when the document is |
|---|---|
| `review` | A client review round (DineBD orange, same as rounds already sent) |
| `release` | An app release sheet |
| `finance` | An invoice, statement, or balance |
| `update` | A daily work update or status note |
| `plan` | An internal spec or plan |
| `brief` | None of the above |

If a calling skill names the kind, use that and do not reconsider it.

## Write the source

```
- [ ] 1. Copy assets/article.tex to the output folder
- [ ] 2. Set \pdfkind
- [ ] 3. Write the body
- [ ] 4. Build
- [ ] 5. Check pages
- [ ] 6. Delete build junk
```

1. Copy [assets/article.tex](assets/article.tex) to the destination, named for
   the document (`docs/<area>/<name>.tex`). Keep it next to its images.
2. Change `\def\pdfkind{brief}` to the kind from the table. That one word
   selects every color. Do not add `\definecolor` in the document.
3. Fill title, date, and sections. Put images in `shots/`, `figures/`, or
   `images/` beside the tex file.

   Macros (defined in `assets/macros.tex`, copied in at build time):

   - `\docitem{title}{meta}` — numbered item, accent number, muted meta line
   - `\withphone{file}{caption}{text}` — portrait figure beside the text
   - `\withvideo{frame}{caption}{url}{text}` — same, plus a button in accent
     with on-accent label
   - `\wide{file}{caption}` — full-width figure
   - `\colorrule` — hairline in the kind's rule color

   Two portraits: one `figure` with two `subfigure`s at `height=6.6cm`.
   A calling skill may add its own commands (`\reviewitem`, and so on) on
   top of these. Those commands use `accent` and `muted`, never a raw hex.

Voice belongs to the calling skill. With no calling skill: short sentences,
active voice, no emoji, one idea per bullet. Write for the person who will
hold the PDF.

## Build

```bash
scripts/build-pdf.sh path/to/document.tex
```

Run it outside any sandbox. The script copies `packages.tex`, `palette.tex`,
and `macros.tex` beside the source, then runs latexmk, tectonic, or
`npx @nandan-varma/platex`. Those three files are part of the document after
that — leave them next to the tex so the folder rebuilds without this skill.

Needs a TeX install. If none is found, the script prints the install line.

## Check pages

```bash
pdftoppm -r 40 -png path/to/document.pdf /tmp/pdfpage
```

Look at every page. Tall figures leave half-empty pages — shrink the figure
or move it, then rebuild. Confirm the accent matches the kind (orange for
`review`, green for `finance`, blue for `update`, and so on). An unknown
kind compiles as `brief` and warns in the log; fix the kind instead of
keeping the fallback.

Delete `.aux .log .fls .fdb_latexmk .out` and the preview pngs. Do not commit
unless the user asks.
