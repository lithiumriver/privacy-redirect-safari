# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Safari Web Extension that redirects Twitter/X, Reddit, YouTube, Google
Translate/Maps/Search, Imgur, and IMDB to privacy-friendly front-ends. It ships
as native Swift apps for **both macOS and iOS** — the WebExtension is wrapped in
a `SFSafariWebExtensionHandler`. Fork of Simon Brazell's
[Privacy Redirect](https://github.com/SimonBrazell/privacy-redirect).

(Medium, TikTok, and Quora were dropped in the v2.0.0 refresh — their upstream
front-ends died. See `docs/superpowers/specs/2026-07-06-safari-latest-refresh-design.md`.)

## Build & run

No package manager, lint config, or test suite — it's a pure Xcode project.

- Open `Privacy Redirect.xcodeproj` in Xcode.
- Four targets: `Privacy Redirect` (macOS app), `Privacy Redirect Extension`
  (macOS ext), `Privacy Redirect (iOS)`, `Privacy Redirect (iOS) Extension`.
- Run the app target for a platform, then enable the extension in Safari →
  Settings → Extensions. The app is only a settings UI + enabler; all redirect
  logic lives in the extension.
- CLI equivalent: `xcodebuild -project "Privacy Redirect.xcodeproj" -scheme "Privacy Redirect" build`

## Architecture: the redirect round-trip

The core behavior requires reading across four files that talk over Safari's
native-messaging bridge. On every matched page load:

1. A **content script** (`Shared (Extension)/assets/scripts/<service>.js`, run at
   `document_start`) sends `{type: "redirectSettings"}` via `browser.runtime.sendMessage`.
2. **`background.js`** relays it as a `sendNativeMessage` to the Swift side.
3. **`SafariWebExtensionHandler.beginRequest`** reads the shared-app-group
   `UserDefaults` and returns a bool per service (whether redirect is enabled).
4. If enabled, the content script then requests `{type: "instanceSettings"}`,
   which round-trips the same way and returns the user's chosen instance host.
5. The content script rewrites `window.location = instance + pathname + search`
   (see `reddit.js` for a representative example, including path-bypass regexes
   and per-instance quirks).

The App UI (`Shared (App)/`) is SwiftUI. Settings are stored via `@AppStorage`
and read back by the extension from a **shared app group** suite named
`<TeamIdentifierPrefix>Privacy-Redirect-for-Safari`. This app-group sharing is
what lets the settings UI and the extension see the same `UserDefaults`.

### UserDefaults key conventions (gotchas)

- Enable/disable is stored **inverted**: key `disable<Service>` (bool). The
  handler returns `!disableX`, so absence/false = enabled.
- Chosen instance is `<service>Instance` (string).
- Services are keyed by **backend name, not brand**: `nitter` (Twitter/X —
  default instance is Xcancel, a Nitter fork), `reddit`/`redlib` (Reddit —
  Redlib backend), `invidious` (YouTube), `simplyTranslate` (Google Translate),
  `osm` (Google Maps), `searchEngine` (Google Search), `rimgo` (Imgur),
  `libremdb` (IMDB). Keep this mapping straight when touching handler, view, and
  instance list. (The `nitter` key name predates the Xcancel default and is kept
  as-is.)

## macOS vs iOS duplication

Shared (edit once): content scripts under `Shared (Extension)/assets/scripts/`
and the SwiftUI settings UI under `Shared (App)/`.

**Duplicated per platform — must be kept in sync:**
- `manifest.json` — `macOS (Extension)/Resources/` vs `iOS (Extension)/Resources/`
- `SafariWebExtensionHandler.swift` — `macOS (Extension)/` vs `iOS (Extension)/`
- `background.js` — macOS lives in `Resources/pages/` (plus a `popup/`); iOS is flat in `Resources/`

## Adding or changing a redirect service

A single service is spread across many files. To add one, edit **all** of:

1. New content script in `Shared (Extension)/assets/scripts/<service>.js`.
2. Register its `content_scripts` match block in **both** manifests.
3. Add the default instance list to `Shared (App)/Instances.swift` (source of
   truth for the dropdowns).
4. Add `redirectSettings` (bool) **and** `instanceSettings` (string, with a
   default) entries in **both** `SafariWebExtensionHandler.swift` files.
5. Add an `InstanceSection` to `Shared (App)/InstancesView.swift`.

Instance default strings in the handler must match entries in `Instances.swift`.

## Notes

- `Shared (App)/RawRepresentable/` provides `Array`/`Dictionary` conformances so
  they can be persisted through `@AppStorage`.
- `manifest.json` is **Manifest V3** (`action`, `host_permissions` for
  `<all_urls>`, a `service_worker` background); the Google Search/Maps/Translate
  match lists enumerate every country TLD by hand.
- Minimum OS is **macOS 13.3 / iOS 16.4** (the floor for Safari MV3 service-worker
  support); `SWIFT_VERSION` is intentionally kept at 5.0.

---

# context-mode — MANDATORY routing rules

You have context-mode MCP tools available. These rules are NOT optional — they protect your context window from flooding. A single unrouted command can dump 56 KB into context and waste the entire session.

## BLOCKED commands — do NOT attempt these

### curl / wget — BLOCKED
Any Bash command containing `curl` or `wget` is intercepted and replaced with an error message. Do NOT retry.
Instead use:
- `ctx_fetch_and_index(url, source)` to fetch and index web pages
- `ctx_execute(language: "javascript", code: "const r = await fetch(...)")` to run HTTP calls in sandbox

### Inline HTTP — BLOCKED
Any Bash command containing `fetch('http`, `requests.get(`, `requests.post(`, `http.get(`, or `http.request(` is intercepted and replaced with an error message. Do NOT retry with Bash.
Instead use:
- `ctx_execute(language, code)` to run HTTP calls in sandbox — only stdout enters context

### WebFetch — BLOCKED
WebFetch calls are denied entirely. The URL is extracted and you are told to use `ctx_fetch_and_index` instead.
Instead use:
- `ctx_fetch_and_index(url, source)` then `ctx_search(queries)` to query the indexed content

## REDIRECTED tools — use sandbox equivalents

### Bash (>20 lines output)
Bash is ONLY for: `git`, `mkdir`, `rm`, `mv`, `cd`, `ls`, `npm install`, `pip install`, and other short-output commands.
For everything else, use:
- `ctx_batch_execute(commands, queries)` — run multiple commands + search in ONE call
- `ctx_execute(language: "shell", code: "...")` — run in sandbox, only stdout enters context

### Read (for analysis)
If you are reading a file to **Edit** it → Read is correct (Edit needs content in context).
If you are reading to **analyze, explore, or summarize** → use `ctx_execute_file(path, language, code)` instead. Only your printed summary enters context. The raw file content stays in the sandbox.

### Grep (large results)
Grep results can flood context. Use `ctx_execute(language: "shell", code: "grep ...")` to run searches in sandbox. Only your printed summary enters context.

## Tool selection hierarchy

1. **GATHER**: `ctx_batch_execute(commands, queries)` — Primary tool. Runs all commands, auto-indexes output, returns search results. ONE call replaces 30+ individual calls.
2. **FOLLOW-UP**: `ctx_search(queries: ["q1", "q2", ...])` — Query indexed content. Pass ALL questions as array in ONE call.
3. **PROCESSING**: `ctx_execute(language, code)` | `ctx_execute_file(path, language, code)` — Sandbox execution. Only stdout enters context.
4. **WEB**: `ctx_fetch_and_index(url, source)` then `ctx_search(queries)` — Fetch, chunk, index, query. Raw HTML never enters context.
5. **INDEX**: `ctx_index(content, source)` — Store content in FTS5 knowledge base for later search.

## Subagent routing

When spawning subagents (Agent/Task tool), the routing block is automatically injected into their prompt. Bash-type subagents are upgraded to general-purpose so they have access to MCP tools. You do NOT need to manually instruct subagents about context-mode.

## Output constraints

- Keep responses under 500 words.
- Write artifacts (code, configs, PRDs) to FILES — never return them as inline text. Return only: file path + 1-line description.
- When indexing content, use descriptive source labels so others can `ctx_search(source: "label")` later.

## ctx commands

| Command | Action |
|---------|--------|
| `ctx stats` | Call the `ctx_stats` MCP tool and display the full output verbatim |
| `ctx doctor` | Call the `ctx_doctor` MCP tool, run the returned shell command, display as checklist |
| `ctx upgrade` | Call the `ctx_upgrade` MCP tool, run the returned shell command, display as checklist |
