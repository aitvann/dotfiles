# NeoVim Config

This is my NeoVim config

## Pairs Playground

### Rust

``` rust
fn foo<'a>() -> Vec<i32> {
    let _char = 'a';

    if 3 < 6 {
        let flag = libc::O_CREAT | libc::O_TRUNC | libc::O_APPEND;
        [flag].map(|x| x * 2).into_iter().collect::<Vec<_>>()
    } else {
        panic!(r#"unreachable"#);

    }
}
```
