# Global preferences

## Commits

Keep commit messages short. Imperative subject under ~50 chars. Add a body only when the change isn't self-evident, and then only to explain *why* — the diff shows what changed; the message exists for whoever asks "why did this change?" six months from now.

No conventional-commit prefixes (`feat:`, `fix:`, etc.). No trailers, no `Co-Authored-By`, no "Generated with…" footers. No bulleted list of files touched.

After drafting, do a second pass purely for length: cut anything the diff already shows, trim wordy sentences, drop duplication. First pass is for ideas; second is for trimming.

Split unrelated changes into separate commits, but don't over-split — use judgement.

## Rewriting history

Don't rebase, amend, or force-push a commit that's already on the remote (GitHub etc.), especially on a squash-merge project — those operations are risky and any tidiness they'd buy is thrown away by the squash anyway. Amending something not yet pushed is fine, but check first (`git status` / compare with the upstream branch); it may have been pushed outside this session. All of these are of course fair game when you're explicitly asked to do involved git surgery.

## Pull requests

Same spirit as commits, only more so. Default to draft. The body is one short paragraph focused on *why*. No headers, no sections, no test plan unless I ask. Write the title and body as if they will become the final squash-merged commit message, because they usually do.

Base the PR description on the actual diff against the base branch (`git diff <base>...HEAD`), not on individual commit messages — intermediate work that got revised should not show up in the description.

## Test-driven development

Default to TDD for any non-trivial change — new behaviour, bug fixes, refactors that change observable behaviour.

Because the loop is outside-in, you don't need a detailed implementation plan up front — clarity on the desired behaviour is enough. Each test pulls the next slice of design out; planning further is usually wasted, since the next test will reshape it.

The loop, one small step at a time:

1. **Write one failing test** that captures the next slice of behaviour. Write it as if the ideal API already existed; the test is the first consumer of the code, so let it pull the shape of the interface.
2. **Run it and confirm it fails for the right reason** — a real assertion failure or a missing method, not a typo or fixture issue. If it passes on the first run, the test isn't exercising the new behaviour; rewrite it.
3. **Write the simplest implementation that makes it pass.** Don't generalize ahead of the next test.
4. **Refactor** with the green test as a safety net.
5. **Pick the next test.** Stop when the behaviour I set out to add is covered, including the failure modes a reviewer would ask about.

Rules that keep the loop honest:

- One failing test at a time. Don't write three tests and implement against all of them — that loses the per-step feedback that catches design problems early.
- Tests describe behaviour, not implementation. Assert on outcomes (return values, persisted state, emitted events), not on which private method got called. Behavioural tests are what makes the refactor step safe.
- Don't change the test to match what the code happens to do. If a passing implementation surprises you, either the test was wrong or the behaviour is wrong — figure out which before moving on.
- When fixing a bug, the first step is a test that reproduces it and fails. Then fix the code.

When TDD genuinely doesn't fit — pure exploration of an unfamiliar API, throwaway scripts, UI tweaks where a test would assert on snapshot-like detail, migrations whose only "test" is running them — say so explicitly and proceed without it. Reaching for these exemptions on a normal feature is the smell; when in doubt, write the test first.

## Open source tools

Your training knowledge for fast-moving OSS tools (mise, opentofu, caddy, podman, Tailwind 4, Vite 8, etc.) lags the live docs. Before writing config, using a non-trivial flag, or stating tool behaviour as fact, verify against current docs — `WebFetch` the project's docs site, or `--help` the local binary.

When you find a divergence between what you "knew" and what's true, save a `reference_<tool>_*.md` auto-memory with the canonical docs URL, so future sessions skip the lookup. (The existing mise memory is exactly this pattern — generalize it.)

Doesn't apply to bedrock tools (`git`, `grep`, POSIX shell) where knowledge is stable. Trigger: *fast-moving tool + about to write config or claim how it works*.
