# Meta Browser Commerce

**Hands-free product search & purchase on Meta AI Glasses**

Native iOS Swift app and supporting materials for the Meta AI grant application.

## Overview

Meta Browser Commerce lets users search, compare, and buy products by voice on Meta AI Glasses. The companion app captures voice requests, runs search across retailers via web discovery (Omnia MCP + browser-use), and speaks results and prices over the glasses. Users can add items to cart and complete purchases without using a phone.

## iOS App (Swift / SwiftUI)

| Component | Description |
|-----------|-------------|
| **Pairing** | Connect Meta AI Glasses via Meta Wearables DAT SDK |
| **Home** | Voice prompt examples, connection status, recent activity |
| **Search** | Multi-retailer product results (Nike, Amazon, Target) |
| **Compare** | Side-by-side product comparison, add to cart |
| **Cart** | Items added by voice, checkout flow |

### Build & Run

1. Open `MetaBrowserCommerce.xcodeproj` in Xcode.
2. Select iPhone simulator (e.g. iPhone 17) and run (⌘R).
3. Add Meta DAT: **File → Add Package Dependencies** → `https://github.com/facebook/meta-wearables-dat-ios`

### Grant Application Materials

| Type | Source | Description |
|------|--------|-------------|
| **Mobile app screens** | iOS app | Pairing, Home, Search Results, Compare, Cart |
| **Voice flow diagram** | `flow-diagram.html` | Technical flow for grant images |

## Technical flow

```
User (glasses) 
  → Mobile app (voice from Meta DAT)
    → Intent parsing → MCP client
      → run_browser_task / execute_website_action
        → browser-use on retailer URLs
          → structured result
    → TTS → Meta DAT → glasses (audio)
```

## APIs & integration

- **Omnia MCP** (run_browser_task, execute_website_action)
- **Meta DAT SDK** (pairing, voice capture, TTS output)
- **Retailer sites** via browser-use (no onboarding required)

## Project structure

```
Meta-Browser-Commerce/
├── MetaBrowserCommerce.xcodeproj/
├── MetaBrowserCommerce/
│   ├── MetaBrowserCommerceApp.swift
│   ├── AppState.swift
│   ├── RootView.swift
│   ├── Views/           # PairingView, HomeView, SearchResultsView, CompareView, CartView
│   ├── Models/          # ProductResult, CartItem
│   ├── Services/        # MetaDATService (placeholder for Meta DAT)
│   └── Assets.xcassets/
├── flow-diagram.html    # Voice flow diagram for grant
├── index.html           # HTML mockup (optional demo)
└── README.md
```
