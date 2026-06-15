# Checklists

Per-domain quality checklists for this project. Source-stamped best practices follow.

## a11y

## Accessibility Checklist

- [ ] Use semantic HTML elements (`<button>`, `<nav>`, `<main>`, `<header>`, headings in order) — native semantics give assistive tech structure and behavior for free.
- [ ] Provide meaningful `alt` text for informative images and empty `alt=""` for decorative ones — screen readers convey or skip images appropriately.
- [ ] Associate every form control with a `<label>` via `for`/`id` (or wrap it) — labels are announced and enlarge the clickable target.
- [ ] Ensure all interactive elements are reachable and operable by keyboard with a logical focus/tab order — many users navigate without a mouse.
- [ ] Keep a clearly visible focus indicator (never `outline: none` without a replacement) — keyboard users must see where they are.
- [ ] Meet WCAG AA color contrast (4.5:1 for normal text, 3:1 for large text and UI components) — low contrast fails low-vision and bright-light users.
- [ ] Add ARIA roles/attributes only when native HTML cannot express the semantics — incorrect or redundant ARIA breaks more than it fixes.
- [ ] Honor `prefers-reduced-motion` by reducing or removing non-essential animation — motion can trigger nausea, dizziness, and vestibular disorders.
- [ ] Link form errors to their fields with `aria-describedby` and announce them via `aria-live`/`role="alert"` — users learn what failed and how to fix it.

## ci-gates

## CI Gates

Every PR must pass these gates before merge.

### Required

- [ ] **Install** — dependencies resolve cleanly from a lockfile, ensuring reproducible builds.
- [ ] **Lint** — code style and static analysis pass, catching defects and enforcing conventions.
- [ ] **Typecheck** — type checker reports no errors, preventing whole classes of runtime bugs.
- [ ] **Unit tests** — all tests pass, proving behavior is correct and guarding against regressions.
- [ ] **Build** — production artifact compiles successfully, confirming the change ships.

### Optional

- [ ] **Coverage threshold** — coverage meets the minimum bar, ensuring new code is tested.
- [ ] **Secret scan** — no credentials or keys committed, preventing leaked secrets.

## secret-handling

## Secret Handling Checklist

- [ ] Never commit secrets to version control — git history is permanent and hard to scrub.
- [ ] Store local secrets in a gitignored `.env` file — keeps real values off disk that ships.
- [ ] Confirm `.env` is listed in `.gitignore` before the first commit — prevents accidental staging.
- [ ] Provide a committed `.env.example` with keys and placeholder values only — documents required config without exposing values.
- [ ] Inject secrets at runtime via CI variables or a secret store (Vault, AWS/GCP/Azure secret manager) — centralizes control and avoids hardcoding.
- [ ] Scope each secret to least privilege and per environment — limits blast radius if one leaks.
- [ ] Rotate any secret immediately on suspected leak and invalidate the old value — a committed secret is compromised even after deletion.
- [ ] Never log, print, or echo secret values — logs and stack traces are widely readable and retained.
- [ ] Redact secrets from error messages and exception reports — error pipelines often reach third parties.
- [ ] Run a pre-commit secret scanner (e.g. gitleaks, detect-secrets) — catches leaks before they enter history.
- [ ] Enable server-side / CI secret scanning as a backstop — defends against bypassed local hooks.
- [ ] Set expirations on credentials and review access periodically — stale long-lived secrets accumulate risk.

## security-headers

## Web Security Headers Checklist

### Content Security Policy (CSP)
- [ ] Set `Content-Security-Policy` with an explicit allowlist — restricts which sources can load scripts/styles/frames, the primary defense against XSS and injection.
- [ ] Avoid `unsafe-inline` and `unsafe-eval`; use nonces or hashes for inline scripts — these directives reopen the XSS hole CSP is meant to close.
- [ ] Set `default-src 'none'` (or `'self'`) as a baseline and add directives explicitly — fail-closed so unlisted resource types are blocked by default.
- [ ] Add `object-src 'none'` and `base-uri 'self'` — kills legacy plugin vectors and prevents `<base>` tag hijacking of relative URLs.
- [ ] Roll out via `Content-Security-Policy-Report-Only` with `report-uri`/`report-to` first — surfaces violations without breaking the app before enforcing.

### HTTP Strict Transport Security (HSTS)
- [ ] Send `Strict-Transport-Security: max-age=31536000; includeSubDomains` over HTTPS — forces browsers to use TLS and blocks SSL-stripping downgrade attacks.
- [ ] Add `preload` and submit to the HSTS preload list only when all subdomains support HTTPS — guarantees the very first request is encrypted, but is hard to undo.

