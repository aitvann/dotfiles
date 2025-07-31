; extends

; fallback: LSP will override doc comment anyway
((line_comment
   doc: (doc_comment) @injection.content)
 (#set! injection.language "markdown")
 (#set! injection.include-children))


;; REGULAR QUERIES ;;

; regular string
((macro_invocation
   macro: [(scoped_identifier) (identifier)] @macro_name
   (token_tree
     (string_literal) @injection.content))
 (#match? @macro_name "^(sqlx::)?query(_scalar|_scalar_unchecked)?$")
 (#set! injection.language "sql")
 (#offset! @injection.content 0 1 0 -1)
 (#set! injection.include-children))

; short raw string
((macro_invocation
   macro: [(scoped_identifier) (identifier)] @macro_name
   (token_tree
     (raw_string_literal) @injection.content))
 (#match? @macro_name "^(sqlx::)?query(_scalar|_scalar_unchecked)?$")
 (#match? @injection.content "^r\".*")
 (#set! injection.language "sql")
 (#offset! @injection.content 0 2 0 -1)
 (#set! injection.include-children))

; full raw string
((macro_invocation
   macro: [(scoped_identifier) (identifier)] @macro_name
   (token_tree
     (raw_string_literal) @injection.content))
 (#match? @macro_name "^(sqlx::)?query(_scalar|_scalar_unchecked)?$")
 (#match? @injection.content "^r#\".*")
 (#set! injection.language "sql")
 (#offset! @injection.content 0 3 0 -2)
 (#set! injection.include-children))

;; *_as REGULAR QUERIES ;;

; regular string
((macro_invocation
   macro: [(scoped_identifier) (identifier)] @macro_name
   ; highlight only the second argument
   (token_tree
     ; allow anything as the first argument in case the user has lower case type
     ; names for some reason
     (_)
     (string_literal) @injection.content))
 (#match? @macro_name "^(sqlx::)?query_as(_unchecked)?$")
 (#set! injection.language "sql")
 (#offset! @injection.content 0 1 0 -1)
 (#set! injection.include-children))

; short raw string
((macro_invocation
   macro: [(scoped_identifier) (identifier)] @macro_name
   ; highlight only the second argument
   (token_tree
     ; allow anything as the first argument in case the user has lower case type
     ; names for some reason
     (_)
     (raw_string_literal) @injection.content))
 (#match? @macro_name "^(sqlx::)?query_as(_unchecked)?$")
 (#match? @injection.content "^r\".*")
 (#set! injection.language "sql")
 (#offset! @injection.content 0 2 0 -1)
 (#set! injection.include-children))

; full raw string
((macro_invocation
   macro: [(scoped_identifier) (identifier)] @macro_name
   ; highlight only the second argument
   (token_tree
     ; allow anything as the first argument in case the user has lower case type
     ; names for some reason
     (_)
     (raw_string_literal) @injection.content))
 (#match? @macro_name "^(sqlx::)?query_as(_unchecked)?$")
 (#match? @injection.content "^r#\".*")
 (#set! injection.language "sql")
 (#offset! @injection.content 0 3 0 -2)
 (#set! injection.include-children))
