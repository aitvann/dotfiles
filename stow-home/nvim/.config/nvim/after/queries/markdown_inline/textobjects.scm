; extends

(emphasis) @emphasis.outer
((emphasis) @emphasis.inner
    (#offset! @emphasis.inner 0 1 0 -1))

(strong_emphasis) @strong_emphasis.outer
((strong_emphasis) @strong_emphasis.inner
    (#offset! @strong_emphasis.inner 0 2 0 -2))
