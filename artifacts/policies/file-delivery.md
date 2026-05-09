<!-- AUTHOR'S NOTE—this header is appended at port time; the original file does not contain it. -->

> **Designed by Craig—runtime: Claude (Sonnet/Opus).**
> **What this is.** The file-delivery workflow protocol—where every Claude-produced file goes (project work → `projects/[name]/outputs/`; one-off → root `outputs/`; skill-eval artifacts → `skills/[name]/eval-output/`) and how it surfaces to Craig (Cowork uses `present_files`; Claude Code names full paths). Defines what locations are off-limits.
> **What was redacted.** One active-target-company name (a healthcare company referenced in a post-ship-correction worked example) substituted to `[REDACTED COMPANY]` per registry entry tgt-025. The eval number and origin date remain so the worked example still anchors to a real failure-mode lineage.
> **Why it's included.** The "output-routing" rule that prevents temporary sandbox paths from being treated as deliverables. Direct evidence for the dual-environment portability claim in CS#4.

---

# File Delivery

All output files (Excel, PDF, Word doc, etc.) are saved within the `~/.claude-local` folder structure — never to Desktop or any location outside it.

**Routing logic (always follow this order):**

1. If the work maps to an existing project → save to `projects/[name]/outputs/`
2. If it's a one-off session with no project → save to root `outputs/`
3. If it's a skill eval artifact → save to `skills/[name]/eval-output/`

**After saving:**

- In **Cowork**: use the `present_files` tool so Craig gets a clickable card to open the file directly
- In **Claude Code**: confirm the full file path in the response so Craig can open it manually

**Never save output files to:**

- Craig's Desktop (`~/Desktop/`)
- The root of `~/.claude-local/` (only CLAUDE.md, MEMORY.md, and system dirs belong there)
- Cowork's system folder (`mnt/.claude/`)
- Temporary VM paths (`/tmp/`, `/sessions/.../` outside a mounted folder)

---

## Post-ship corrections (added v5 S3, 2026-05-06)

When a delivered artifact (DOCX/PDF) needs correction after the original ship — composer typos surfaced on Craig's review, post-delivery rule-gap diagnoses, etc. — **never edit the DOCX/PDF directly.** Source JSON updates first; artifacts regenerate from JSON.

The discipline exists because two failure modes emerge when DOCX/PDF is corrected without round-tripping to the source JSON (origin: [REDACTED COMPANY] Eval 22 post-ship correction, 2026-05-06):

1. **Step 0.4 precedent sweep contamination.** Future evals that load `craig_application.json` as a precedent pull the uncorrected text forward.
2. **Re-run overwrite.** Any subsequent `generate_docs.py` invocation regenerates the DOCX from JSON, overwriting the manually-corrected DOCX with the uncorrected prose.

**Canonical entry point:** `skills/job-materials/scripts/sync_correction.py` (atomic JSON-first wrapper; regenerates DOCX/PDF; verifies regenerated artifacts contain the corrected text). Usage:

```
python3 skills/job-materials/scripts/sync_correction.py <json_path> \
    --surface cover_letter --paragraph N \
    --wrong "WRONG TEXT" --right "RIGHT TEXT" \
    --output-dir <output_dir>
```

The script:

- Loads JSON, applies correction, writes JSON atomically (with `.bak` rollback file).
- Invokes `generate_docs.py` to regenerate DOCX + PDF from the updated JSON.
- Verifies the regenerated DOCX contains the corrected text and lacks the wrong text.
- Returns exit 0 on success; non-zero with diagnostic on any failure.

Use `--dry-run` to apply the JSON correction without regenerating artifacts (useful for batch corrections or when artifact regeneration will happen separately).

**Surfaces supported:** `cover_letter` (paragraph-indexed), `resume_summary`. Extending to other surfaces (resume bullets, skills lines) is straightforward — see `apply_*_correction` functions in the script.

**Manual DOCX edits are forbidden** unless the source JSON is also updated in the same change set. If a DOCX edit is unavoidable (e.g., formatting-only correction outside the script's scope), document the divergence in the corresponding eval doc + composer notes so the JSON↔DOCX gap is traceable.
