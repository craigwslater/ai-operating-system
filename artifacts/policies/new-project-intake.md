<!-- AUTHOR'S NOTE—this header is appended at port time; the original file does not contain it. -->

> **Designed by Craig—runtime: Claude (Sonnet/Opus).**
> **What this is.** The new-project-intake workflow protocol—what `/start-project` runs when a new multi-session effort kicks off. Defines the scope-gathering interview, the folder scaffolding from `templates/`, and the MEMORY.md Active Projects registration.
> **What was redacted.** Nothing—the registry sweep produced zero substitutions.
> **Why it's included.** Backs the case-study claim that multi-session work is structured up front: every project folder under `projects/` exists because this protocol ran on it at kickoff.

---

# New Project Intake

When Craig signals a new project (says "new project," describes a new multi-session effort, or starts work that doesn't map to an existing project folder):

1. **Read Craig's overview** — he will typically give a high-level description of what he wants to build or accomplish.
2. **Ask targeted questions** using AskUserQuestion — tailor them to the project type. The goal is to gather enough to write a rigorous project CLAUDE.md. Core areas to cover:
   - **Goal & scope**: What problem are we solving? What does success look like? What's explicitly out of scope?
   - **Constraints**: Technical, regulatory, timeline, budget, or quality constraints that bound the work
   - **Users / audience**: Who is this for? What are their needs and context?
   - **Architecture / approach**: Tech stack, frameworks, data model, design principles, or methodology preferences (for technical projects); structure, format, deliverables (for non-technical projects)
   - **Quality bar**: What standard should outputs meet? Production-ready? Prototype? Portfolio piece?
   - **Dependencies & risks**: Anything that could block progress or cause rework
   - **Sequencing**: What order should things be built/done? What's the first milestone?
3. **Create the project folder** at `projects/[name]/` with:
   - `CLAUDE.md` — the project plan: goals, constraints, architecture decisions, non-negotiables, quality standards. This is prescriptive and stable — it changes only when Craig makes a deliberate strategic decision. **Scaffold from `templates/project-CLAUDE-md.template`.**
   - `CONTEXT.md` — initialized with the first session's status and next steps. This is descriptive and temporal — it updates every session. **Scaffold from `templates/project-CONTEXT-md.template`.** Hard ≤80-line budget; older session entries archive to `log.md`.
   - `log.md` — the full session log (one entry per session, append-only). Entries follow `templates/session-log-entry.template`. Created when the first session log entry is written.
   - `inputs/` — if the project has source materials (data files, specs, images, reference docs), create this directory and document what's in it in the project CLAUDE.md under a "Key Files" section.
   - `outputs/` — created when the first deliverable is produced.
4. **Confirm the plan** with Craig before starting substantive work. The project CLAUDE.md is the contract — get alignment before building.

**Adapt questions to project type.** A full-stack product needs tech stack, data model, and deployment questions. A research project needs scope, sources, and deliverable format. A skill-building effort needs workflow, eval criteria, and reference material questions. Use Craig's overview to determine which areas matter most and skip what's irrelevant.

## Available templates

The `templates/` folder contains scaffolds for the standard artifacts new projects produce:

- `templates/project-CLAUDE-md.template` — 12-section project plan (goal / diagnosis / scope / non-negotiables / architecture / sequencing / quality bar / working practices / source-of-truth / what-this-plan-does-not-do / failure modes / kickoff). Use for any multi-session project.
- `templates/project-CONTEXT-md.template` — slim status file (≤80 lines): Status / Next steps / 3 most recent sessions / Source-of-truth pointers.
- `templates/session-log-entry.template` — full per-session entry for `log.md` (purpose / actions / acceptance check / state at close / open items). The `log.md` is append-only; CONTEXT.md only carries 1-2 line summaries of the 3 most recent.
- `templates/eval-template.md` — skill eval format (preamble / JD summary / mastery angles / key decisions / iteration log / verification / rules spawned / cross-references). Lives in `skills/[name]/evals/`.
- `templates/correction-entry.template` — single corrections-log.md entry (failure mode / WRONG / RIGHT / why-checks-missed-it / rule spawned / severity / provenance / cross-refs).