### X-Content-Type-Options
- [ ] Set `X-Content-Type-Options: nosniff` — stops MIME-type sniffing so the browser cannot reinterpret responses as executable content.

### Framing Protection
- [ ] Use CSP `frame-ancestors 'self'` (or specific origins) as the modern clickjacking control — supersedes `X-Frame-Options` and supports multiple allowed origins.
- [ ] Keep `X-Frame-Options: DENY` (or `SAMEORIGIN`) for older-browser coverage — prevents the page from being embedded in attacker-controlled frames.

### Referrer-Policy
- [ ] Set `Referrer-Policy: strict-origin-when-cross-origin` (or stricter) — limits leakage of full URLs and query strings to third-party destinations.

### Permissions-Policy
- [ ] Set `Permissions-Policy` to disable unused features, e.g. `geolocation=(), camera=(), microphone=()` — minimizes attack surface by denying powerful APIs the app does not need.

### Cookie Flags
- [ ] Mark session cookies `HttpOnly` — blocks JavaScript access so XSS cannot steal the cookie.
- [ ] Mark cookies `Secure` — ensures they are only sent over HTTPS, never in cleartext.
- [ ] Set `SameSite=Lax` (or `Strict`) — mitigates CSRF by restricting cross-site cookie transmission; use `Strict` for high-value sessions.
- [ ] Use `__Host-`/`__Secure-` cookie name prefixes — enforces Secure + path/host scoping at the browser level.

### CORS Discipline
- [ ] Never reflect arbitrary origins or use `Access-Control-Allow-Origin: *` with credentials — wildcard plus credentials exposes authenticated data to any site.
- [ ] Validate the `Origin` request header against a strict allowlist — only trusted origins should receive cross-origin access.
- [ ] Scope `Access-Control-Allow-Methods` and `Access-Control-Allow-Headers` to the minimum required — avoids over-permissive preflight grants.
- [ ] Set `Access-Control-Allow-Credentials: true` only when genuinely needed, paired with an exact origin — prevents unintended credentialed cross-origin requests.

### General
- [ ] Remove or obscure `Server`, `X-Powered-By`, and version banners — reduces fingerprinting that helps attackers target known vulnerabilities.
- [ ] Verify headers in CI and with a scanner (e.g. securityheaders.com, OWASP ZAP) — catches regressions before they reach production.

## payment-readiness

- [ ] Never store raw card data (PAN, CVV, expiry) anywhere in the app — keeping it out of scope avoids PCI DSS liability entirely.
- [ ] Use a PCI-compliant processor like Stripe — they handle card vaulting and certification so you do not have to.
- [ ] Use processor-hosted checkout or Elements/iframes — card fields never touch your servers, keeping PCI scope to SAQ A.
- [ ] Verify every webhook via its signature header before acting — prevents forged events from triggering fulfillment or refunds.
- [ ] Send idempotency keys on charge/payment creation — guarantees retries do not double-charge the customer.
- [ ] Handle refunds and disputes/chargebacks explicitly — surface them in your data model and reverse entitlements when they occur.
- [ ] Store only processor tokens and customer IDs, never card numbers — references stay useless to an attacker if leaked.
- [ ] Reconcile order/payment state from webhooks, not client redirects — the browser can be closed or spoofed, so treat the server event as source of truth.
- [ ] Use separate test and live API keys, and keep secrets in env/secret storage — prevents accidental real charges and key leakage.
- [ ] Log payment events with correlation IDs but redact sensitive fields — enables auditing and reconciliation without exposing PII.

## seo

## SEO Checklist

- [ ] Unique title tag per page — primary relevance signal and the clickable headline in search results.
- [ ] Unique meta description per page — controls the result snippet and influences click-through rate.
- [ ] Semantic heading hierarchy (single H1, ordered H2/H3) — communicates content structure to crawlers and assistive tech.
- [ ] Open Graph tags (og:title, og:description, og:image, og:url) — controls how links render when shared on social platforms.
- [ ] Twitter Card tags (twitter:card, twitter:title, twitter:image) — controls rich preview rendering on X/Twitter.
- [ ] sitemap.xml published and referenced — helps crawlers discover and prioritize all indexable URLs.
- [ ] robots.txt configured (with sitemap reference) — guides crawlers on what to crawl and where the sitemap lives.
- [ ] Canonical URL on every page — consolidates ranking signals and prevents duplicate-content dilution.
- [ ] Critical content server-rendered or pre-rendered — ensures crawlers see content without relying on client-side JS execution.
- [ ] Fast LCP and passing Core Web Vitals — page experience is a ranking factor and affects bounce/conversion.
- [ ] Descriptive alt text on meaningful images — enables image search indexing and accessibility.
- [ ] Structured data (JSON-LD) where relevant — enables rich results and clarifies entity meaning to search engines.

