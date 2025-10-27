# containers

Repository of useful dockerfiles.

## Build & Tag & Push

For `Dockerfile.antlr3`:

```sh
make build/antlr3
make tag/antlr3
make push/antlr3
```

From multiple dockerfiles. Works by longest substring substitution and `Dockerfile` merging.

For `Dockerfile.antlr3` and `Dockerfile.documentation`:

```sh
make build/antlr3-documentation
make tag/antlr3-documentation
make push/antlr3-documentation
```

> See `docker.sh` for details.
