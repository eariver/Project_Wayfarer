# Frontier Order 8 Formal Lock

## Summary

| Item | Result |
| --- | --- |
| Date | 2026-07-26 |
| Pre-execution HEAD | `98fb482cb1a3b5103a85b02684dcb77ddb7b27e5` |
| Implementation Commit | `201681ea026936909558839bc4445d9ccb7be567` |
| Archive Commit | `ebb100afce96cd467e4e4de93b039c3e8ecaf77a` |
| Post-lock clarification | `fe16ca6c6200732ee4b1960126ecb8f5dcb96795` |
| Proposal | `FRONTIER-LOCK-20260726-003` |
| Approval | Exact Token received |
| Phase B | Completed as documentation／Lock data only |
| Order 8 | Complete |
| Runtime validation | Deferred |
| Runtime change | None |

The User sent:

```text
APPROVE-WAYFARER-FRONTIER-LOCK:FRONTIER-LOCK-20260726-003
```

The Token exactly matched the current Revision 003 Reserved Token. Proposal 001 was
superseded; Proposal 002 was `superseded-before-approval` and its Token was never
executed.

## Phase B result

The authoritative contract is [Frontier Runtime Lock](../15-frontier-runtime-lock.md).
The four Proposal 003 candidate YAML files were promoted by Git moves to formal Lock
files, preserving their content history. A fifth persistence-authority Lock was added:

```text
config/frontier-lock/artifact-lock.yml
config/frontier-lock/world-id-lock.yml
config/frontier-lock/runtime-boundary-lock.yml
config/frontier-lock/resource-pack-input-lock.yml
config/frontier-lock/persistence-authority-lock.yml
```

Every Lock records:

```text
proposal_id: FRONTIER-LOCK-20260726-003
phase_b: complete
approval_token_received: true
status: locked
runtime_validation: deferred
```

Proposal and Artifact evidence remain in the
[Preflight Report](2026-07-26-frontier-order8-lock-preflight.md) and the
[Revision 003 Resync Report](2026-07-26-plugin-scope-and-frontier-lock-revision003-resync.md).

## Approved boundaries

- Worlds Beyond is the single persistent Iris Overworld `frontier_iris`.
- Worlds Beyond has no Nether／End World, MNP link or fallback.
- Ruined Frontier retains `frontier_bs`, `frontier_bs_nether` and
  `frontier_bs_the_end` with Ruined-only MNP 5.0.5 links.
- MVI groups are `neutral`, `worlds_beyond` and `guild`; MVI is the sole normal
  Frontier Player State authority.
- Advanced Portals 2.8.0 is the Gate method, subject to Order 12 Runtime enablement and
  Order 17 exact routes.
- Iris 3.9.2 plus the locked Overworld Pack is the Worlds Beyond generator input.
- EliteMobs 10.7.3, the approved free／user-owned Content set, BetterStructures 2.6.3,
  FMM 2.10.2, RPM 2.3.0 and LeafGrapple 1.0.2 are locked for their exact scopes.
- BetterHealthBar3 4.1.0 is an adoption-test candidate, not yet Runtime accepted.
- Frontier history／rollback product remains unselected; CoreProtect 24.0 is only a
  known Artifact candidate.
- One external Gradle Multi-module Repository will contain required Core／Main／Frontier
  modules. Wayfarer_Main remains Main-only.
- `Wayfarer_Frontier_EliteMobsMVI` remains an independent conditional Artifact only if
  Order 13 returns `ADAPTER_REQUIRED`.

Artifact versions, official sources, licenses and the 25 existing SHA-256 entries were
carried forward unchanged from Proposal 003.

## Commit provenance

The formal Lock implementation is:

```text
201681ea026936909558839bc4445d9ccb7be567
docs: Frontier V0.1.0 Runtime Lockを確定
```

The Codex Archive record is:

```text
ebb100afce96cd467e4e4de93b039c3e8ecaf77a
docs: Frontier Lock Commitを記録
```

The post-lock clarification is:

```text
fe16ca6c6200732ee4b1960126ecb8f5dcb96795
docs: Frontier Lockの配置とLifecycle境界を明確化
```

The clarification records that CoreProtect remains unselected and unplaced, and that
`frontier_bs`, `frontier_bs_nether`, and `frontier_bs_the_end` are persistent,
lifecycle-managed Worlds. It did not change any Artifact version, SHA-256, World ID,
Gate method, Pack input, MVI authority, or approved scope.

## Approved exception

Adventurer's Guild exact Artifact remains deferred. Its official link is exposed only by
the official EliteMobs `/em setup` flow. Order 12／13 may reach that flow, but the User
must manually acquire the Artifact. Runtime import is blocked until Version, filename,
license and SHA-256 are verified. An incompatible result requires a new Lock Revision.

## Phase B non-runtime proof

No server process was started and no executable artifact was downloaded, copied or
installed. Phase B did not change:

- `servers/main/`, `servers/frontier/`, `servers/lobby/` or `velocity/`;
- Worlds, Multiverse registration, MVI profiles or Portal links;
- MariaDB, Redis, LuckPerms or Player Data;
- Runtime Plugin Config, generated Resource Packs or protected Ports.

Only Markdown and YAML source-of-truth files changed. JAR, ZIP, premium Content, Worlds,
Logs, Cache, Database data and Secrets remained untracked／ignored.

## Deferred work

Order 8 formalizes the contract but does not prove Runtime compatibility. The next
Roadmap work is Order 9: the external Plugin Repository foundation and Wayfarer_Core.
Orders 10／11 may follow the approved Core contract, then Order 12 installs and validates
the Frontier shared foundation.
