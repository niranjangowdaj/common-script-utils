# odu-utils

A collection of useful utility scripts for developers, designed to work with [odu](https://github.com/niranjangowdaj/odu).

## Add this namespace

```bash
odu add utils https://github.com/niranjangowdaj/odu-utils
```

## Available scripts

| Script | Description |
|---|---|
| `kport` | Kill process running on a port |
| `lsport` | List all processes listening on ports |
| `cleanbranches` | Delete all local branches merged into main/master |
| `serve` | Start a local HTTP server in the current directory |

## Usage

```bash
odu utils kport 3000              # kill whatever is on port 3000
odu utils lsport                  # see all listening ports
odu utils cleanbranches           # clean up merged git branches
odu utils serve                   # serve current dir on port 8000
odu utils serve 9000              # serve on a custom port
```

## Structure

```
.
├── odu.yaml
└── scripts/
    ├── kport.sh
    ├── lsport.sh
    ├── cleanbranches.sh
    └── serve.sh
```

## Contributing

Add a script to `scripts/`, add an entry to `odu.yaml`, and open a PR.

Scripts should:
- Have a `# Description: ...` comment on the second line (after shebang)
- Print clear usage when run without required arguments
- Work on macOS and Linux
