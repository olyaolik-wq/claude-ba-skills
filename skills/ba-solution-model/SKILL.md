---
name: ba-solution-model
description: Interactive wizard that turns functional requirements into a solution model — UML-style use case briefs, a lightweight Chen ERD of domain entities and relationships, and a CRUD matrix linking use cases to entities. Use after ba-requirements when to-be modeling needs more rigor than BPMN swimlanes alone, or before story breakdown when the data model is still implicit.
origin: user-defined
---

# BA Solution Model

This skill produces the structured solution-side artifact: who does what (use cases), what data the system holds (ERD), and which use cases touch which data (CRUD). It sits between requirements and stories, giving developers, testers, and architects a shared object model before delivery starts.

Use it after `ba-requirements` has produced FRs and business rules, when the team needs a clearer data model than the BPMN swimlanes in `ba-current-state` provide — typically before `ba-stories` or in parallel with `product-capability` for engineering-facing contracts.

## When to Use

- Requirements are written but the data model and use-case structure are still implicit
- The team is about to start story breakdown and needs use case scope to drive `ba-stories`
- A new system, integration, or major refactor needs an explicit entity model before estimation
- Engineering is asking "what are the objects and what touches them" and the BA artifacts don't yet answer

## Inputs

Ask for, in order:

1. Confirm `docs/ba/01-discovery.md` exists (read ID legend, stakeholder register) and `docs/ba/03-requirements.md` exists (read FRs, NFRs, business rules)
2. If `docs/ba/01a-research-synthesis.md` exists, read its personas — they become candidate primary actors
3. Capability or epic scope: which FRs from `03-requirements.md` are in this modeling pass (modeling everything at once is rejected — pick a coherent slice)
4. Any existing use case briefs, ERD, or domain glossary the user wants to extend rather than rewrite
5. Known external systems or services this scope integrates with (they show up as system actors)

If the user supplies an existing UML use case spec or ERD, ingest it and run phases 4 through 8 as a gap-fill pass.

## Wizard Phases

1. Confirm scope and read upstream artifacts
   - Read FRs, RULES, and personas in scope
   - Restate the slice in one sentence ("Model the loyalty-redemption capability: FR-014 to FR-022 plus RULE-007, RULE-008")
   - List explicit out-of-scope items so the model does not creep

2. Identify actors
   - Human actors: pull from `01-discovery.md` stakeholder register and `01a-research-synthesis.md` personas (where present)
   - System actors: downstream systems, scheduled jobs, third-party services, webhooks
   - Capture per actor: name, type (human/system), persona/stakeholder link, role description (one sentence)

3. Identify use cases
   - For each FR (or cluster of related FRs), name the use case as verb + object ("Redeem Loyalty Stamp", "Approve Refund")
   - Assign `UC-###` IDs. Link each UC to its parent FR-###(s)
   - Reject "manage X" naming — split into Create/Update/Archive UCs when behavior differs
   - Estimate frequency/volume per UC (informs NFRs and CRUD-matrix priority)

4. Write use case briefs (Cockburn/UML format)
   - For each UC capture: primary actor, supporting actors, goal in context, preconditions, success postconditions, main success scenario (numbered steps), alternative flows (branching at step N as `Na`), exception flows (`N.E1`, `N.E2`), frequency
   - Reject briefs missing any of: primary actor, goal, preconditions, main success scenario, at least one alternative or exception flow
   - Each step in the main scenario references the actor performing it

5. Identify domain entities (Chen ERD)
   - For each UC and each business rule, identify the data objects involved
   - Assign `ENT-###` IDs. For each entity capture: name, one-line description, key attributes (PK candidate + business-meaningful attributes with type), system of record, governed-by RULE-### links
   - Mark inferred attributes (not stated in any FR/RULE) as `[INFERRED — CONFIRM]`

6. Map entity relationships
   - For each pair of related entities capture: verb describing the relationship, cardinality (1:1, 1:N, M:N), participation (mandatory/optional on each side)
   - Text-Chen notation: `ENT-A —{verb}— ENT-B (1:N, mandatory on B)`
   - For M:N, introduce an associative entity with its own `ENT-###` ID and decompose into two 1:N relationships

