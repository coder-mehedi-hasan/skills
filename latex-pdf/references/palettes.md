# Palettes

Set `\def\pdfkind{...}` before `\input{palette.tex}`. One kind per document.
Do not mix kinds, and do not invent hex values in the document.

| Kind | Document | Accent | On accent | Muted | Link | Rule |
|---|---|---|---|---|---|---|
| `review` | Client review round. Asks someone to check finished work. | `#F07A1F` | `#FFFFFF` | `#5C534C` | `#1F4E79` | `#F6D7BE` |
| `release` | App release sheet or store-note summary. | `#C2410C` | `#FFFFFF` | `#57534E` | `#9A3412` | `#FED7AA` |
| `finance` | Invoice, statement, balance, anything about money. | `#0F6E56` | `#FFFFFF` | `#3F4F4A` | `#0F6E56` | `#C6E4D8` |
| `update` | Daily work update, status note, standup leave-behind. | `#1D4E89` | `#FFFFFF` | `#4A5562` | `#1D4E89` | `#D3DDEA` |
| `plan` | Internal spec or plan. | `#3F3F46` | `#FFFFFF` | `#52525B` | `#1E3A5F` | `#E4E4E7` |
| `brief` | Anything else. | `#111827` | `#FFFFFF` | `#4B5563` | `#1D4ED8` | `#E5E7EB` |

`review` uses a warm orange so a checklist is easy to tell apart from a
finance sheet (green) or a status note (blue).

## How the colors are used

- **Accent** — section titles, item numbers, video button fill.
- **On accent** — text on the accent fill (the video button).
- **Muted** — the small line under an item title.
- **Link** — URLs and in-document links.
- **Rule** — `\colorrule` under the title, and any hairline you add.

Body text stays black. An unknown kind falls back to `brief` and prints a warning.
