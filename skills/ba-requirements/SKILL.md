---
name: ba-requirements
description: Interactive wizard that produces a layered BRD + FRD + NFR + business-rules catalog with MoSCoW classification, using EARS notation where appropriate. Use to consolidate everything elicited so far into the central requirements artifact.
origin: user-defined
---

# BA Requirements

This skill produces the central requirements artifact for a project. It is the single document that every downstream BA and engineering artifact traces back to.

Use it after `ba-discovery` and at least one `ba-current-state` pass have established stakeholders, glossary, and the to-be process. This skill turns pain points and to-be steps into structured BRs, FRs, NFRs, and business rules.

## When to Use

- Stakeholder register and at least one to-be process map exist
- The team is about to plan delivery and needs a definitive scope document
- A vendor RFP, build/buy decision, or change request needs a structured requirements pack
- Earlier elicitation produced a wall of bullet points and you need them organized, classified, and prioritized

## Inputs

Ask for, in order:

1. Confirm `docs/ba/01-discovery.md` exists (read the ID Legend and Objectives)
2. List the `docs/ba/02-process-*.md` files in scope
3. Any vision deck, charter, or RFP context
4. Success metrics: how will the business measure that this delivered value?

If the user supplies an existing BRD or FRD, ingest it and run phases 5 through 8 as a gap-fill pass instead of re-eliciting.

## Wizard Phases

1. Confirm business objectives and success metrics
   - Pull objectives from `01-discovery.md`, assign `OBJ-###` IDs if not already present
   - For each objective, capture a measurable success metric (number + timeframe)
   - Flag any objective without a metric as `[NEEDS METRIC]`

2. Scope boundaries
   - In-scope list (capabilities this project delivers)
   - Out-of-scope list (explicit non-goals to prevent scope creep)
   - Adjacencies: systems or processes that touch but are not changed

3. Elicit Business Requirements (BR-###)
   - One outcome statement per BR. Format: "The business shall {outcome} so that {OBJ link}."
   - Link each BR to one or more OBJ-###. Orphan BRs (no OBJ link) are not allowed.

4. Decompose to Functional Requirements (FR-###)
   - Group by capability (auth, search, billing, reporting, etc.)
   - Use EARS notation where appropriate:
     - Ubiquitous: "The system shall {response}."
     - Event-driven: "When {trigger}, the system shall {response}."
     - State-driven: "While {state}, the system shall {response}."
     - Optional-feature: "Where {feature is included}, the system shall {response}."
     - Unwanted-behavior: "If {trigger}, then the system shall {response}."
   - Link each FR to its parent BR-###

5. Non-Functional Requirements (NFR-###) by FURPS+
   - Functionality (beyond FRs): security, compliance, capability gaps
   - Usability: accessibility (WCAG level), language support, user onboarding
   - Reliability: availability, MTBF, MTTR, recovery objectives
   - Performance: throughput, latency p50/p95/p99, concurrent users
   - Supportability: observability, deployment, configurability
   - Plus: design constraints, implementation, interface, physical
   - Every NFR needs a metric and a threshold. "Fast" is not an NFR.

6. Business rules catalog (RULE-###)
   - Declarative if/then statements that constrain behavior independent of implementation
   - Capture source (regulation, policy, contract, SLA) and owner (who can change it)
   - Examples: "If customer is under 18, then booking requires guardian approval."

7. MoSCoW classification pass
   - Must: launch blocker
   - Should: important but launch can happen without it
   - Could: nice-to-have
   - Won't (this release): explicit deferral
   - Sanity check: Must should not exceed ~60% of total items. If it does, force the user to re-rank.

8. Assumptions, dependencies, constraints sweep
   - Assumptions: things treated as true without proof
   - Dependencies: external systems, teams, decisions, or data
   - Constraints: budget, timeline, technology mandates, regulatory deadlines

## Frameworks Referenced

- IEEE 830 — software requirements specification structure
- FURPS+ — non-functional requirement categorization (Functionality, Usability, Reliability, Performance, Supportability + design/implementation/interface/physical)
- MoSCoW — Must/Should/Could/Won't prioritization
- Volere shells — requirement card template (id, type, rationale, fit criterion, source)
- EARS — Easy Approach to Requirements Syntax (ubiquitous, event-driven, state-driven, optional-feature, unwanted-behavior)
- Declarative business rule pattern — if/then with source and owner

## Output Format

Write the artifact to `docs/ba/03-requirements.md`. Use this skeleton:

```markdown
# Requirements — {Project Name}

## Business Objectives
| OBJ-ID | Objective | Success Metric | Timeframe |
|--------|-----------|----------------|-----------|

## Scope
### In Scope
- ...
### Out of Scope
- ...
### Adjacencies
- ...

## Business Requirements (BR)
| BR-ID | Outcome Statement | OBJ Link | MoSCoW |
|-------|-------------------|----------|--------|

## Functional Requirements (FR)
### Capability: {name}
| FR-ID | EARS Statement | BR Link | MoSCoW |
|-------|----------------|---------|--------|

## Non-Functional Requirements (NFR) — FURPS+
| NFR-ID | Category | Statement | Metric | Threshold |
|--------|----------|-----------|--------|-----------|

## Business Rules Catalog (RULE)
| RULE-ID | Rule (if/then) | Source | Owner |
|---------|----------------|--------|-------|

## Assumptions, Dependencies, Constraints
### Assumptions
- ...
### Dependencies
- ...
### Constraints
- ...

## HANDOFF
Next skill: ba-stories to convert FRs into INVEST-quality user stories with Gherkin acceptance criteria.
Optional: invoke product-capability for any FR that crosses services and needs an engineering contract.
Blockers: {list any NEEDS METRIC or NEEDS DECISION items that must close before stories are written}.
```

## Composition

- Reads: `docs/ba/01-discovery.md` (objectives, ID legend, glossary), `docs/ba/02-process-*.md` (pain points and to-be steps)
- Hands off to: `ba-stories` for delivery breakdown
- Optional handoff: `product-capability` for engineering-facing SRS contracts on multi-service FRs
- Sibling: `market-research` if a Must FR requires competitive or benchmark grounding

## Non-Negotiable Rules

- Every BR must link to an OBJ. Every FR must link to a BR. Orphan requirements are not allowed.
- Every NFR must have a metric and a threshold. Reject "fast", "easy", "secure" without numbers.
- MoSCoW Must items should not exceed roughly 60% of total. If they do, re-prioritize before exiting Phase 7.
- Use EARS notation for functional requirements. Free-prose FRs are not allowed.
- Always end with HANDOFF naming the next skill and listing any open NEEDS items as blockers.