## mobile-a11y

## Mobile Accessibility

- [ ] Support dynamic type and font scaling so text reflows without clipping at the largest OS setting. Users with low vision rely on system text size, and fixed fonts make content unreadable.
- [ ] Provide screen-reader labels for every interactive and informative element (VoiceOver/TalkBack). Unlabeled controls announce as "button" or nothing, blocking non-visual navigation.
- [ ] Mark decorative images as hidden from assistive tech so they are not announced. Reading out non-meaningful visuals adds noise and slows comprehension.
- [ ] Ensure touch targets are at least 44x44 pt (iOS) / 48x48 dp (Android) with adequate spacing. Small or crowded targets cause mis-taps for users with motor or dexterity limits.
- [ ] Meet WCAG contrast ratios (4.5:1 body text, 3:1 large text and UI components). Low contrast fails users in sunlight and those with reduced vision.
- [ ] Do not rely on color alone to convey state or meaning; pair with icons, text, or patterns. Color-blind users cannot distinguish status communicated only by hue.
- [ ] Define a logical focus order that matches visual reading order for keyboard and switch control. Jumbled focus traversal disorients users navigating sequentially.
- [ ] Move focus to newly revealed content (modals, errors, alerts) and restore it on dismiss. Lost focus strands assistive-tech users and hides critical messages.
- [ ] Respect reduce-motion settings by disabling or simplifying animations. Parallax and large transitions can trigger nausea or vestibular discomfort.
- [ ] Test with VoiceOver and TalkBack on real devices before release. Automated checks miss labeling, gesture, and reading-order issues only audible in practice.

## offline-support

## Offline Support

- [ ] Cache read data locally (e.g. SQLite, Room, Core Data) so prior content is viewable offline. Networks drop in transit and basements, and a blank screen erodes trust.
- [ ] Queue writes durably while offline and flush them when connectivity returns. Dropping user actions silently loses data and forces frustrating re-entry.
- [ ] Apply optimistic UI updates immediately, then reconcile with the server response. Waiting for round-trips on every tap makes the app feel broken on slow links.
- [ ] Roll back or flag optimistic changes that the server later rejects. Leaving stale "successful" UI desyncs the user from real state.
- [ ] Sync automatically on reconnect using a network-reachability listener. Manual-only sync leads to forgotten, unsynced changes and conflicts.
- [ ] Detect and resolve write conflicts with a clear strategy (last-write-wins, merge, or prompt). Concurrent edits across devices corrupt data without conflict handling.
- [ ] Show an explicit, non-blocking no-network state with retry affordance. Ambiguous spinners leave users unsure whether to wait or act.
- [ ] Make queued operations idempotent and deduplicated on retry. Network retries can double-submit, creating duplicate records or charges.
- [ ] Bound cache size and expire stale entries to avoid unbounded storage growth. Unmanaged caches bloat device storage and surface outdated data.
- [ ] Test airplane mode, flaky connections, and mid-sync interruption. Real-world degraded networks expose race conditions clean Wi-Fi never reveals.

## permissions

## Permissions

- [ ] Request each permission at the point of use, not on first launch. Contextual prompts have far higher grant rates and feel justified to the user.
- [ ] Show a pre-permission priming screen explaining why before triggering the OS dialog. The system prompt can only be shown once, so context must precede it.
- [ ] Provide a clear, specific usage-description string for every iOS permission (NSCameraUsageDescription, etc.). Missing or vague strings cause App Store rejection and user distrust.
- [ ] Handle denial gracefully with a usable degraded experience instead of dead-ending. Many users decline, and the feature flow must not break.
- [ ] Detect permanently denied state and deep-link to system Settings to re-enable. Once denied, the OS dialog will not reappear, so guide the user to settings.
- [ ] Request the least privilege needed (e.g. when-in-use over always, limited photo access). Over-asking lowers grant rates and raises review and privacy scrutiny.
- [ ] Avoid requesting permissions the feature does not currently need. Unused permissions trigger store warnings and signal data overreach to users.
- [ ] Re-check permission status at each use rather than caching the first result. Users can revoke access anytime in system settings between sessions.
- [ ] Document why each permission is needed for the store data-safety/privacy forms. Reviewers cross-check declared permissions against stated purpose.
- [ ] Test grant, deny, and revoke-after-grant paths on both platforms. Each branch has distinct behavior that only surfaces through deliberate testing.

