---
name: ba-prioritization
description: Interactive wizard for deep backlog prioritization using RICE, Kano, weighted scoring, or WSJF — when MoSCoW alone is too crude (typically backlogs of 30+ items or contested release sequencing). Produces ranked scoring sheets with rationale, decisions, and dissents. Use when MoSCoW collapses to "everything is Must" or stakeholders disagree on what ships first.
origin: user-defined
---

# BA Prioritization

This skill runs a structured, framework-driven prioritization pass on a backlog (FRs, stories, epics, or change requests). It produces an auditable ranking with scores, evidence, and a decision log — the artifact you can show a steering committee when someone asks "why is this above that?"

Use it after `ba-requirements` (or `ba-stories`) when the inline MoSCoW pass has stopped discriminating — typically when the backlog has 30+ items, when everything has drifted to "Must", or when release sequencing is contested. This skill is for **backlog items with existing IDs**, not raw ideas (use `product-lens` ICE for those).

## When to Use

- Backlog has 30+ items and MoSCoW has collapsed (>60% marked Must)
- Stakeholders dispute release sequencing and need a neutral framework
- A release-planning, roadmap, or quarterly-planning session is upcoming and the team needs ranked input
- A new wave of change requests has landed and the backlog needs re-ranking against the existing baseline

## Inputs

Ask for, in order:

1. Confirm `docs/ba/03-requirements.md` exists (read FRs + current MoSCoW); confirm `docs/ba/04-stories.md` exists if stories are in scope
2. What is being prioritized? FRs, EPICs, STORYs, CHGs, or a mix (one type per scoring pass — do not mix FRs and stories in the same score)
3. Decision horizon: next sprint, next release, next quarter, next year
4. Hard constraints: capacity (person-weeks), deadline (date), budget, regulatory cutoff
5. Who decides? Name the decision-maker. Name the consulted group. Name who has a dissent vote
6. If `docs/ba/01a-research-synthesis.md` exists, read its `INS-###` insights and `JOB-###` Importance/Satisfaction signals — they feed Opportunity Scoring

If the user supplies an existing scoring sheet, ingest it and run phases 4 through 8 as a re-rank pass against new evidence.

## Wizard Phases

