// pandoc template for Quarto + Typst
// 注意: pandocテンプレート構文 (else節) は使用不可

// ---- シンタックスハイライト定義 (Skylighting) ----
$if(highlighting-definitions)$
$highlighting-definitions$

// Skylighting関数を上書き: 改行・スタイル・インデント表示を修正
#let Skylighting(fill: none, number: false, start: 1, sourcelines) = block(
  fill: luma(248),
  width: 100%,
  inset: (x: 14pt, y: 10pt),
  radius: 4pt,
  stroke: 0.5pt + luma(215),
)[
  #set text(font: ($if(monofont)$"$monofont$", $endif$"Consolas", "Courier New"), size: 9pt)
  #set par(leading: 0.6em, spacing: 0em, justify: false)
  #show raw.where(block: false): it => it
  #sourcelines.join(linebreak())
]
$endif$

// ---- ページ設定 ----
#set page(
  paper: "a4",
  margin: (top: 25mm, bottom: 25mm, left: 25mm, right: 20mm),
  numbering: "1",
  header: context {
    if counter(page).get().first() > 1 {
      set text(size: 8.5pt, fill: luma(140))
$if(title)$
      h(1fr)
$if(docnumber)$
      [$docnumber$]
$endif$
      h(1em)
      counter(page).display("1 / 1", both: true)
$endif$
      v(-4pt)
      line(length: 100%, stroke: 0.5pt + luma(210))
    }
  },
  footer: none,
)

// ---- テキスト・フォント設定 ----
#set text(
  font: ($if(mainfont)$"$mainfont$", $endif$"Meiryo", "Yu Gothic", "Arial"),
  size: $if(fontsize)$$fontsize$$endif$,
  lang: "$if(lang)$$lang$$endif$",
)

// ---- パラグラフ設定 ----
#set par(
  leading: 0.8em,
  spacing: 1.1em,
  justify: true,
  first-line-indent: 1em,
)

// ---- 見出しスタイル ----
// section-numbering はQuartoがメタデータとして渡す
$if(section-numbering)$
#set heading(numbering: "$section-numbering$")
$endif$

#show heading: it => {
  // 見出しが変わるたびに図・表のカウンタをリセット
  counter(figure.where(kind: table)).update(0)
  counter(figure.where(kind: image)).update(0)
  block(above: 1.6em, below: 0.5em)[
    #set text(size: 10.5pt, weight: "bold")
    #it
  ]
  par(text(size: 0.001em, h(0em)))
}

// ---- 図表番号を「節番号-連番」形式（全レベル対応）----
#set figure(numbering: (..nums) => context {
  let h = counter(heading).get()
  // 末尾の 0 を除去して現在の深さだけ使う
  let i = h.len()
  while i > 0 and h.at(i - 1) == 0 {
    i -= 1
  }
  let prefix = h.slice(0, i).map(str).join(".")
  prefix + "-" + str(nums.pos().first())
})

// ---- コードブロックスタイル (Skylightingなしの場合) ----
#show raw.where(block: true): it => block(
  fill: luma(248),
  inset: (x: 14pt, y: 10pt),
  radius: 4pt,
  width: 100%,
  stroke: 0.5pt + luma(215),
)[
  #set text(font: ($if(monofont)$"$monofont$", $endif$"Consolas", "Courier New"), size: 9pt)
  #set par(leading: 0.6em, spacing: 0em, justify: false)
  #it
]

// ---- インラインコードスタイル ----
// ボックスはSkylight内トークンに干渉するためフォント設定のみ
#show raw.where(block: false): set text(font: ($if(monofont)$"$monofont$", $endif$"Consolas", "Courier New"), size: 9.5pt)

// ---- テーブルスタイル ----
#set table(
  inset: (x: 8pt, y: 6pt),
  stroke: 0.5pt + luma(200),
)
#show table.cell.where(y: 0): set text(weight: "bold")
#show table.cell.where(y: 0): set block(fill: luma(220))

// ---- リスト設定 ----
#set list(indent: 1em, body-indent: 0.6em)
#set enum(indent: 1em, body-indent: 0.6em)

// ---- その他 ----
#show terms: it => {
  it.children.map(child => [
    #strong[#child.term]
    #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
  ]).join()
}

$for(header-includes)$
$header-includes$
$endfor$

// ============================================================
// タイトルページ
// ============================================================
$if(title)$
#align(center + horizon)[
  #set text(size: 26pt, weight: "bold", fill: rgb("#1e293b"))
  $title$
  #v(6mm)
  #line(length: 50%, stroke: 2.5pt + rgb("#1d4ed8"))
  #v(10mm)
$if(author)$
  #set text(size: 12pt, weight: "regular", fill: luma(80))
  $for(author)$$author$$sep$ · $endfor$
  #v(3mm)
$endif$
$if(date)$
  #set text(size: 11pt, weight: "bold", fill: luma(100))
  $date$
$endif$
]
#pagebreak()
$endif$

// ============================================================
// 本文
// ============================================================
$for(include-before)$
$include-before$
$endfor$

$if(toc)$
#outline(title: auto, depth: $toc-depth$)
#pagebreak()
$endif$

$body$

$for(include-after)$
$include-after$
$endfor$
