Very basic benchmark between a few languages testing serialization and deserializatoin of a tree structure using s-exprs as a serialization format.

Serialize + deserialize use custom implementations in each language so that we're testing the language's performance & optimization characteristics
more than the actual serialize/deserialize implementations that ship with each language.

Note that this benchmark is meant to test "standard" code a normal user would write rather than hand optimized code. The definition of standard
is of course nebulous but it is meant to reflect what a reasonable first pass would look like.

## Source files

- Rust: `cargo run --release` (source file in `src/main.rs`)
  - 6.8s user, 7.187s total
- Ocaml: `ocamlopt -o tree_ml tree.ml`
  - 47.99s user, 52.85s total
- Lobster: `lobster tree.lobster` (unable to test `--cpp` flag: it appears to be output windows-specific project files only)
  - 138.94s user, 2:19 total
