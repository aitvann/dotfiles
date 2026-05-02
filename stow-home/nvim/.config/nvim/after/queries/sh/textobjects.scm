; extends

(string
  (string_content) @quoted.inner) @quoted.outer

(raw_string) @quoted.outer
((raw_string) @quoted.inner
  (#offset! @quoted.inner 0 1 0 -1))
