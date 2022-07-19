# Wesnoth Image Optimizer

A GitHub Action for [Wesnoth](https://www.wesnoth.org/) add-ons.
Verifies project resources using the `wmlscope` tool from a partially
cloned [Wesnoth repository](https://github.com/wesnoth/wesnoth).

## Usage

Create a `.github/workflows` folder in your GitHub repository.
Add a workflow that triggers this action. For more info, see
the following examples of GitHub workflows.

The Wesnoth version that the resources are checked against can
be specified with the `wesnoth-version` parameter. It can match
any Wesnoth [branch](https://github.com/wesnoth/wesnoth/branches)
or [tag](https://github.com/wesnoth/wesnoth/tags).

The folder or file that should be validated can be specified with
the `path` parameter. By default, the entire project will be verified.

Command line flags passed to the `wmlscope` tool can be specified
with the `flags` parameter. By default, the `-u` flag is passed,
so that unresolved macro references and other issues within WML files
are reported. When overriding the default value, consider adding `-u`
for a in-depth issues report. See the `wmlscope` documentation for
a complete list of supported flags.

### Examples

A workflow that verifies resources on every push to the repository,
as well as every pull request:

```yaml
name: check

on: [push, pull_request]

jobs:
  check:
    runs-on: ubuntu-latest

    steps:
    - name: Repository checkout
      uses: actions/checkout@v2
    - name: Verify resources scope
      uses: czyzby/wesnoth-wml-scope@v1
```


A workflow that verifies resources in the `units/` folder against
Wesnoth 1.16 `wmlscope` with custom flags on every push or pull
request to a specific branch:

```yaml
name: check

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  check:
    runs-on: ubuntu-latest

    steps:
    - name: Repository checkout
      uses: actions/checkout@v2
    - name: Verify resources scope
      uses: czyzby/wesnoth-wml-scope@v1
      with:
        path: units/
        wesnoth-version: 1.16
        flags: --unchecked
```

## Notes

Use `@v1` for the latest stable release. Use `@latest` for the latest
version directly from the default development branch.

### See also

* [`czyzby/wesnoth-wml-linter`](https://github.com/czyzby/wesnoth-wml-linter):
a GitHub Action that verifies WML files with `wmllint` and `wmlindent`.
* [`czyzby/wesnoth-png-optimizer`](https://github.com/czyzby/wesnoth-png-optimizer):
a GitHub Action that verifies if PNG images are optimized with `woptipng`.
