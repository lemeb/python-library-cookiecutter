---
name: interview
description:
  Conduct a structured feature interview to gather requirements before
  implementation. Asks about scope, user experience, technical design, and edge
  cases. Outputs a specification document. Use before /go-on for complex features.
---

# Feature Interview

## Purpose

Gather complete requirements through structured questioning before writing any
code. This surfaces hidden assumptions and design decisions when they're cheap
to change.

## When to Use

- Feature idea that needs clarification
- Ambiguous requirements with multiple valid implementations
- Complex features where scope needs definition
- Before `/go-on` for non-trivial work

## Arguments

```
/interview "feature description"
/interview "feature description" --context path/to/existing-doc.md
```

## Interview Phases

### Phase 1: Scope & MVP (2-3 questions)

- What core problem does this solve?
- Who are the primary users?
- What's explicitly OUT of scope?
- What's the minimum viable version?

### Phase 2: User Experience (2-3 questions)

- How will users interact with this?
- What are the main user journeys?
- What happens when things go wrong?
- Any accessibility considerations?

### Phase 3: Technical Design (2-3 questions)

- What data needs to be persisted?
- External integrations or APIs needed?
- Security or authentication concerns?
- Performance constraints?

### Phase 4: Edge Cases (1-2 questions)

- What scenarios haven't been considered?
- What are the key tradeoffs?
- How does this interact with existing features?

## Question Design

1. **Avoid obvious questions** — Don't ask "do you want error handling?" Ask
   "which errors should fail gracefully vs. fail fast?"

2. **Reveal assumptions** — Ask what the user hasn't considered

3. **Provide options** — Use `AskUserQuestion` with context-specific choices
   based on the codebase

4. **Be specific** — Require measurable outcomes, not vague "works correctly"

## Completion Criteria

End the interview when:
- [ ] Scope boundary is clear (MVP defined)
- [ ] User flows are mapped
- [ ] Technical approach is sketched
- [ ] Major edge cases are identified
- [ ] User confirms "done" or "finalize"

## Output Format

Generate a spec file (per tracker conventions) with:

```markdown
# Feature: [Name]

## Problem

[What problem does this solve?]

## Proposed Solution

[High-level approach]

## User Stories

- As a [user], I want [goal] so that [benefit]
  - Acceptance: [testable criterion]

## Technical Notes

- Data model considerations
- API design notes
- Integration points

## Acceptance Criteria

- [ ] [Specific, testable criterion]
- [ ] [Another criterion]

## Out of Scope

- [What this explicitly doesn't do]

## Open Questions

- [Anything deferred to implementation]
```

## Example

**User**: "I want to add user authentication"

**Interview asks**:
- "Email/password only, or also social login (Google, GitHub)?"
- "Should sessions persist across browser restarts?"
- "What happens after 3 failed login attempts?"
- "Do you need password reset, or is that future work?"

**Result**: Clear spec with JWT vs. session decision, lockout policy, and
explicit scope boundaries.

## After Interview

Once you have a spec:
1. Save it per tracker conventions (e.g., `specs/auth.md`)
2. Run `/go-on` to start the implementation workflow
