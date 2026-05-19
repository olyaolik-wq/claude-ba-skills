---
name: ba-traceability
description: Interactive wizard that builds the Requirements Traceability Matrix (BR -> FR -> Story -> AC -> Test -> Change), runs impact analysis on proposed changes, and produces a transition/launch plan with comms cadence and training outline. Use at end of analysis phase and before launch.
origin: user-defined
---

# BA Traceability

This skill is the glue artifact. It proves that every business requirement is delivered, every story is justified, and every change has been impact-assessed before it ships. It also defines how the change will be transitioned to the people who must adopt it.

Use it once `ba-discovery`, `ba-current-state`, `ba-requirements`, and `ba-stories` have produced their artifacts, OR when an in-flight change request needs impact assessment against an existing baseline.

## When to Use

- All upstream BA artifacts (01-04) exist and the team needs a single coverage view before sign-off
- A change request has been raised mid-project and needs structured impact analysis
- A launch is approaching and the transition plan (comms, training, cutover) has not been written
- An audit, compliance review, or governance gate requires traceability evidence

## Inputs

Ask for, in order:

1. Confirm `docs/ba/01-discovery.md`, `02-process-*.md`, `03-requirements.md`, `04-stories.md` all exist
2. Any change requests under consideration (free text or existing CHG-### list)
3. Target launch or go-live date
4. Affected stakeholder segments (use the register from `01-discovery.md`)

If the user has an existing RTM, ingest it and run phases 3 through 8 as a delta pass.

## Wizard Phases

1. Index all IDs
   - Sweep `01` to `04` artifacts and collect every OBJ-, BR-, FR-, NFR-, RULE-, EPIC-, STORY-, AC-, TEST- ID
   - Build the master index. Flag any duplicates as `[ID COLLISION]`

2. Build forward and backward links
   - For each ID, capture its parents (what it traces from) and children (what traces from it)
   - Confirm the full chain: OBJ <- BR <- FR <- STORY <- AC <- TEST
   - NFRs link to FRs they constrain; RULEs link to FRs they govern

3. Flag coverage gaps and orphans
   - Gap: a parent ID with no children. Example: a BR with no FRs implementing it
   - Orphan: a child ID with no parent. Example: a STORY with no FR
   - For each gap or orphan, decide: close the gap, accept the orphan with rationale, or drop the item

4. Walk proposed changes through impact analysis
   - For each CHG-### capture: description, source (stakeholder), scope (which IDs it touches)
   - Cascade: a change to an FR likely impacts STORIES, ACs, TESTS, and possibly RULES and NFRs
   - Score impact: Severity (L/M/H) and Effort (S/M/L/XL). Severity x Effort drives the recommendation (do now / defer / reject)

5. Identify affected stakeholder segments
   - For each CHG and the to-be process from `02`, list which stakeholder groups are affected and how
   - Categorize impact: workflow change, tool change, role change, decision-authority change, training need

6. Draft comms cadence
   - Phases: pre-launch awareness, launch readiness, cutover, post-launch reinforcement
   - For each phase capture: audience, channel, message, owner, timing
   - Use ADKAR for message framing per phase: Awareness, Desire, Knowledge, Ability, Reinforcement

7. Training and enablement outline
   - For each affected role: what they need to know, how they will learn (doc, video, workshop, shadowing), who delivers it, success measure
   - Tag content by ADKAR phase

8. Launch and rollback checklist
   - Cutover steps in order with owners and timings
   - Go/No-go criteria with hard thresholds
   - Rollback procedure: trigger conditions, steps, comms script
   - Post-launch monitoring window with metrics from `03-requirements.md` (success metrics)

## Frameworks Referenced

- IEEE 730 — RTM and traceability practice
- PROSCI ADKAR — Awareness, Desire, Knowledge, Ability, Reinforcement model for change adoption
- Kotter 8-step — change management (urgency, coalition, vision, communication, empowerment, wins, momentum, anchoring)
- CYNEFIN — complexity-aware cutover risk classification (clear, complicated, complex, chaotic)
- Risk matrix — severity x effort scoring for changes

## Output Format

Write the artifact to `docs/ba/05-traceability.md`. Use this skeleton:

```markdown
# Traceability and Transition — {Project Name}

## Master ID Index
{count of each ID type and any duplicates flagged}

## Requirements Traceability Matrix
| BR-ID | FR-ID | NFR-IDs | RULE-IDs | STORY-ID | AC-IDs | TEST-IDs | Status |
|-------|-------|---------|----------|----------|--------|----------|--------|

## Coverage Gaps
| Parent ID | Type | Gap (no children of type) | Decision |
|-----------|------|---------------------------|----------|

## Orphan Items
| Child ID | Type | Reason (no parent) | Decision |
|----------|------|---------------------|----------|

## Impact Analysis
### CHG-001: {summary}
- Source: ...
- Description: ...
- Affected IDs: BR-..., FR-..., STORY-..., RULE-...
- Severity: L/M/H
- Effort: S/M/L/XL
- Recommendation: do now | defer to {release} | reject
- Stakeholder comms: ...

## Affected Stakeholder Segments
| Stakeholder Group | Impact Type | Magnitude | Notes |
|-------------------|-------------|-----------|-------|

## Transition Plan
### Phase: Pre-launch awareness
| Audience | Channel | Message | Owner | Timing |
|----------|---------|---------|-------|--------|

### Phase: Launch readiness
...

### Phase: Cutover
...

### Phase: Post-launch reinforcement
...

## Training and Enablement
| Role | What They Need to Know | Format | Delivered By | Success Measure | ADKAR Phase |
|------|------------------------|--------|--------------|------------------|-------------|

## Launch and Rollback
### Cutover Steps
1. {step} — owner: ... — at: T-...
2. ...

### Go / No-Go Criteria
- [ ] {criterion} — threshold: ...

### Rollback Procedure
- Trigger conditions: ...
- Steps: ...
- Comms script: ...

### Post-launch Monitoring
- Metric: ... (from 03-requirements.md success metrics)
- Window: ... after go-live
- Owner: ...

## HANDOFF
This is the final BA-suite artifact for this scope. Open follow-ups:
- {item} — owner: ...
- {item} — owner: ...
```

## Composition

- Reads: `docs/ba/01-discovery.md`, `02-process-*.md`, `03-requirements.md`, `04-stories.md`
- Sibling: `product-capability` for engineering-side change contracts on impactful CHGs
- Sibling: `market-research` if a launch requires competitive timing checks
- Hands off to: ops / project management. This is the terminal BA-suite artifact for an engagement.

## Non-Negotiable Rules

- The RTM must cover every ID found in upstream artifacts. Missing rows are not allowed unless flagged in Coverage Gaps with a decision.
- Every CHG must have severity, effort, and a recommendation. No "TBD" recommendations.
- The transition plan must cover all four ADKAR phases. Skipping a phase requires explicit justification.
- Rollback procedure must include trigger conditions and a comms script. "We'll figure it out" is not a rollback plan.
- The output is the source of truth for governance and audit. Treat it as durable. Do not delete superseded rows; mark them `Status: superseded by CHG-###` instead.