## store-readiness

## Store Readiness

- [ ] Provide all required app icons, adaptive icons, and launch/splash assets at every density. Missing or low-res assets cause rejection and a broken first impression.
- [ ] Prepare localized screenshots and store listing copy for each target device size. Incorrect or absent screenshots fail review and hurt conversion.
- [ ] Publish a reachable privacy policy URL and complete the data-safety / privacy nutrition labels accurately. Both stores block submission without truthful data-collection disclosures.
- [ ] Set a correct, monotonically increasing version name and build number. Duplicate or lower build numbers are rejected on upload.
- [ ] Verify the crash-free session/user rate meets your release bar (e.g. >=99%) via Crashlytics/Sentry. Shipping with known crashes risks bad reviews and store takedown.
- [ ] Review against Apple App Review Guidelines and Google Play policies before submit. Common rejections (payments, account deletion, login, ATT) are predictable and avoidable.
- [ ] Provide an in-app account and data deletion path where accounts exist. Both stores now mandate user-initiated deletion for account-based apps.
- [ ] Confirm required compliance items: export-compliance, content rating/IARC, target API level, and 64-bit builds. Each is a hard gate that blocks the release if unmet.
- [ ] Supply working demo credentials and review notes for any gated features. Reviewers reject apps they cannot fully access or understand.
- [ ] Test the release (not debug) build on real devices, including a clean first install. Release configs strip debug shims and surface signing, ProGuard, and config bugs.

## authz

## Authorization

- [ ] Authenticate the principal before making any authorization decision. You cannot decide what someone may do until you know who they are.
- [ ] Grant each principal the least privilege required for its task. Minimal permissions limit the damage from a compromised or misused account.
- [ ] Default to deny and grant access only by explicit allow rules. A deny-by-default posture fails safe when a rule is missing or ambiguous.
- [ ] Enforce authorization on every request at the server, never trusting the client. Client-side checks are advisory; the server is the only place a control is real.
- [ ] Verify object-level ownership on every resource access to prevent IDOR. Without a per-object check, an attacker just edits the ID to read someone else's data.
- [ ] Centralize authorization logic instead of scattering ad-hoc checks. Duplicated checks drift apart and leave gaps that a single enforcement point avoids.
- [ ] Re-check permissions on state-changing actions, not only on read. A user whose access was revoked must not still be able to mutate data.
- [ ] Log authorization denials and privileged actions for audit. Denial trails reveal probing attacks and prove who performed sensitive operations.
- [ ] Cover authorization paths with tests, including negative cases. An untested allow/deny rule is an assumption, not a guarantee.

## dependency-audit

## Dependency Audit

- [ ] Commit a lockfile for every package manager and require it in CI. Reproducible builds depend on resolving the exact same dependency graph every time.
- [ ] Run software composition analysis (SCA) on every build and pull request. Automated scanning is the only scalable way to catch vulnerable transitive dependencies.
- [ ] Fail the build when a dependency has a known vulnerability above the agreed severity threshold. A warning that nobody acts on is not a control.
- [ ] Pin direct dependencies to exact versions rather than floating ranges. Unpinned ranges let an upstream release change your build without review.
- [ ] Review and test dependency updates before merging, including transitive changes. Blindly auto-merging upgrades is a supply-chain attack waiting to happen.
- [ ] Generate and publish an SBOM for each release artifact. You cannot respond to a new CVE if you do not know what you shipped.
- [ ] Verify package integrity via hashes or signatures at install time. Hash verification detects tampered or substituted packages before they execute.
- [ ] Remove unused and duplicate dependencies on a regular cadence. Every dependency you do not need is attack surface you do not benefit from.
- [ ] Track upstream maintenance status and flag abandoned packages. Unmaintained code will not receive the security fix you eventually need.

## secrets-rotation

## Secrets Rotation

