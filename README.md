# containers

Constructs container by merging dockerfiles.

Simple. Will just use `Dockerfile.antlr3`:

```sh
make build/antlr3
make tag/antlr3
make push/antlr3
```

Complex. Merges `Dockerfile.antlr3` and `Dockerfile.documentation`:

```sh
make build/antlr3-documentation
make tag/antlr3-documentation
make push/antlr3-documentation
```
