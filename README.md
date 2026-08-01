# odu-utils

A collection of useful utility scripts for developers, designed to work with [odu](https://github.com/niranjangowdaj/odu).

## Add this namespace

```bash
odu add utils https://github.com/niranjangowdaj/common-script-utils
```

## Available scripts

| Script | Description | Platform |
|---|---|---|
| `kport` | Kill process running on a port | macOS/Linux |
| `lsport` | List all processes listening on ports | macOS/Linux |
| `cleanbranches` | Delete all local branches merged into main/master | macOS/Linux |
| `serve` | Serve current directory on local network with a 4-digit PIN | macOS/Linux/Windows |
| `lsjava` | List all installed Java versions | macOS |
| `vjava` | Switch Java version | macOS |

## Usage

```bash
# Ports
odu utils kport 3000              # kill whatever is on port 3000
odu utils lsport                  # see all listening ports

# Git
odu utils cleanbranches           # clean up merged git branches

# File sharing
odu utils serve                   # serve current dir on port 8000 with PIN
odu utils serve 9000              # serve on a custom port

# Java
odu utils lsjava                  # list all installed Java versions
odu utils vjava 17                # switch to Java 17
odu utils vjava 21                # switch to Java 21
```

## Structure

```
.
├── odu.yaml
└── scripts/
    ├── kport.sh
    ├── lsport.sh
    ├── cleanbranches.sh
    ├── serve.py
    ├── lsjava.sh
    └── vjava.sh
```

## Contributing

Add a script to `scripts/`, add an entry to `odu.yaml`, and open a PR.

Scripts should:
- Have a `# Description: ...` comment on the second line (after shebang)
- Print clear usage when run without required arguments
- Work on macOS and Linux where possible
