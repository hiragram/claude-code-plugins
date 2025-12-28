# iOS Team Plugin for Claude Code

A Claude Code plugin that provides comprehensive iOS development support through specialized agents, commands, and skills.

## Overview

This plugin integrates Claude AI into the iOS development workflow, offering:

- **MCP Servers** for direct Xcode project and iOS Simulator control
- **Commands** for rapid prototyping to production implementation
- **Skills** for specialized knowledge in architecture, UI, and project configuration
- **Agents** for autonomous iOS development tasks

## Features

### MCP Servers

| Server | Description |
|--------|-------------|
| `pbxproj-mcp` | Xcode project manipulation (targets, build settings, schemes, Swift packages) |
| `iossim-mcp` | iOS Simulator control (launch, screenshots, UI automation, gestures) |

### Commands

| Command | Description |
|---------|-------------|
| `/prototype` | Generate SwiftUI prototypes with preview support |
| `/implement` | Production implementation following project architecture rules |
| `/propose` | Full workflow: implement → build → commit → push → create PR |

### Skills

| Skill | Purpose |
|-------|---------|
| `screen-architecture` | Redux-pattern state management for iOS screens |
| `ui-mock-builder` | SwiftUI View and Preview generation |
| `build-settings-validator` | Xcode build settings validation and recommendations |
| `project-architecture` | Module structure and target management |
| `design-system` | Color palettes, typography, and spacing definitions |
| `localization` | String Catalog with type-safe symbol generation (Xcode 26+) |

### Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| `ios-feature-developer` | Opus 4.5 | Feature implementation, bug fixes, refactoring |
| `ios-screenshot-analyzer` | Sonnet | Visual verification of simulator screenshots |

## Architecture

The plugin promotes a **Redux-inspired pattern** for iOS screen architecture:

```
App/
├── AppState          # Single source of truth
├── AppAction         # Action definitions
├── AppStore          # @Published state container
├── AppReducer        # Pure functions (testable)
└── Views/
    ├── RootView      # Store in environment
    └── FeatureView   # Parameter-based (testable)
```

## Tech Stack

- **Languages**: Swift
- **Frameworks**: SwiftUI, UIKit, Combine, async/await
- **Data**: Core Data, SwiftData
- **Tools**: Xcode, Swift Package Manager, Git, GitHub CLI

## Usage

### Typical Workflow

1. `/prototype login screen` - Generate a quick SwiftUI prototype
2. Verify in simulator, analyze with screenshot agent
3. `/implement login screen` - Convert to production code with Redux pattern
4. `/propose` - Build, commit, push, and create PR automatically

### Project Setup

1. Use `build-settings-validator` to verify Xcode settings
2. Set up `design-system` for consistent styling
3. Configure `project-architecture` for module structure
4. Initialize `localization` for i18n support

## Requirements

- Claude Code CLI
- Xcode 15+
- macOS

## License

MIT
