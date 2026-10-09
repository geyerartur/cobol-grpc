# Contributing to cobol-grpc

Thank you for your interest in contributing to `cobol-grpc`.

The project aims to implement a gRPC client in COBOL. It is experimental, and protocol coverage and public interfaces may change significantly during development.

## Before contributing

Please read the project README and check the current roadmap.

For substantial changes, consider opening an issue first to discuss the proposed design. This is particularly useful for protocol features, public API changes, and new external dependencies.

Small fixes, documentation improvements, and focused tests generally do not require prior discussion.

## Development environment

The initial development environment requires:

* GnuCOBOL
* GNU Make
* Git
* A POSIX-compatible shell for the development scripts

Additional dependencies may be introduced as networking, transport, and interoperability features are implemented.

Build the project using:

```bash
cmake -S . -B build
```
and

```bash
cmake --build build
```

Run the available checks using the targets documented in the CMakeLists file. Build and test instructions will evolve as the implementation develops.

## Code contributions

Please follow these guidelines:

* Keep changes focused and reasonably small.
* Add tests for new functionality and bug fixes.
* Document protocol limitations and unsupported features.
* Validate malformed input and error paths, not just successful requests.
* Document new external dependencies and their purpose.
* Avoid claiming protocol support without corresponding tests.
* Update relevant documentation when changing public interfaces or supported behaviour.

Protocol implementations should be tested against the applicable specifications and, where practical, independently implemented gRPC services.

## Commit messages

This project follows [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/).

Use the format:

```text
type(scope): description
```

The scope is optional. Breaking changes may be marked with `!`.

Examples:

```text
feat(protobuf): implement varint decoding
fix(transport): reject truncated frames
test(protobuf): cover malformed field encodings
docs: clarify current protocol limitations
build: add shared library target
```

Use the commit body to explain the motivation or important implementation details when necessary.

## Pull requests

Pull requests should explain:

* What changed and why.
* How the change was tested.
* Any limitations or compatibility considerations.
* Any relevant issues.

Please keep unrelated changes out of the same pull request where practical.

## License

By contributing, you agree that your contributions will be licensed under the project's MIT License.

Thank you for helping make COBOL communicate with the modern RPC ecosystem!
