# VisionClaw-Inspired Workflow for Meta Browser Commerce

This document describes how the glasses live camera + voice workflow would work, inspired by [VisionClaw](https://github.com/sseanliu/VisionClaw) — a real-time AI assistant for Meta Ray-Ban glasses using the Meta Wearables DAT SDK.

## VisionClaw Reference Architecture

```
Meta Ray-Ban Glasses
       |
       | video frames (~1fps) + mic audio
       v
iOS App (Meta DAT SDK)
       |
       | JPEG frames + PCM audio (16kHz)
       v
Gemini Live API (WebSocket)
       |
       |-- Audio response --> Speaker
       |-- Tool calls ------> OpenClaw Gateway
       |                          |
       |                          v
       |                     Web search, messaging,
       |                     shopping lists, etc.
       v
  AI speaks result
```

**Key points from VisionClaw:**
- DAT SDK provides video stream (24fps) and mic audio from glasses
- Video throttled to ~1fps before sending to AI (bandwidth)
- Audio flows bidirectionally (voice in, TTS out)
- Tool calling lets the AI execute actions (web search, add to list, etc.)
- Phone mode: use iPhone camera when glasses unavailable

## Applied to Meta Browser Commerce

Same tech stack: **Swift, Meta Wearables DAT SDK** — different use case: **hands-free commerce**.

```
Meta AI Glasses (Ray-Ban / Oakley)
       |
       | video frames (~1fps) + voice
       v
Meta Browser Commerce iOS App
       |
       | DAT SDK: camera capture + mic capture
       v
Intent layer (voice → "find", "compare", "add to cart")
       |
       | MCP client
       v
run_browser_task / execute_website_action
       |
       | Omnia / browser-use on retailer URLs
       v
Structured results (products, prices)
       |
       | TTS
       v
Meta DAT → Glasses speaker
```

### Workflow Steps (VisionClaw-style)

1. **Camera on** – User taps "Launch Glasses Camera" or glasses AI button
2. **Stream** – DAT SDK streams video (~1fps) + mic to app
3. **Voice** – "Find running shoes under $80" or "Compare these two" (camera provides visual context)
4. **Intent** – App parses intent → maps to `run_browser_task` / MCP
5. **Browser automation** – Headless browser hits Nike, Amazon, Target
6. **Results** – Structured data formatted for TTS
7. **Spoken** – "I found Nike Revolution 7 at $69, Nike Pegasus at $79..."
8. **Confirm** – "Add Nike Revolution to cart?" → user confirms by voice
9. **Cart / Checkout** – Item added, user can complete purchase

### Video Context (optional enhancement)

Like VisionClaw, the camera can provide visual context:

- **"What am I looking at?"** → product recognition
- **"Find a cheaper alternative to this"** → user holds product in view
- **"Compare this with the one on screen"** → price check

Implementation would throttle DAT video to ~1fps, capture JPEG, send to a vision-capable backend (or integrate with an AI API that accepts images).

### Tech Stack (unchanged)

- **Meta Wearables DAT SDK (iOS)** – pairing, camera, mic, speaker
- **Swift / SwiftUI** – app UI
- **Omnia MCP** – `run_browser_task`, `execute_website_action`
- **browser-use** – web discovery on retailer sites

No Gemini, no OpenClaw — the commerce pipeline uses MCP + browser-use. The *workflow pattern* (camera + voice → intent → tools → spoken result) is what we adopt from VisionClaw.
