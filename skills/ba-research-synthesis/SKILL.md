---
name: ba-research-synthesis
description: Interactive wizard that turns raw user-research material (interview transcripts, observation notes, open survey responses) into Jobs-To-Be-Done statements, evidence-backed personas, and customer journey maps. Use after a research push, before requirements work, to ground BR/FR outcomes in real user evidence.
origin: user-defined
---

# BA Research Synthesis

This skill converts raw qualitative research into the three artifacts that downstream BA and product work depend on: Jobs-To-Be-Done (why users hire a product), personas (who the users are), and customer journey maps (how they actually move through the experience today).

Use it after `ba-discovery` has produced interview guides and the team has actually run the research, but before `ba-current-state` or `ba-requirements` so that process actors and BR outcomes are grounded in evidence rather than assumption.

## When to Use

- A research push has just completed (5+ interviews, observation sessions, or open-ended survey responses) and the transcripts are unsynthesized
- The team is about to write requirements but personas and user goals are still anecdotal
- An existing persona deck is suspected to be aspirational rather than evidence-based and needs a refresh
- A customer-journey artifact is needed for a redesign, churn investigation, or onboarding overhaul

## Inputs

Ask for, in order:

1. Confirm `docs/ba/01-discovery.md` exists and read the stakeholder register and glossary
2. The research question this synthesis must answer (one sentence — e.g. "Why do small-business owners abandon onboarding before step 4?")
3. Source list: interview transcripts (paths or pasted), observation notes, open survey responses. For each: who, when, format, duration
4. Any existing persona or JTBD drafts the user wants to refresh rather than create from scratch
5. Scope cap: the primary persona and primary scenario for the journey map (avoid mapping the entire product in one pass)

If the user supplies existing personas or a journey map, ingest them and run phases 2 through 7 as an evidence-fill pass instead of re-eliciting.

## Wizard Phases

1. Source inventory and research question
   - List every source with a `SRC-###` ID, interviewee role/segment, date, format, duration
   - Pin the research question. Every JOB, PERSONA, and JM-step must trace back to it
   - Flag thin coverage: a segment represented by fewer than 3 sources is `[LOW EVIDENCE]`

2. Open coding and quote extraction
   - Read each transcript and extract verbatim quotes that signal a job, pain, motivation, behavior, or emotion
   - Assign each quote a `Q-###` ID and tag it: `pain | motivation | behavior | emotion | context | workaround`
   - Cluster similar quotes. Note saturation: when new sources stop producing new themes, mark the dataset as saturated for that theme

3. Jobs-To-Be-Done synthesis
   - For each cluster, write a JTBD statement: "When {situation}, I want to {motivation}, so I can {expected outcome}."
   - Classify type: functional (task), emotional (how I want to feel), social (how I want to be seen)
   - Assign `JOB-###` IDs. Link each JOB to the source Q-### quote IDs that support it (minimum two independent sources for `Confidence: M`, four for `Confidence: H`)

4. Persona synthesis
   - Cluster interviewees by goals, behaviors, and context (not demographics first)
   - For each cluster, draft a persona: name (descriptive role, not a caricature), goals, frustrations, behaviors/tools, decision drivers, one anchor quote
   - Assign `PERSONA-###` IDs. Mark any persona backed by fewer than three interviewees as `[PROTO-PERSONA]` until validated
   - Reject Cooper-style invented demographics unless evidence supports them

5. Customer journey mapping
   - Pick the primary persona + primary scenario (from Inputs phase 5)
   - Walk the journey stage by stage. Columns: stage, actions, thoughts, emotions, touchpoints, pain points, opportunities
   - Assign `JM-###` IDs to each journey map. Each pain in the journey must link to a Q-### quote
   - Mark moments of truth (high-emotion stages where the user decides to continue or abandon)

6. Insight prioritization
   - Roll quotes and journey pains up into `INS-###` insights — short statements of "what we learned"
   - Score each insight on Confidence (count of independent sources: L=1, M=2-3, H=4+) and Impact (potential business value if addressed: L/M/H)
   - High-Confidence + High-Impact insights are "actionable now". High-Impact + Low-Confidence are "validate next research push"

7. Cross-link to BA artifacts
   - For each JOB-###: propose one or more candidate BR outcomes for `ba-requirements` to formalize (use `[BR-CANDIDATE: short name]` placeholders — do not assign real BR IDs here)
   - For each PERSONA-###: list which lanes/actors it will appear as in `ba-current-state` swimlanes
   - For each journey pain point: tag it as a pain-heatmap candidate for the matching `ba-current-state` process

8. Open questions and saturation check
   - List unresolved questions, contradictions between sources, and segments still flagged `[LOW EVIDENCE]`
   - Recommend follow-up research (interviews, surveys, observation) needed before requirements can rely on these findings
   - Decide go/no-go: is the evidence base strong enough to proceed to `ba-current-state` and `ba-requirements`, or does another research wave run first?

