---
name: ba-current-state
description: Interactive wizard for as-is and to-be process modeling in BPMN-style swimlane text, capturing actors, systems, pain points, data flows, and a gap-analysis table. Use after ba-discovery when documenting how work flows today and how it should flow tomorrow.
origin: user-defined
---

# BA Current State

This skill turns vague "this process is broken" complaints into an explicit as-is map, a to-be map, and the delta between them.

Use it once `ba-discovery` has produced a stakeholder register and glossary, and the user can name a specific process to model.

## When to Use

- A specific business process is in scope and needs to be documented before requirements are written
- Pain points are anecdotal ("this part is slow") but not tied to a step
- The same process runs differently across teams and you need one canonical map
- The user is comparing options (e.g. automate step X vs redesign upstream) and needs the delta visible

## Inputs

Ask for, in order:

1. Process name and scope (start trigger, end state)
2. Any existing SOP, screen captures, or recorded walkthrough
3. Confirm `docs/ba/01-discovery.md` exists and read the glossary plus stakeholder register
4. Which stakeholders performed each step (use IDs from discovery)

If the user says "I already mapped the as-is in {file}", ingest it and skip to phase 4.

## Wizard Phases

1. Scope and trigger event
   - Pin down: what event starts this process, what event ends it, what counts as "in scope"
   - Capture the business outcome the process produces (one sentence)

2. Actors and systems per lane
   - One swimlane per actor (human role or system)
   - List each lane explicitly. Group external parties into a single "External" lane unless the user needs more granularity

3. Walk the as-is steps
   - For each step capture: Step ID, Actor, Lane, Task description, decision gateway (if any), Output
   - Use text BPMN notation: `[Actor] does X --> <gateway: condition?> --> Y/Z`
   - Decision gateways branch into Yes/No or condition-based paths. Capture both

4. Pain point tagging
   - For each step, ask: is anything painful here? slow, error-prone, manual rework, hand-off friction, compliance risk
   - Tag with severity (L/M/H) and frequency (L/M/H). Severity x Frequency = priority
   - Trace each pain back to the responsible stakeholder group from `01-discovery.md`

5. Data flow capture
   - For each step capture: data inputs (where does it come from), data outputs (where does it go), system of record
   - Flag steps that read or write PII, financial data, or anything regulated

6. To-be process design
   - Ask: which pains must this redesign solve? Use priority from Phase 4
   - Walk the to-be steps the same way as as-is. Same notation
   - Mark steps as: unchanged, modified, new, removed

7. Gap analysis table
   - Row per step: As-Is, To-Be, Delta, Owner, Notes
   - Capture explicit assumptions and dependencies that the to-be relies on

## Frameworks Referenced

- BPMN 2.0 — text-rendered swimlane notation (pools, lanes, tasks, gateways)
- SIPOC — Suppliers/Inputs/Process/Outputs/Customers framing for scope
- Value-stream pain tagging — severity x frequency prioritization
- As-Is / To-Be / Delta — standard gap analysis structure
- Lean waste types — TIMWOODS (Transport, Inventory, Motion, Waiting, Overproduction, Overprocessing, Defects, Skills) for pain classification

## Output Format

Write the artifact to `docs/ba/02-process-{name}.md` in the active project directory. Use this skeleton:

```markdown
# Process Map — {Process Name}

## Scope
- Start trigger: ...
- End state: ...
- Business outcome: ...

## Actors and Systems (Lanes)
| Lane | Actor / System | Stakeholder ID |
|------|----------------|----------------|

## As-Is Swimlane (text BPMN)
1. [Actor] does X --> Y
2. [Actor] does Z --> <gateway: condition?> --> A | B
...

## Pain Point Heatmap
| Step # | Pain | Severity | Frequency | Priority | Owner (from 01-discovery) |
|--------|------|----------|-----------|----------|---------------------------|

## Data Touchpoints
| Step # | Input | Output | System of Record | Regulated? |
|--------|-------|--------|------------------|------------|

## To-Be Swimlane (text BPMN)
1. [Actor] does X' --> Y'
...

## Gap Analysis
| Step # | As-Is | To-Be | Delta | Owner | Notes |
|--------|-------|-------|-------|-------|-------|

## Assumptions and Dependencies
- {assumption} — risk if invalid: ...
- {dependency} — owner: ...

## HANDOFF
Next skill: ba-requirements to translate pain points and to-be steps into BRD/FRD/NFR.
Blockers: {list any assumptions that must be validated first}.
```

## Composition

- Reads: `docs/ba/01-discovery.md` (stakeholder register + glossary + ID legend)
- Hands off to: `ba-requirements` with pain points and to-be steps as primary input
- Sibling: `product-capability` can be invoked separately when an individual to-be step crosses services and needs an engineering contract

## Non-Negotiable Rules

- Do not invent steps or actors. If the user is unsure, mark `[NEEDS WALKTHROUGH]` and add to Assumptions.
- Use text-BPMN notation consistently. Never substitute prose narration for `[Actor] does X --> Y` lines.
- Every pain point must reference a stakeholder ID from `01-discovery.md`. Untraceable pains are not allowed.
- Every to-be step that solves a pain must reference the pain's row number in Phase 4.
- Do not forward-reference downstream IDs (FR-###, NFR-###, RULE-###, STORY-###, etc.) that do not exist yet. In the Gap Analysis Notes column, use plain descriptions or `[FR-CANDIDATE: short name]` placeholders if a future requirement is implied. `ba-requirements` will assign real IDs in the next pass.
- Always end with HANDOFF naming `ba-requirements` and listing blockers.