- [ ] Keep secrets out of source code, config files, and commit history. Anything in the repo is exposed to everyone who can clone it and lives forever in history.
- [ ] Store secrets in a dedicated secret manager and inject them at runtime. Centralized storage gives you access control, rotation, and an audit trail in one place.
- [ ] Scan commits and pull requests for secrets before they merge. Pre-merge detection is far cheaper than revoking a leaked credential after the fact.
- [ ] Rotate a secret immediately whenever a leak is suspected or confirmed. A compromised credential stays useful to an attacker until it is revoked.
- [ ] Rotate all long-lived secrets on a fixed schedule. Scheduled rotation bounds the window during which an undetected leak remains exploitable.
- [ ] Prefer short-lived, automatically issued credentials over static long-lived ones. Credentials that expire in minutes limit the blast radius of any single leak.
- [ ] Scope each secret to the least privilege and narrowest resource it needs. A tightly scoped credential is worth far less to whoever steals it.
- [ ] Audit and log every access to secrets, with alerts on anomalies. You cannot detect misuse of a credential whose access you never recorded.
- [ ] Document an owner and rotation procedure for every secret. An orphaned secret never gets rotated and never gets revoked.

## threat-model

## Threat Model

- [ ] Inventory every component (frontend, API, workers, datastores, third-party services) and draw a data-flow diagram. You cannot model threats against a system whose shape you have not written down.
- [ ] Mark trust boundaries on the diagram wherever data crosses between zones of differing privilege (internet to edge, edge to service, service to datastore). Threats concentrate at boundary crossings.
- [ ] Catalog assets and rank them by sensitivity (credentials, PII, payment data, tokens, intellectual property). Mitigation effort should track the value of what is being protected.
- [ ] Run STRIDE against each component and each data flow, recording threats per category. A structured pass catches classes of attack that ad-hoc brainstorming misses.
- [ ] Spoofing: verify identity at every boundary with strong authentication and signed tokens. An attacker who can impersonate a principal bypasses all downstream controls.
- [ ] Tampering: protect integrity in transit and at rest with TLS, signatures, and checksums. Silent modification of data or messages corrupts every decision made on it.
- [ ] Repudiation: emit tamper-evident audit logs for security-relevant actions. Without non-repudiation you cannot prove who did what after an incident.
- [ ] Information disclosure: enforce encryption, least-privilege reads, and minimal error detail. Leaked data and verbose errors hand attackers reconnaissance for free.
- [ ] Denial of service: apply rate limits, quotas, timeouts, and resource caps per component. Unbounded resource consumption turns one request into an outage.
- [ ] Elevation of privilege: validate authorization on every action and isolate privileged code paths. A single missing check can hand an ordinary user admin power.
- [ ] Assign each identified threat a mitigation, an owner, and a status (accepted, mitigated, transferred). An unowned threat is an unmanaged risk.
- [ ] Re-review the model whenever architecture, trust boundaries, or assets change. A threat model that drifts from reality protects nothing.

## Best practices (source-stamped)

### env-secret-handling

# Environment and Secret Handling

- Store all config and secrets in the environment, never hardcoded in source or committed to git.
- Keep `.env` gitignored; commit a `.env.example` listing every required key with placeholder (non-secret) values.
- Read config from environment variables at startup so the same artifact runs across dev, staging, and prod.
- Fail fast: validate required variables on boot and exit with a clear error if any are missing.
- Rotate secrets through a manager or CI/CD secret store, not by editing checked-in files.
- Never log secret values, and scrub them from error reports and crash dumps.

_source: https://12factor.net/config · 2026-06-14 · confidence: high_

### input-validation

# Input Validation

- Validate all external input at the boundary before it reaches application logic, treating data from clients, APIs, files, and upstream services as untrusted.
- Prefer allowlist (accept known-good) over denylist (block known-bad), since denylists are easily bypassed by unanticipated payloads.
- Use parameterized queries and prepared statements for database access; never build SQL by concatenating user-supplied strings.
- Encode output for the specific context it lands in (HTML, attribute, JavaScript, URL, SQL) to neutralize injection.
- Validate each field for type, length, format, and range, rejecting anything that does not conform to the expected schema.
- Perform validation server-side; client-side checks are a usability aid, not a security control.

_source: https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html · 2026-06-14 · confidence: high_

### test-strategy

# Test Strategy

- Follow the test pyramid: many fast unit tests at the base, fewer integration tests in the middle, and a small number of end-to-end tests at the top.
- Test observable behavior and public contracts, not implementation details, so tests survive refactors instead of breaking on them.
- When fixing a bug, first write a failing test that reproduces it, then make it pass; this proves the fix and guards against regressions.
- Keep tests fast and deterministic: no sleeps, no shared mutable state, no reliance on network, clock, or test ordering.
- Set a coverage floor in CI and ratchet it upward over time so coverage can only improve, never silently regress.