## Frameworks Referenced

- Jobs-To-Be-Done (Christensen) — "When {situation}, I want to {motivation}, so I can {outcome}" statements; functional/emotional/social classification
- Cooper goal-directed personas — goal/behavior/context clustering (not demographic stereotyping)
- Customer journey mapping — stages × actions × thoughts × emotions × touchpoints × pains × opportunities
- Thematic analysis / open coding — qualitative method for tagging and clustering quotes
- Triangulation — confidence scales with number of independent sources confirming a theme
- Saturation — research dataset is "saturated" when new sources stop producing new themes

## Output Format

Write the artifact to `docs/ba/01a-research-synthesis.md` (positioned between discovery and current-state in workflow order). Use this skeleton:

```markdown
# Research Synthesis — {Project Name}

## Research Question
{one sentence}

## Source Inventory
| SRC-ID | Segment / Role | Date | Format | Duration | Coverage Note |
|--------|----------------|------|--------|----------|---------------|

## ID Legend Extension
This skill extends the project ID legend with:
- SRC- Research sources
- Q-   Verbatim quotes
- JOB- Jobs To Be Done
- PERSONA- Personas
- JM-  Customer Journey Maps
- INS- Research insights

## Coding Index (high-signal quotes)
| Q-ID | SRC-ID | Verbatim Quote | Tag |
|------|--------|----------------|-----|

## Jobs To Be Done
| JOB-ID | Statement (When... I want to... So I can...) | Type | Q-IDs | Confidence |
|--------|----------------------------------------------|------|-------|------------|

## Personas
### PERSONA-001: {descriptive role}
- **Anchor quote:** "..." (Q-###)
- **Goals:** ...
- **Frustrations:** ...
- **Behaviors / tools:** ...
- **Decision drivers:** ...
- **Evidence base:** {N} sources — SRC-###, SRC-###
- **Confidence:** L/M/H | Status: validated | [PROTO-PERSONA]

## Customer Journey Maps
### JM-001: {persona} doing {scenario}
| Stage | Actions | Thoughts | Emotions | Touchpoints | Pain (Q-IDs) | Opportunities | Moment of Truth? |
|-------|---------|----------|----------|-------------|--------------|---------------|------------------|

## Actionable Insights
| INS-ID | Insight | JOB Link | Confidence | Impact | Recommendation |
|--------|---------|----------|------------|--------|----------------|

## Cross-Links to BA Artifacts
- JOB-001 → [BR-CANDIDATE: short name] for ba-requirements
- PERSONA-002 → actor "Customer" in ba-current-state for process {name}
- JM-001 step "{stage}" pain → pain heatmap candidate for ba-current-state of process {name}

## Open Questions and Saturation Gaps
- [ ] {question} — segment: ... — recommended follow-up: ...
- [LOW EVIDENCE] {segment} — only {N} sources

## HANDOFF
Next skill: ba-current-state to model the as-is process using these personas as actors and these journey pains as input to the pain heatmap.
Then: ba-requirements to convert JOB-### statements into BR-### outcome statements with measurable success metrics.
Blockers: {list any [LOW EVIDENCE] segments or [PROTO-PERSONA] flags that should be validated before requirements rely on them}.
```

## Composition

- Reads: `docs/ba/01-discovery.md` (stakeholder register, glossary, ID legend), all supplied transcripts and notes
- Hands off to: `ba-current-state` (personas as actors, journey pains as pain-heatmap candidates) and `ba-requirements` (JOBs as BR-candidates)
- Sibling: `deep-research` for any domain terminology that surfaces in transcripts but is not yet in the glossary
- Sibling: `market-research` if a journey opportunity or insight needs external benchmarking before becoming a BR candidate

## Non-Negotiable Rules

- Every JOB, PERSONA, journey pain, and INS must trace back to at least one Q-### quote ID. Untraceable findings are not allowed.
- JTBD statements must use the exact format "When {situation}, I want to {motivation}, so I can {expected outcome}." Free-prose jobs are rejected.
- Personas backed by fewer than three independent source interviewees must be marked `[PROTO-PERSONA]`. Do not present assumption-based personas as validated.
- Confidence ratings are evidence-based (count of independent sources), never gut feel. L=1 source, M=2-3 sources, H=4+ sources.
- Do not forward-reference downstream IDs (BR-###, FR-###, etc.) that do not exist yet. Use `[BR-CANDIDATE: short name]` placeholders. `ba-requirements` will assign real IDs.
- Always end with HANDOFF naming `ba-current-state` and `ba-requirements`, and listing `[LOW EVIDENCE]` or `[PROTO-PERSONA]` flags as blockers.
