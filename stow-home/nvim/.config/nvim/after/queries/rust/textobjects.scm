; extends

(raw_string_literal
  (string_content) @quoted.inner) @quoted.outer

(string_literal
  (string_content) @quoted.inner) @quoted.outer

(char_literal) @quoted.outer
((char_literal) @quoted.inner
  (#offset! @quoted.inner 0 1 0 -1))
