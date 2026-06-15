---
name: screen-builder
description: Load when asked to build a responsive, accessible mobile screen or component. Triggers on "build a screen", "new screen/page", "add a component", "make this responsive", "make it accessible", "implement this design", "wire up navigation".
allowed-tools: [Read, Edit, Bash, Grep, Glob]
---

# Screen Builder

## Purpose
Build a mobile screen or reusable component that is responsive across device
sizes and orientations, accessible by default, and consistent with the project's
existing patterns, design tokens, and navigation.

## When to use
- "build a screen" / "add a new page" / "implement this design/mockup"
- "make this component responsive" / "support tablet + small phones"
- "make this accessible" / "fix the a11y on this screen"
- "wire this screen into navigation" / "add a reusable component"

## Procedure
1. Detect stack and conventions. Find the framework (React Native/Expo, Flutter,
   SwiftUI, Compose) and existing screens/components, design tokens, and the
   navigation library with Glob/Grep before writing anything.
2. Reuse first. Match existing folder layout, naming, styling approach (tokens,
   theme, spacing scale), and shared primitives. Do not introduce a new UI lib;
   prefer the project's component set (or shadcn/lucide-react if web-hybrid).
3. Layout responsively. Use flex/safe-area, relative units, and breakpoints over
   fixed pixels. Handle notches/insets, keyboard avoidance, orientation, dynamic
   text scaling, and small/large screens. No hardcoded device dimensions.
4. Build accessibility in: labels/roles/hints on interactive elements, min 44x44pt
   touch targets, logical focus order, sufficient contrast, reduced-motion respect,
   and screen-reader-only text where icons stand alone.
5. Handle states: loading, empty, error, and offline. Keep side effects in
   hooks/viewmodels; keep the view declarative and testable.
6. Wire navigation + data. Register the route, type its params, and connect data
   via the existing fetch/state layer; avoid blocking the first paint.
7. Verify. Run typecheck/lint and any component test or snapshot; render at small,
   large, and RTL/large-font settings if a harness exists.

## Output format
```
## Screen/component
- Name, path, framework, route wired (y/n)

## Files changed
- path — what

## Responsiveness & a11y notes
- breakpoints/insets handled; a11y roles/labels/contrast addressed

## Follow-ups
- known gaps / states not yet covered
```

## Checklist
- [ ] Stack, tokens, nav lib, and sibling components discovered and matched
- [ ] No fixed device sizes; safe-area, insets, keyboard, orientation handled
- [ ] Dynamic font scaling and small + large screens both render
- [ ] A11y labels/roles, 44pt targets, contrast, focus order, reduced motion
- [ ] Loading/empty/error/offline states present
- [ ] Route registered with typed params; data wired non-blocking
- [ ] Typecheck/lint and available component tests pass
