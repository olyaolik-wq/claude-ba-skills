---
name: ba-discovery
description: Interactive wizard that runs the project-kickoff Business Analyst pass — stakeholder mapping (power-interest + RACI), elicitation planning per stakeholder group, and a v0.1 domain glossary. Use when starting a BA engagement before any requirements work begins.
origin: user-defined
---

# BA Discovery

This skill runs the first BA pass on a project. It produces the upstream artifact that every other BA skill consumes.

Use it when the user is starting an engagement and needs to map stakeholders, plan how to elicit information from each one, and set the project-wide ID legend that downstream BA artifacts will use.

## When to Use

- A new BA engagement, project, or workstream is starting and no stakeholder register exists yet
- The team knows the problem statement but has not yet figured out who to talk to and how
- A handoff from product to delivery is about to happen and elicitation has not been scoped
- The user wants a single source of truth for project framing, glossary, and stakeholder context

## Inputs

Ask for, in order:

1. Project name and one-line context
2. Business sponsor (decision-maker, budget owner)
3. Problem statement in one paragraph (what hurts, who feels it, what business outcome would change)
4. Known stakeholders — names, roles, or any org-chart snippet the user can share
5. Existing artifacts to ingest (charter, vision deck, prior research) — accept "none"

If the user says "I already have a stakeholder register" or similar, ingest the existing document and skip to the gap-fill phase rather than re-eliciting.

## Wizard Phases

Run these in order. Confirm completion of each phase before advancing.

1. Project frame
   - Restate the problem in one sentence the sponsor would sign off on
   - Capture success criteria: "We will know this worked when ___"
   - Assign an `OBJ-###` ID to each success criterion so downstream skills can link to it
   - Define the ID legend for the whole project (see Non-Negotiable Rules)

2. Stakeholder identification
   - For each stakeholder, capture: name, role, group, primary concern, communication preference
   - Probe for hidden stakeholders: who signs off on budget, who blocks launch, who runs ops after go-live, who has regulatory veto

3. Power-interest scoring and RACI inference
   - Score each stakeholder on power (low/med/high) and interest (low/med/high)
   - Map to Mendelow grid quadrants: Manage Closely, Keep Satisfied, Keep Informed, Monitor
   - Propose a draft RACI for the top three decisions or deliverables in the project. Flag conflicts (e.g. two Accountables)

4. Elicitation technique selection
   - For each stakeholder group, pick the right technique: 1:1 interview, group workshop, survey, observation, document analysis, prototyping session
   - Justify choice based on the group's power/interest, availability, and information type needed

5. Interview guide generation
   - For each interview-bound stakeholder group, generate 6 to 10 open, bias-free questions
   - Cover: context, current pain, desired outcome, constraints, success metrics, blockers
   - Avoid leading questions ("don't you think...") and double-barrelled questions

6. Glossary v0.1 seed
   - Extract domain terms surfaced in the problem statement and stakeholder responses so far
   - For unfamiliar industry terms, call `deep-research` to pull authoritative definitions
   - Mark any term as `[NEEDS CONFIRMATION]` when the meaning is ambiguous

7. Open questions sweep
   - List every assumption, dependency, and unanswered question that would block the next BA skill (`ba-current-state`)
   - Tag each with the stakeholder who can resolve it

## Frameworks Referenced

- BABOK v3 §10 — Elicitation and Collaboration knowledge area
- Mendelow Power-Interest Grid — stakeholder prioritization quadrants
- RACI — Responsible/Accountable/Consulted/Informed responsibility matrix
- 5 Whys — root-cause probing during problem-statement framing
- PMI stakeholder analysis — register schema (role, concern, influence)

## Output Format

Write the artifact to `docs/ba/01-discovery.md` in the active project directory (create the folder if absent). Use this skeleton:

```markdown
# BA Discovery — {Project Name}

## Project Frame
- Problem: ...
- Sponsor: ...
- Success criteria: ...

## ID Legend (project-wide)
- OBJ- Objectives
- ST- Stakeholders
- BR- Business Requirements
- FR- Functional Requirements
- NFR- Non-Functional Requirements
- RULE- Business Rules
- EPIC- Epics
- STORY- User Stories
- AC- Acceptance Criteria
- TEST- UAT Test Scenarios
- CHG- Change Requests

## Stakeholder Register
| ID | Name | Role | Group | Power | Interest | Concern | Comms |
|----|------|------|-------|-------|----------|---------|-------|

## Power-Interest Grid
- Manage Closely: ...
- Keep Satisfied: ...
- Keep Informed: ...
- Monitor: ...

## RACI Matrix (top decisions/deliverables)
| Deliverable | R | A | C | I |
|-------------|---|---|---|---|

## Elicitation Plan
| Group | Technique | Cadence | Goal |
|-------|-----------|---------|------|

## Interview Guide Bank
### {Stakeholder Group}
1. ...

## Domain Glossary v0.1
| Term | Definition | Status |
|------|------------|--------|

## Open Questions
- [ ] {question} — owner: {stakeholder}

## HANDOFF
Next skill: ba-current-state to model the as-is process for {scope}.
Blockers: {list any open questions that must close first}.
```

## Composition

- Reads: any existing charter, vision deck, or prior research the user provides
- Calls: `deep-research` in Phase 6 for unfamiliar industry terminology
- Hands off to: `ba-current-state` (process modeling) once stakeholder register and glossary v0.1 exist
- Sibling skills: `market-research` for competitive context if the project needs external benchmarking

## Non-Negotiable Rules

- Do not invent stakeholders, roles, or RACI assignments. If unknown, mark `[NEEDS CONFIRMATION]` and add to Open Questions.
- Write the ID Legend to `01-discovery.md` exactly as specified above. Every downstream BA skill depends on these prefixes.
- Never produce leading or compound interview questions. Open-ended only.
- Always include the HANDOFF block. A discovery doc without a next action is half-done.
- If the user supplies an existing stakeholder register, ingest it; do not duplicate the work.