_source: https://martinfowler.com/articles/practical-test-pyramid.html · 2026-06-14 · confidence: medium_

### responsive-layout

# Responsive Layout

- Build layouts with Flexbox: use `flex`, `flexDirection`, `justifyContent`, and `alignItems` instead of fixed pixel positioning so content reflows across screen sizes.
- Prefer `flex` ratios and percentage widths over hardcoded widths so views scale on small phones and large tablets alike.
- Wrap screens in `SafeAreaView` (or `react-native-safe-area-context`) and respect insets so content avoids notches, the status bar, the home indicator, and rounded corners.
- Use density-independent units (dp/pt, the default in React Native) rather than raw pixels; let the platform handle the device pixel ratio.
- Scale typography and spacing from a single source (a spacing/type scale) and honor the user's font-size accessibility setting instead of locking text size.
- Avoid absolute positioning for primary layout; reserve it for overlays and badges.
- Handle orientation and dynamic dimensions with the `useWindowDimensions` hook so layouts recompute on rotation and split-screen.
- Test on multiple sizes and densities: small phone, large phone, tablet, both orientations, and with the OS font scaled up.

_source: https://reactnative.dev/docs/flexbox · 2026-06-14 · confidence: high_

### secure-storage

# Secure Storage

- Never store secrets, tokens, or credentials in plain storage such as `AsyncStorage`, `UserDefaults`, `SharedPreferences`, or plain files; these are not encrypted and are readable on compromised devices.
- Store sensitive values in the platform secure enclave: iOS Keychain and Android Keystore (via libraries like `react-native-keychain` or EncryptedSharedPreferences).
- Do not ship API keys or signing secrets in the app bundle; clients can be decompiled. Keep secrets server-side and fetch short-lived, scoped tokens at runtime.
- Keep PII and secrets out of logs, crash reports, and analytics events; scrub tokens and identifiers before they leave the device.
- Prefer short-lived access tokens with refresh, and clear all cached credentials on logout.
- Encrypt any sensitive data at rest and require TLS (with certificate pinning where feasible) for data in transit.
- Disable autofill/screenshot capture on screens showing sensitive data, and gate access behind device biometrics or passcode where appropriate.
- Follow the OWASP Mobile Top 10 (M1 Improper Credential Usage, M9 Insecure Data Storage) when reviewing storage decisions.

_source: https://owasp.org/www-project-mobile-top-10/ · 2026-06-14 · confidence: high_

### least-privilege

# Least Privilege

- Grant each user, service, and process only the minimum rights required to do its job, and nothing more.
- Default to deny: start from zero permissions and add access deliberately, with justification.
- Scope tokens and credentials narrowly: limit by resource, action, audience, and environment.
- Prefer short-lived, time-boxed access (just-in-time elevation) over standing privileges.
- Separate duties so no single identity can both initiate and approve a sensitive action.
- Use distinct identities per service and per environment; avoid shared or reused accounts.
- Review entitlements regularly and revoke unused or excessive access promptly.
- Remove access immediately on role change or offboarding; rotate exposed credentials.
- Audit privileged actions and alert on use of high-impact permissions.

_source: https://csrc.nist.gov/glossary/term/least_privilege · 2026-06-14 · confidence: high_

### owasp-top10

# OWASP Top 10

- A01 Broken Access Control: enforce server-side authorization, deny by default, and verify object-level ownership on every request.
- A02 Cryptographic Failures: encrypt data in transit and at rest, use strong vetted algorithms, and never roll your own crypto.
- A03 Injection: use parameterized queries and context-aware output encoding; validate input at trust boundaries.
- A04 Insecure Design: threat-model early and apply secure design patterns and reference architectures.
- A05 Security Misconfiguration: harden defaults, disable unused features, and automate consistent, repeatable config.
- A06 Vulnerable and Outdated Components: inventory dependencies (SBOM), scan continuously, and patch on a defined SLA.
- A07 Identification and Authentication Failures: enforce MFA, strong session management, and protection against credential stuffing.
- A08 Software and Data Integrity Failures: verify signatures and integrity of code, dependencies, and CI/CD artifacts.
- A09 Security Logging and Monitoring Failures: log security events, alert on anomalies, and ensure logs are tamper-resistant.
- A10 Server-Side Request Forgery (SSRF): validate and allow-list outbound URLs and isolate metadata/internal endpoints.

_source: https://owasp.org/www-project-top-ten/ · 2026-06-14 · confidence: high_