7. CRUD matrix
   - Rows: use cases (UC-###). Columns: entities (ENT-###). Cells: C / R / U / D or combinations (e.g. CRU)
   - Run coverage checks:
     - Entities with no Create across any UC: where does the data come from? (external import, manual seed, missing UC)
     - Entities never Read by any UC: likely dead — flag for removal or confirm external consumer
     - UCs that touch no entities: probably misnamed or non-functional — re-examine

8. Validation and cross-link
   - Every UC must trace to ≥1 FR-###. Flag orphans
   - Every ENT must trace to ≥1 UC or RULE. Flag orphans
   - Identify NFR candidates: high-frequency UCs imply throughput/latency NFRs; sensitive entities imply security/audit NFRs
   - Identify story-breakdown candidates for `ba-stories`: each UC's main scenario plus its alt/exception flows typically becomes 1-N stories

## Frameworks Referenced

- UML 2.5 use case notation — actor, use case, include/extend (lightweight subset, no diagram syntax)
- Cockburn Writing Effective Use Cases — fully-dressed brief template (primary actor, goal, preconditions, main scenario, extensions)
- Chen ERD — entity, attribute, relationship with cardinality and participation
- CRUD matrix — actor/UC × entity coverage analysis to detect orphans and dead data
- Domain-Driven Design (lightweight) — entity vs value object distinction when an attribute cluster has identity

## Output Format

Write the artifact to `docs/ba/03a-solution-model.md` (positioned between requirements and stories in workflow order). Use this skeleton:

```markdown
# Solution Model — {Project Name}

## Scope
- Modeling slice: ...
- In-scope FRs: FR-###, FR-###
- Out-of-scope (explicit): ...

## ID Legend Extension
This skill extends the project ID legend with:
- UC-  Use Cases
- ENT- Domain Entities

## Actors
| Actor | Type (human/system) | Persona / Stakeholder Link | Role Description |
|-------|---------------------|----------------------------|------------------|

## Use Case Catalog
| UC-ID | Name | Primary Actor | Goal | FR Link | Frequency |
|-------|------|---------------|------|---------|-----------|

## Use Case Briefs
### UC-001: {Verb Object}
- **Primary actor:** ...
- **Supporting actors:** ...
- **Goal in context:** ...
- **Preconditions:** ...
- **Success postconditions:** ...
- **Main success scenario:**
  1. {Actor} {action}
  2. {Actor} {action}
- **Alternative flows:**
  - 2a. {condition}: {steps}
- **Exception flows:**
  - 2.E1. {failure}: {steps}
- **Frequency / volume:** ...
- **FR link:** FR-###

## Domain Entities
| ENT-ID | Name | Description | System of Record | Governed by RULES |
|--------|------|-------------|------------------|-------------------|

### ENT-001: {EntityName}
- **Attributes:**
  - {attribute} ({type}) — {description}
  - {attribute} ({type}) — [INFERRED — CONFIRM]
- **Notes:** ...

## Entity Relationships
- ENT-001 —{verb}— ENT-002 (1:N, mandatory on ENT-002)
- ENT-002 —{verb}— ENT-003 (M:N via associative ENT-004)

## CRUD Matrix
| UC \ ENT | ENT-001 | ENT-002 | ENT-003 |
|----------|---------|---------|---------|
| UC-001   | C       | R       | -       |
| UC-002   | R       | RU      | -       |

## Coverage Checks
- Orphan UCs (no FR link): ...
- Orphan ENTs (no UC or RULE link): ...
- Entities with no Create across any UC: ...
- Entities never Read by any UC: ...
- UCs touching no entities: ...

## NFR and Story Candidates
- High-frequency UCs implying throughput NFRs: UC-###
- Sensitive entities implying audit/security NFRs: ENT-###
- Candidate story breakdown for ba-stories: UC-### main + alt/exception flows

## HANDOFF
Next skill: ba-stories to convert each UC main scenario plus its alt/exception flows into INVEST stories with Gherkin AC.
Optional: invoke product-capability for any UC that crosses services and needs an engineering capability contract.
Blockers: {list orphan UCs, orphan ENTs, or [INFERRED — CONFIRM] attributes that should be resolved first}.
```

## Composition

- Reads: `docs/ba/01-discovery.md` (stakeholders, ID legend), `docs/ba/01a-research-synthesis.md` (personas, if present), `docs/ba/03-requirements.md` (FRs, NFRs, RULES)
- Hands off to: `ba-stories` (UC main scenarios + alt flows become stories)
- Sibling: `product-capability` for engineering-side capability contracts on multi-service UCs
- Sibling: `ba-current-state` — the BPMN swimlane describes how work flows today; this skill describes what objects the system holds and what each UC does to them. Different lenses, both valid

## Non-Negotiable Rules

- Every UC must trace to ≥1 FR-###. Orphan use cases are not allowed.
- Every ENT must trace to ≥1 UC or RULE-###. Orphan entities are not allowed.
- Use case briefs must include: primary actor, goal, preconditions, success postconditions, main success scenario, and at least one alternative or exception flow. Missing fields are rejected.
- Relationships must specify both cardinality (1:1, 1:N, M:N) AND participation (mandatory/optional). "Has a" without cardinality is rejected.
- Do not invent attributes that no FR, RULE, or user input supports. Mark inferred attributes as `[INFERRED — CONFIRM]` and add to Blockers.
- Always end with HANDOFF naming `ba-stories` and listing any orphan UC, orphan ENT, or `[INFERRED — CONFIRM]` items as blockers.
