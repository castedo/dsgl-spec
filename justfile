baseprint:
  python3 -m baseprinter --defaults pandocin.yaml --baseprint baseprint --outdir _preview

baseprint-fast:
  python3 -m baseprinter --defaults pandocin.yaml --baseprint baseprint --outdir _preview --skip-pdf
