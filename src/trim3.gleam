//// **Erlang target only** for now
////
//// ```
//// // Erlang unicode_util:whitespace() ==
//// //   [[13, 10], 9, 10, 11, 12, 13, 32, 133, 8206, 8207, 8232, 8233]
////
//// let strip_chars =
////   string.to_graphemes(" \t\n") |> list.map(string.to_utf_codepoints)
////
//// let trim = trim3.trim3(_, strip_chars)
//// assert trim("  foo \r\t\n") == "foo \r"
//// ```
////

@external(erlang, "string", "trim")
fn erl_trim3(a: String, b: Direction, c: anything) -> String

type UnsafeToProcess

@external(erlang, "stomp", "stomp_list")
fn stomp(a: anything) -> UnsafeToProcess

type Direction {
  Leading
  Trailing
  Both
}

@external(erlang, "stomp", "crlf")
fn crlf() -> grapheme

/// Semi-dangerous way to insert the CRLF grapheme in the characters list. It's
/// included as an alternative to the `string.to_graphemes` approach.
/// ```
/// let strip_chars = insert_crlf(string.to_utf_codepoints(" \t\n\r"))
/// let strip_chars =
///   string.to_graphemes("\r\n \t\n\r") |> list.map(string.to_utf_codepoints)
/// ```
/// are equivalent, with the caveat that the resulting list is in a state which
/// would most likely crash if you decide to do anything other than passing it
/// to trim3.
pub fn insert_crlf(list: List(UtfCodepoint)) {
  [crlf(), ..list]
}

/// Removes characters in `trim_charlist` on both sides of a `String`.
///
/// Alternative over `string.trim` which uses a built-in list.
///
/// trim_charlist is constructed like this
/// ```
/// let trim_charlist =
///   string.to_graphemes("\r\n \t\n\r") |> list.map(string.to_utf_codepoints)
/// ```
pub fn trim3(string: String, trim_charlist: anything) -> String {
  erl_trim3(string, Both, trim_charlist |> stomp)
}

/// Removes characters from `trim_charlist` at the end of a `String`.
pub fn trim3_end(string: String, trim_charlist: anything) -> String {
  erl_trim3(string, Trailing, trim_charlist |> stomp)
}

/// Removes characters from `trim_charlist` at the start of a `String`.
pub fn trim3_start(string: String, trim_charlist: anything) -> String {
  erl_trim3(string, Leading, trim_charlist |> stomp)
}