1. Scope and decision context
   - List every item to be scored with its source ID (FR-###, STORY-###, EPIC-###, CHG-###)
   - Restate the constraint in one sentence ("Pick what ships by 2026-09-30 with 4 engineers")
   - Identify items already locked in by regulation, contract, or sunk-cost commitment — pull them out of scoring and into a "Locked" list

2. Choose the framework (with rationale)
   - **RICE** — product roadmap items where you can estimate reach (users/month) and effort. Best for outward-facing features
   - **Kano** — when you need to separate "must-have basics" from "wow factors" and avoid investing in indifferent features
   - **Weighted scoring** — context with multiple competing criteria (revenue, strategic fit, risk, compliance) that need explicit weights
   - **WSJF** — release sequencing inside a fixed capacity (SAFe). Best when "what do we do first" matters more than "do we do it at all"
   - **Opportunity Scoring** (Ulwick) — when `ba-research-synthesis` has surfaced Importance vs Satisfaction gaps from JOBs
   - Document which framework was picked and why. If two frameworks are layered (e.g., Kano category + RICE rank within category), document the layering rule

3. Define the scoring scales
   - For RICE: Reach unit (users/month, % of users, sessions); Impact scale (0.25 minimal / 0.5 low / 1 medium / 2 high / 3 massive); Confidence (50% low / 80% medium / 100% high); Effort in person-weeks
   - For Kano: assignment criteria for Basic / Performance / Excitement / Indifferent / Reverse — backed by survey or research evidence (not gut)
   - For Weighted scoring: define 3-7 criteria with weights summing to 100%; define a 1-5 anchor scale per criterion (1 = no impact, 5 = transformational)
   - For WSJF: Business Value, Time Criticality, Risk Reduction/Opportunity Enablement each on a Fibonacci scale (1/2/3/5/8/13); Job Size also Fibonacci
   - For Opportunity Scoring: Importance and Satisfaction each 1-10; Opportunity = Importance + max(Importance − Satisfaction, 0)
   - Reject "high/medium/low" without anchor definitions — every level must have a concrete description

4. Score each item against the scale
   - For each item, walk the scoring inputs. Capture evidence (research source, data point, expert estimate) per score
   - Mark scores with no evidence as `[ASSUMPTION]` and add to the decision log for explicit confirmation
   - When the team cannot reach agreement on a score, capture both numbers and the rationale gap — do not average to silence dissent

5. Calculate, rank, and visualize
   - Compute the framework score per item (formula below per framework). Rank descending
   - Show top 10, bottom 10, and any clusters (items with effectively-tied scores within noise threshold)
   - For Kano: present as a 2×2 (Functional satisfaction vs Dysfunctional) with category overlays
   - For RICE/WSJF/Weighted: present as ranked table with score breakdown columns

6. Sanity checks and re-scoring triggers
   - Top 10% gut-check: do these feel right to the decider? If not, the scale is wrong — debug which input is mis-calibrated, do not just override the score
   - Bottom 10% review: would dropping these change the business case? If not, archive them and remove from future scoring
   - Confidence floor: any RICE item with Confidence < 80%, or any score relying on `[ASSUMPTION]`, requires validation work before commitment
   - Capacity check: cumulative Effort of "in" items must fit the capacity constraint from phase 1

7. Map ranks back to MoSCoW and release windows
   - Cut lines: top tranche → Must, next → Should, next → Could, bottom → Won't (this release)
   - Allocate "in" items to sprint/release windows respecting dependencies (item A must ship before item B) and bundles (similar effort, ship together)
   - Recommend updating `docs/ba/03-requirements.md` MoSCoW column with `[see PRI-### / Framework / date]` reference back to this artifact

8. Decisions, dissents, and review cadence
   - Capture the decider, the consulted group, and any explicit dissents (who, on which item, why)
   - Set re-prioritization cadence: every sprint, every release, every quarter
   - List re-prioritization triggers: new evidence (research/market data), capacity change (team grew/shrank), regulatory shift, major customer escalation, competitive launch

## Frameworks Referenced

- RICE (Intercom) — `(Reach × Impact × Confidence) / Effort`. Best for product-roadmap triage
- Kano model (Noriaki Kano) — Basic / Performance / Excitement / Indifferent / Reverse categorization via functional + dysfunctional question pair
- Weighted Scoring / Multi-Criteria Decision Analysis — `Σ (criterion_score × weight)` with weights summing to 100%
- WSJF (SAFe) — `(Business Value + Time Criticality + Risk Reduction) / Job Size`, all on Fibonacci. Best for sequencing inside fixed capacity
- Cost of Delay — financial framing for what is lost by waiting; input to WSJF
- Opportunity Scoring (Anthony Ulwick / JTBD) — `Importance + max(Importance − Satisfaction, 0)`, scored 1-10
- Value vs Effort 2×2 matrix — quick visual triage for small backlogs (<20 items)

## Output Format

Write the artifact to `docs/ba/06-prioritization-{pass}.md` where `{pass}` is the scoring exercise label (e.g. `q3-2026`, `release-2.5`). Multiple files accumulate over time; do not overwrite prior passes. Use this skeleton:

```markdown
# Prioritization — {Project Name} — Pass {label}

## Session
- PRI-ID: PRI-### (this pass)
- Date: YYYY-MM-DD
- Decider: ...
- Consulted: ...
- Dissent votes: ...

## ID Legend Extension
This skill extends the project ID legend with:
- PRI- Prioritization session records (one per scoring exercise; multiple files accumulate over time)

## Scope
- Items being scored (type): FRs | STORYs | EPICs | CHGs
- Item IDs in scope: ...
- Decision horizon: ...
- Hard constraint: ...
- Locked items (excluded from scoring): ...

## Framework Choice
- Framework: RICE | Kano | Weighted | WSJF | Opportunity | Layered ({A} then {B})
- Why this framework: ...
- Why not the alternatives: ...

## Scoring Scales (defined per framework chosen)
- {Input}: {scale} — {anchor for each level}
- {Input}: {scale} — {anchor for each level}

## Scored Items
| Item ID | Title | {Score columns per framework} | Composite Score | Rank | Evidence / [ASSUMPTION] |
|---------|-------|-------------------------------|-----------------|------|--------------------------|

## Sanity Checks
- Top 10% gut-check: pass | flagged ({which item, why})
- Bottom 10% archive candidates: ...
- Confidence floor violations (need validation): ...
- Capacity check: cumulative Effort of "in" items = {N} vs constraint {M} — fits | over by {delta}

## MoSCoW Mapping
| Rank Range | MoSCoW Tier | Item IDs |
|------------|-------------|----------|
| 1 - N      | Must        | ...      |
| N+1 - M    | Should      | ...      |
| M+1 - K    | Could       | ...      |
| K+1 - end  | Won't (this release) | ...      |

## Release / Sprint Allocation
| Window | Item IDs | Total Effort | Dependencies / Bundles |
|--------|----------|--------------|-------------------------|

## Decision Log
| Item ID | Decision | Decider | Dissents (who / why) | Notes |
|---------|----------|---------|-----------------------|-------|

## Re-prioritization
- Cadence: every {sprint | release | quarter}
- Triggers: new research, capacity change, regulatory shift, customer escalation, competitive launch
- Next scheduled review: YYYY-MM-DD

## HANDOFF
Next skill: ba-traceability to update the RTM with new MoSCoW tiers and to record this PRI-### in any impacted CHG impact analyses.
Update: ba-requirements MoSCoW column in 03-requirements.md to reference this PRI-### / framework / date.
Sibling: product-lens (ICE) for upstream idea validation before items enter this backlog.
Blockers: {list any [ASSUMPTION] scores or confidence-floor violations that should be validated before items move to "in"}.
```

## Composition

- Reads: `docs/ba/03-requirements.md` (FRs + current MoSCoW), `docs/ba/04-stories.md` (stories), optionally `docs/ba/05-traceability.md` (CHGs), `docs/ba/01a-research-synthesis.md` (JOBs and INSights for Opportunity Scoring)
- Hands off to: `ba-traceability` for RTM MoSCoW updates; recommends updating `ba-requirements`'s MoSCoW column with a `[see PRI-### / framework / date]` back-reference
- Sibling: `product-lens` (ICE) — different scope. `product-lens` scores raw ideas pre-backlog; `ba-prioritization` ranks backlog items that already have IDs

## Non-Negotiable Rules

- Pick ONE primary framework per scoring pass and document why. Mixing frameworks without a layering rule is "scoring theater" and is rejected.
- Every score must cite evidence (research, data, named expert estimate) or be marked `[ASSUMPTION]`. Unsourced "feels high" scores are rejected.
- Every scoring scale must define concrete anchors per level. Free-form "high/medium/low" without anchor definitions is rejected.
- Confidence ratings below 80% (RICE) or any `[ASSUMPTION]` score on a "Must"-tier item require validation work before commitment. Add to Blockers.
- Capture decider, consulted group, and dissents by name. Anonymous prioritization is rejected.
- Do not overwrite prior PRI-### passes. Each scoring exercise gets its own `06-prioritization-{pass}.md` file so the history is auditable.
- Always end with HANDOFF naming `ba-traceability` and listing `[ASSUMPTION]`/low-confidence items as blockers.
