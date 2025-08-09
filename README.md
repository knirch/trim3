# trim3

[![Package Version](https://img.shields.io/hexpm/v/trim3)](https://hex.pm/packages/trim3)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/trim3/)

```sh
gleam add trim3
```
```gleam
import gleam/string
import gleam/list
import trim3

pub fn main() -> Nil {
  let strip_chars =
    string.to_graphemes(" \t\n") |> list.map(string.to_utf_codepoints)

  // let trim = trim3.trim3_start(_, strip_chars)
  // let trim = trim3.trim3_end(_, strip_chars)
  let trim = trim3.trim3(_, strip_chars)
  assert trim("  Silly\r\r\r   ") == "Silly\r\r\r"
}
```

Further documentation can be found at <https://hexdocs.pm/trim3>.

## Why?
I needed to trim many lines which only includes space, tab and line-feed. Gleam
string.trim (Erlang trim/1, trim/2) looks for 11 different characters and the
crlf pair. Cut time spent trimming lines in half. Not that I will ever ever
gain that back from doing this. Sunken cost!

And it should probably be a PR instead of a package. But hacks are afoot.
