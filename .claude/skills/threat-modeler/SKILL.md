---
name: threat-modeler
description: Load when asked to threat model a feature, system, or architecture using STRIDE and enumerate mitigations. Triggers on "threat model this", "STRIDE", "what could go wrong security-wise", "attack surface", "security design review", "abuse cases".
allowed-tools: [Read, Edit, Bash, Grep, Glob]
---

# Threat Modeler

## Purpose
Run a STRIDE threat model over a feature or system: map the architecture and
trust boundaries, enumerate threats per element, rate them, and emit a ranked
list of concrete mitigations with owners.

## When to use
- "threat model this feature/service/architecture"
- "run STRIDE on this" / "what are the attack vectors here"
- "map the attack surface" / "what's our trust boundary"
- Security design review before building or shipping a new component.
- A data-flow or new external interface is being introduced.

## Procedure
1. Establish scope. Identify the feature/system, its assets (data, secrets,
   funds, identity), and the entry points (APIs, UIs, queues, files).
2. Build the model. List external entities, processes, data stores, and data
   flows; draw trust boundaries (network, process, privilege) between them.
   Read code/config with Grep/Glob to ground the model in reality.
3. Apply STRIDE to each element and flow: Spoofing, Tampering, Repudiation,
   Information disclosure, Denial of service, Elevation of privilege.
4. For each threat, state the attacker, the entry point, the impacted asset,
   and the resulting harm. Write concrete abuse cases, not generic labels.
5. Rate each threat (likelihood x impact -> CRITICAL/HIGH/MEDIUM/LOW); note
   existing controls that already reduce it.
6. Propose a mitigation per threat (authn, authz, validation, crypto, rate
   limit, logging, isolation) with an owner and a residual-risk note.
7. Emit the structured threat model (format below). Do not change code unless
   the user explicitly asks.

## Output format
```
## Scope & Assets
- System, assets, entry points, trust boundaries

## Threats (STRIDE)
| ID | Element | STRIDE | Abuse case | Likelihood x Impact | Rating |

## Mitigations
1. [ID] mitigation — owner — residual risk

## Top risks
- Ranked CRITICAL/HIGH items needing action before ship
```

## Checklist
- [ ] Assets, entry points, and trust boundaries identified
- [ ] Every element/flow assessed against all six STRIDE categories
- [ ] Each threat names attacker, entry point, asset, and harm (concrete)
- [ ] Each threat rated by likelihood x impact
- [ ] Each threat has a specific mitigation with an owner
- [ ] Top risks ranked with ship/no-ship implication
- [ ] No code changed unless fixes were explicitly requested
