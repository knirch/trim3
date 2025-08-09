import gleam/list
import gleam/string
import gleeunit
import trim3.{insert_crlf, trim3, trim3_end, trim3_start}

// @external(erlang, "unicode_util", "whitespace")
// fn erlws() -> something

// erlws() == [[13,10],9,10,11,12,13,32,133,8206,8207,8232,8233]

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn basic_test() {
  let trim_charlist = string.to_utf_codepoints(" \t\n")
  assert trim3(" foo ", trim_charlist) == "foo"
  assert trim3_start(" foo ", trim_charlist) == "foo "
  assert trim3_end(" foo ", trim_charlist) == " foo"
  assert trim3_end(" foo\r ", trim_charlist) == " foo\r"
  assert trim3_end(" foo \r", trim_charlist) == " foo \r"
}

pub fn upstream_grapheme_test() {
  let test_string = "  test \r\n  \n\t    \n"

  // Individual graphemes; space, tab, cr and lf
  let charlist = string.to_utf_codepoints(" \t\r\n")

  // Unicode specifies \r\n as one grapheme, and as the list of characters
  // doesn't include the crlf grapheme, but the individual ones, crlf should
  // remain in the output.

  // Unless upstream changed.
  assert trim3(test_string, charlist) == "test \r\n"
}

pub fn crlf_insert_test() {
  let test_string = "  test \r\n  \n\t    \n"

  let charlist_with_crlf = insert_crlf(string.to_utf_codepoints(" \t\n"))
  assert trim3(test_string, charlist_with_crlf) == "test"
}

pub fn samesame_test() {
  let whitespace =
    "\r\n \t\n\u{000b}\f\r\u{0085}\u{200e}\u{200f}\u{2028}\u{2029}"

  // flip it for fun and profit
  let test_string =
    whitespace
    <> "foo"
    |> string.to_graphemes
    |> list.reverse
    |> string.join("")

  let erlang_whitespace =
    string.to_graphemes(whitespace)
    |> list.map(string.to_utf_codepoints)

  assert string.trim(whitespace <> "foo") == "foo"
  assert trim3(whitespace <> "foo", erlang_whitespace) == "foo"
  assert string.trim(test_string) == "oof"
  assert trim3(test_string, erlang_whitespace) == "oof"
}

pub fn upstream_test() {
  assert string.trim("  foo  \n \r") == "foo"
  assert string.trim("  foo  \r\n") == "foo"
  assert string.trim("  foo  \n") == "foo"
}

pub fn correctness_test() {
  let ws =
    string.to_graphemes("\n\r")
    |> list.map(string.to_utf_codepoints)
  assert trim3("foo\r\n", ws) == "foo\r\n"
  assert trim3("foo\r\n\n\r", ws) == "foo\r\n"
}
