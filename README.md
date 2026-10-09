# cobol-grpc

An experimental gRPC client written in COBOL, exploring Protocol Buffers and gRPC over HTTP/2 without a foreign-language implementation.

---


cobol-grpc aims to implement a gRPC client in COBOL, with the goal of communicating with standard gRPC services without delegating the client implementation to another programming language.


## Project status

**Early development -- not production-ready.**

The implementation is a work in progress. Protocol coverage, interoperability, build instructions, and supported platforms will be documented as they are established.

## Goals

* **COBOL-first implementation.** Keep the protocol implementation in COBOL rather than hiding it behind a C, C++, or other foreign-language wrapper.
* **Protocol Buffers.** Encode and decode messages according to `.proto` schema definitions.
* **gRPC over HTTP/2.** Implement the transport and message-handling requirements needed to communicate with standard gRPC services.
* **Interoperability.** Test against independently implemented gRPC servers and clients.
* **Incremental development.** Begin with a small, well-defined subset of the protocol and expand it as conformance improves.
* **Transparency.** Document implementation limitations, external dependencies, and unsupported features.

The project prioritizes correctness, understandable protocol handling, and interoperability over premature feature completeness.

## Planned roadmap

The following is a development plan, not a claim that these features are already implemented.

* [ ] Define the project structure and supported COBOL runtime.
* [ ] Implement Protocol Buffers serialization and deserialization for an initial supported subset.
* [ ] Implement gRPC message framing.
* [ ] Implement the HTTP/2 functionality required for basic RPC calls, including HPACK header compression.
* [ ] Complete a unary RPC against an independently implemented gRPC server.
* [ ] Handle gRPC status codes, response trailers, metadata, and deadlines.
* [ ] Add TLS support with proper certificate verification.
* [ ] Expand interoperability and automated protocol tests.
* [ ] Investigate streaming RPC support.
* [ ] Document supported features and known limitations.

## Design principles

### Keep dependencies explicit

Any runtime, operating-system facilities, or external libraries required for networking, cryptography, or other functionality should be documented.

### Test against real implementations

Successful communication with a single custom test server is not sufficient evidence of interoperability. Tests should progressively cover independent server implementations, protocol edge cases, malformed messages, and error handling.

### Make limitations visible

Protocol support should be documented precisely. An implementation that supports a limited subset of gRPC should identify that subset instead of claiming full compatibility.

## Building

### Requirements
- CMake 3.20 or newer
- GnuCOBOL compiler (`cobc`) available on `PATH`

### Configure

```bash
cmake -S . -B build
```

### Build

```bash
cmake --build build
```

## Testing

```bash
cmake --build build --target check
```

Or run CMake's generated test target:

```bash
cmake --build build --target test
```

(On Windows, avoid unqualified `ctest` if multiple CMake/MSYS toolchains are installed, because it can pick a different test runner than the one used to configure the build.)

## Contributing

Contributions, protocol research, interoperability tests, and reports about compiler or runtime compatibility are welcome.

Please keep proposed features aligned with the project's COBOL-first implementation goal.

### Git hooks

This repository includes a local commit-message hook in `.githooks/commit-msg` to validate conventional commit messages. Activate it once after cloning or after pulling changes:

```bash
cmake --build build --target git_hooks
```

If you prefer the shell helper, run:

```bash
./init.sh
```

The hook is configured via Git's `core.hooksPath` setting, so it applies to the repository without affecting other projects.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).