---
name: native-bridge
description: Load when asked to integrate a native module, device API, or SDK into a mobile app with permissions, error handling, and graceful fallbacks. Triggers on "add camera/location/push/biometrics", "integrate native module", "use a device API", "bridge to native", "request permission", "platform-specific code".
allowed-tools: [Read, Edit, Bash, Grep, Glob]
---

# Native Bridge

## Purpose
Integrate a native module or device/OS API (camera, location, push, biometrics,
storage, Bluetooth) safely: correct permission flow, both-platform handling,
defensive error paths, and a usable fallback when the capability is denied or
absent.

## When to use
- "add camera / location / notifications / biometrics / contacts"
- "integrate this native SDK / module" / "call a platform API"
- "request runtime permission" / "handle permission denied"
- "this works on iOS but not Android" / "platform-specific behavior"

## Procedure
1. Detect platform + bridge style. Find RN/Expo modules, Flutter plugins, or
   native (Swift/Kotlin) interop and how existing native features are wrapped.
   Prefer an existing maintained module over hand-rolling a bridge.
2. Check capability + availability. Confirm the API exists on the target OS
   versions; feature-detect at runtime rather than assuming presence.
3. Declare permissions correctly per platform: iOS Info.plist usage strings,
   Android manifest + runtime requests, and any entitlements/capabilities.
   Request at point-of-use with a pre-permission rationale, not at launch.
4. Wrap behind one abstraction. Expose a typed interface that hides platform
   branches; keep native specifics in the wrapper, not in screens.
5. Handle every outcome: granted, denied, denied-permanently (deep-link to
   Settings), restricted, unavailable, and runtime error. Never crash on denial.
6. Define the fallback. Degrade gracefully (manual entry, cached data, disabled
   CTA with explanation) so the core flow still works without the capability.
7. Manage lifecycle/threading: clean up listeners/sensors, marshal to the UI
   thread, and avoid leaks. Verify on both platforms (or note what is untested).

## Output format
```
## Capability
- API, module used, platforms + min OS

## Permissions
- iOS keys / Android perms added; when requested

## Abstraction
- interface + file; outcomes handled (granted/denied/unavailable)

## Fallback
- behavior when denied/absent

## Tested
- iOS / Android / simulator-only / not run
```

## Checklist
- [ ] Existing module/bridge reused where one exists; capability feature-detected
- [ ] iOS usage strings + Android manifest/runtime perms + entitlements set
- [ ] Permission requested at point-of-use with rationale, not at launch
- [ ] Native specifics hidden behind one typed wrapper
- [ ] granted/denied/permanently-denied/unavailable/error all handled, no crash
- [ ] Graceful fallback keeps the core flow usable
- [ ] Listeners/sensors cleaned up; verified per platform or gaps noted
