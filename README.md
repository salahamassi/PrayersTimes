# PrayersTimes

[![CI](https://github.com/salahamassi/PrayersTimes/actions/workflows/CI.yml/badge.svg)](https://github.com/salahamassi/PrayersTimes/actions/workflows/CI.yml)

A Swift iOS application for calculating and displaying Islamic prayer times. Built with **clean architecture**, comprehensive testing, and modular design.

## Architecture

This project follows a strict **modular, protocol-oriented architecture** with clear separation of concerns:

```
PrayersTimes/
├── Prayers Times Feature/    # Domain layer — models, protocols, use cases
│   ├── PrayersTimes.swift    # Core model with @dynamicMemberLookup
│   ├── PrayerType.swift      # Prayer enum (Fajr, Dhuhr, Asr, Maghrib, Isha...)
│   ├── PrayersTimesLoader.swift  # Protocol for loading prayer times
│   └── PrayersUseCase.swift  # Business logic — get today's times, next prayer
│
├── Prayers Times Api/        # Network layer
│   ├── HTTPClient.swift      # Abstract HTTP protocol
│   ├── RemotePrayersTimesLoader.swift  # API implementation
│   └── URLSessionHTTPClient.swift      # URLSession adapter
│
├── Prayers Times Cache/      # Persistence layer
│   ├── LocalPrayersTimesLoader.swift   # Cache read/write
│   ├── CodablePrayersTimesStore.swift  # Codable file store
│   ├── PrayersTimesCachePolicy.swift   # Cache expiration rules
│   └── PrayersTimesStore.swift         # Store protocol
│
└── PrayersTimesiOS/          # UI layer — SwiftUI
    ├── PrayersTimesView.swift  # Main prayer times display
    ├── MoonView.swift          # Custom moon phase visualization
    ├── CrescentMoonView.swift  # Crescent moon shape
    ├── GibbousMoonView.swift   # Gibbous moon shape
    └── QuarterMoonView.swift   # Quarter moon shape
```

## Key Design Decisions

- **Protocol-Oriented:** `PrayersTimesLoader` and `HTTPClient` are protocols — easy to swap implementations and mock in tests
- **@dynamicMemberLookup:** `PrayersTimes` uses dynamic member lookup for clean property access
- **Cache Policy:** Dedicated `PrayersTimesCachePolicy` handles expiration logic separately from storage
- **No external dependencies:** Pure Swift, no third-party frameworks

## Testing

Comprehensive test suite covering every layer:

| Test Target | What's Tested |
|-------------|---------------|
| **Unit Tests** | Remote loader, HTTP client, cache operations, use cases |
| **Cache Store Specs** | Protocol-based specs for insert, retrieve, delete (including failure cases) |
| **End-to-End Tests** | Real API integration tests |
| **Snapshot Tests** | Moon phase UI rendering |
| **Memory Leak Tracking** | Custom XCTestCase extension to detect retain cycles |

## Features

- Calculate prayer times for any date and location
- Determine the next upcoming prayer
- Cache prayer times locally with expiration policy
- Custom moon phase visualizations in SwiftUI
- Fully testable with dependency injection

## Tech Stack

- **Swift** — Pure Swift, no Objective-C
- **SwiftUI** — Declarative UI with custom shapes
- **URLSession** — Native networking
- **Codable** — JSON parsing and local persistence
- **XCTest** — Unit, integration, and snapshot tests
- **GitHub Actions** — Automated CI pipeline

## Author

**Salah Nahed** — Senior Mobile Engineer

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0A66C2?style=flat&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/salah-nahed-a73250135)
[![Medium](https://img.shields.io/badge/Medium-000?style=flat&logo=medium&logoColor=white)](https://medium.com/@salahamassi)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat&logo=github&logoColor=white)](https://github.com/salahamassi)
