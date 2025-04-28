<div align="center">

# asdf-berglas [![Build](https://github.com/ivank/asdf-berglas/actions/workflows/build.yml/badge.svg)](https://github.com/ivank/asdf-berglas/actions/workflows/build.yml) [![Lint](https://github.com/ivank/asdf-berglas/actions/workflows/lint.yml/badge.svg)](https://github.com/ivank/asdf-berglas/actions/workflows/lint.yml)

[berglas](https://github.com/GoogleCloudPlatform/berglas) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add berglas
# or
asdf plugin add berglas https://github.com/ivank/asdf-berglas.git
```

berglas:

```shell
# Show all installable versions
asdf list-all berglas

# Install specific version
asdf install berglas latest

# Set a version globally (on your ~/.tool-versions file)
asdf global berglas latest

# Now berglas commands are available
berglas --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/ivank/asdf-berglas/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Ivan Kerin](https://github.com/ivank/)
