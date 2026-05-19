---
name: ba-stories
description: Interactive wizard that converts functional requirements into INVEST-quality user stories with Gherkin Given-When-Then acceptance criteria reusable as UAT scenarios. Use during delivery prep, sprint planning, or backlog refinement.
origin: user-defined
---

# BA Stories

This skill turns functional requirements into delivery-ready user stories with acceptance criteria the dev team can implement against and QA/UAT can verify against.

Use it once `ba-requirements` has produced FRs and business rules, when the team is preparing to enter delivery. The output is the source of truth for sprint planning and the seed for UAT scenarios.

## When to Use

- A requirements document exists with FRs and rules, and the team needs sprint-ready stories
- Backlog has prose tickets that lack INVEST quality and need rework
- A sprint planning session is upcoming and acceptance criteria are missing or vague
- UAT planning is starting and no test scenarios are mapped to requirements yet

## Inputs

Ask for, in order:

1. Confirm `docs/ba/03-requirements.md` exists and read FRs, RULES, and personas referenced
2. Capability or epic scope (which capabilities from the requirements doc are in this batch)
3. Any existing backlog items the user wants converted instead of starting from FRs
4. Personas: who are the actors? (Pull from `01-discovery.md` stakeholder register or PM persona artifacts)

If the user already has draft stories, ingest them and run phases 4 through 8 (INVEST review and AC generation).

## Wizard Phases

1. Group FRs into epics
   - Cluster related FRs under each capability into one or more epics
   - Assign `EPIC-###` IDs. Each epic links to one or more BR-### (parent goal)

2. Identify story personas and value statements
   - For each upcoming story, name the persona (who) and the desired outcome (so that)
   - If a relevant persona is missing, note it and recommend escalating to user research before continuing

3. Draft Connextra-format stories
   - Format: "As a {persona}, I want {capability}, so that {outcome}."
   - Assign `STORY-###` IDs. Link each story to its parent EPIC-### and source FR-###
   - One story = one slice of user-visible value, not one technical task

4. INVEST review and split fat stories
   - Independent: minimal coupling to other stories
   - Negotiable: not over-specified, leaves implementation choice open
   - Valuable: ties to a real outcome
   - Estimable: enough detail for the team to size
   - Small: fits in a sprint (or smaller)
   - Testable: has measurable acceptance criteria
   - Split any story that fails INVEST. Common splits: by workflow step, by data variant, by happy path vs edge case, by interface (UI vs API)

5. Write happy-path Gherkin acceptance criteria
   - Format:
     ```gherkin
     Given {precondition}
     When {action}
     Then {observable result}
     ```
   - Assign `AC-###` IDs. Link each AC to its STORY-###
   - One scenario per AC. Multiple ACs per story are normal.

6. Add edge and negative scenarios
   - For each happy-path AC, ask: what breaks this? what if input is bad? what if a precondition fails?
   - Cover at minimum: invalid input, missing permission, network/timeout failure, business rule rejection (from `03-requirements.md` RULE-###)
   - Tag each AC as `Type: happy | edge | negative`

7. Map AC to UAT scenario IDs
   - Every AC becomes a candidate UAT scenario. Assign `TEST-###` IDs
   - Note which ACs are automation-friendly (deterministic, no manual judgement) vs which need human UAT (subjective, visual, workflow-spanning)

8. Definition of Done checklist
   - Story-level DoD covering: code merged, tests written, AC verified, docs updated, accessibility passed, no open security findings
   - Project-wide DoD additions captured here too (e.g. "telemetry event emitted", "feature flag wired")

## Frameworks Referenced

- Connextra story format — "As a {persona}, I want {capability}, so that {outcome}"
- INVEST — Independent, Negotiable, Valuable, Estimable, Small, Testable
- Gherkin (Cucumber) — Given-When-Then scenario notation
- Example Mapping — pulling rules, examples, and questions out of stories
- BDD three amigos — collaborative AC refinement (BA + dev + tester)

## Output Format

Write the artifact to `docs/ba/04-stories.md`. Use this skeleton:

```markdown
# Stories — {Project Name}

## Epics
| EPIC-ID | Name | BR Link | Notes |
|---------|------|---------|-------|

## Stories
### EPIC-001: {epic name}
| STORY-ID | Persona | I want | So that | FR Link | MoSCoW | INVEST Score |
|----------|---------|--------|---------|---------|--------|--------------|

## Acceptance Criteria
### STORY-001: {story summary}
- **AC-001** (Type: happy)
  ```gherkin
  Given ...
  When ...
  Then ...
  ```
- **AC-002** (Type: edge)
  ```gherkin
  ...
  ```
- **AC-003** (Type: negative)
  ```gherkin
  ...
  ```

## UAT Scenario Index
| TEST-ID | AC Link | STORY Link | Automation-Friendly? | Notes |
|---------|---------|------------|----------------------|-------|

## Definition of Done
- [ ] Code merged to main
- [ ] Unit + integration tests written and green
- [ ] All AC verified
- [ ] Docs updated (user-facing and dev-facing)
- [ ] Accessibility check passed (WCAG level from NFRs)
- [ ] No open security findings
- [ ] Telemetry events emitted (if applicable)

## Out of Scope (this batch)
- ...

## HANDOFF
Next skill: ba-traceability to build the RTM linking BR -> FR -> STORY -> AC -> TEST and to run impact analysis on any proposed changes.
Blockers: {list any stories still flagged as fat or missing AC}.
```

## Composition

- Reads: `docs/ba/03-requirements.md` (FRs and RULES), `docs/ba/01-discovery.md` (personas/stakeholders)
- Hands off to: `ba-traceability` for RTM and impact analysis
- Sibling: `product-capability` if a story crosses services and needs an engineering capability contract

## Non-Negotiable Rules

- Every story must link to at least one FR-###. Orphan stories are not allowed.
- Every story must have at least one happy-path AC, one edge AC, and one negative AC unless explicitly N/A.
- AC must be in Gherkin (Given/When/Then). Free-prose AC is not allowed.
- INVEST violations require a split before exiting Phase 4. Do not advance with fat stories.
- Always end with HANDOFF naming `ba-traceability` and listing blockers.
