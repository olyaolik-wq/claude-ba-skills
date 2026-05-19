---
name: ba-nav
description: BA Suite navigator — shows the full 8-skill workflow map, runs a 3-question diagnostic to find your entry point, and routes you to the right skill with context pre-filled. Use at the start of any BA session, or whenever you are unsure which skill to run next.
origin: user-defined
---

# BA Navigator

This is the cockpit for the full BA skill suite. It does not produce a BA artifact itself — it orients you in the workflow, finds your entry point, and launches the right skill with context already loaded.

Run this at the start of every BA session. You do not need to start from `ba-discovery` — you can enter at any skill in the chain.

## When to Use

- Starting a BA session and unsure which skill to run next
- Picking up a project mid-flight after a gap
- Onboarding someone new to the BA suite who needs to understand the workflow before diving in
- Wanting a quick map of what has been done and what remains

## Inputs

No pre-reading required. The navigator collects context through its diagnostic questions and reads existing artifacts from `docs/ba/` if they exist.

## Wizard Phases

### Phase 1 — Display the Skill Map

Always display this map first, before asking any questions:

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                        BA SKILL SUITE — WORKFLOW MAP                        ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  [1] ba-discovery          Stakeholder mapping, RACI, elicitation plan,     ║
║      │                     domain glossary v0.1                             ║
║      │                                                                       ║
║      ▼                                                                       ║
║  [2] ba-research-synthesis JTBD statements, evidence-backed personas,       ║
║      │  (optional —        customer journey maps from raw transcripts        ║
║      │   post-research)                                                      ║
║      │                                                                       ║
║      ▼                                                                       ║
║  [3] ba-current-state      As-is / to-be BPMN swimlanes, pain heatmap,     ║
║      │                     gap analysis table                                ║
║      │                                                                       ║
║      ▼                                                                       ║
║  [4] ba-requirements       BRD + FRD (EARS) + NFR (FURPS+) + business      ║
║      │                     rules catalog + MoSCoW classification             ║
║      │                                                                       ║
║      ├──────────────────────────────────────────────────────────────────    ║
║      │                                                                       ║
║      ▼                                                                       ║
║  [5] ba-solution-model     Cockburn use case briefs, Chen ERD, CRUD        ║
║      │  (optional —        matrix linking use cases to entities             ║
║      │   complex data                                                        ║
║      │   model)                                                              ║
║      │                                                                       ║
║      ▼                                                                       ║
║  [6] ba-stories            INVEST user stories, Gherkin Given-When-Then    ║
║      │                     AC, UAT scenario seed                             ║
║      │                                                                       ║
║      ▼                                                                       ║
║  [7] ba-traceability       RTM (BR→FR→Story→AC→Test), impact analysis,    ║
║                            ADKAR transition + launch plan                   ║
║                                                                              ║
║  ════════════════════════════════════════════════════════════════════════   ║
║  [8] ba-prioritization     RICE / Kano / WSJF / Weighted Scoring deep-     ║
║      (parallel track)      rank — run when backlog > 30 items or           ║
║                            MoSCoW collapses to "everything is Must"         ║
╚══════════════════════════════════════════════════════════════════════════════╝

  ENTRY POINT: Any skill. You do not need to start from [1].
  OPTIONAL:    [2] and [5] can be skipped if not needed.
```

### Phase 2 — Project Context Check

Ask: "Do you have an existing `docs/ba/` folder for this project?"

- If **yes**: scan which artifact files exist and display a completion checklist:

  ```
  ✅ / ⬜  01-discovery.md            ba-discovery
  ✅ / ⬜  01a-research-synthesis.md  ba-research-synthesis
  ✅ / ⬜  02-process-*.md            ba-current-state
  ✅ / ⬜  03-requirements.md         ba-requirements
  ✅ / ⬜  03a-solution-model.md      ba-solution-model
  ✅ / ⬜  04-stories.md              ba-stories
  ✅ / ⬜  05-traceability.md         ba-traceability
  ✅ / ⬜  06-prioritization-*.md     ba-prioritization
  ```

  Read the HANDOFF block from the most recent completed artifact and surface its "Next skill" recommendation as the default option before running the diagnostic.

- If **no**: treat the project as a fresh start. Skip the checklist and proceed to Phase 3.

### Phase 3 — Three Diagnostic Questions

Ask these three questions one at a time. Do not batch them.

**Q1 — Where are you in the project lifecycle?**

```
A) Kicking off — problem identified, no BA work done yet
B) Post-kickoff — stakeholders mapped, need to understand users or processes
C) Mid-analysis — requirements are forming, need to model or structure them
D) Pre-delivery — requirements signed off, need stories and acceptance criteria
E) Backlog exists — prioritisation is the immediate problem
F) Near launch — need traceability, impact analysis, or a transition plan
G) Not sure — I'll describe my situation in a sentence
```

**Q2 — What do you have right now?** (select all that apply)

```
A) Problem statement or project brief
B) Stakeholder names / org chart
C) Interview transcripts or research notes
D) As-is process documentation (flowcharts, SOPs, swimlanes)
E) A requirements list (even rough or informal)
F) A backlog of user stories or features
G) None of the above
```

**Q3 — What is your most urgent output?**

```
A) Know who to talk to and what to ask them
B) Understand why users behave the way they do (JTBD, personas, journey map)
C) Document how work flows today and design how it should flow tomorrow
D) Capture formal requirements (BRD / FRD / NFR) with MoSCoW
E) Model the data and use cases before stories are written
F) Write user stories with acceptance criteria ready for sprint
G) Rank the backlog so the team agrees on what ships first
H) Prove every requirement traces to a test and prepare for launch
```

### Phase 4 — Routing Decision

Use this table to determine the recommended entry skill:

| Q1 | Q3 | Additional condition | Recommended skill |
|----|----|----------------------|-------------------|
| A  | A  | —                    | `ba-discovery`    |
| A or B | B | Transcripts exist (Q2-C) | `ba-research-synthesis` |
| A or B | B | No transcripts yet   | `ba-discovery` → then `ba-research-synthesis` |
| B or C | C | —                  | `ba-current-state` |
| C  | D  | —                    | `ba-requirements` |
| C  | E  | —                    | `ba-solution-model` |
| D  | F  | —                    | `ba-stories`      |
| E  | G  | —                    | `ba-prioritization` |
| F  | H  | —                    | `ba-traceability` |
| G  | any | —                   | Summarise situation, recommend one skill, explain why in one sentence |

Present the recommendation as:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
RECOMMENDED ENTRY: ba-{skill-name}

Why: {one sentence grounded in Q1/Q2/Q3 answers}

Context I will carry forward:
  • Project name    : {if known, else "not yet provided"}
  • Existing docs   : {list from Phase 2, or "none"}
  • Key open item   : {if surfaced in Q2/Q3, else "none"}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Ready to launch? (yes / pick a different skill / show map again)
```

### Phase 5 — Launch

If the user confirms:
- Invoke the recommended skill
- Pass the project name, existing artifact paths, and any constraint or open question collected in Phase 3 as pre-loaded context so the target skill skips re-asking what is already known

If the user picks a different skill:
- Show the numbered map again
- Ask "Which number?" and launch that skill with whatever context has been collected so far

## Frameworks Referenced

- BA skill suite workflow order (skills 1–8 with optional [2] and [5])
- HANDOFF discipline — every artifact's HANDOFF block is the canonical "resume signal"; the navigator reads it to surface the default next step on mid-flight projects

## Output Format

The navigator does not write any file to `docs/ba/`. Its only outputs are:
1. The skill map (always)
2. The completion checklist (if `docs/ba/` exists)
3. The routing recommendation box
4. The launched skill (which produces its own artifact)

## Composition

- Reads: HANDOFF blocks in `docs/ba/*.md` (if folder exists) — skims for "Next skill" line only, does not re-read full artifacts
- Hands off to: whichever of the 8 BA skills the routing decision selects
- Does not call external skills, tools, or deep-research directly

## Non-Negotiable Rules

- Always display the full skill map (Phase 1) before asking any questions. Never skip it.
- Never produce or modify any file in `docs/ba/`. The navigator is a router, not a producer.
- Ask the three diagnostic questions one at a time. Do not batch them into a single prompt.
- If Q1 is G (not sure), do not skip routing — summarise the situation and still recommend one specific skill with a one-sentence rationale.
- Always end Phase 4 with a confirm-or-redirect prompt. Never silently launch a skill without user confirmation.
- If existing artifacts are found in `docs/ba/`, surface the HANDOFF "Next skill" as a default before running the full diagnostic — the user may simply want to continue where they left off.
- Context collected in Phase 3 must be passed forward to the launched skill. Never make the user re-enter information they already provided to the navigator.
