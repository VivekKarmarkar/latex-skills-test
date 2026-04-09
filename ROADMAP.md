# Project Roadmap: Computational Physics Skill Pipeline + Round-Trip Validation

> **Created:** 2026-04-09
> **Status:** Draft
> **Owner:** Vivek Karmarkar

## Vision

Build a composable skill-based computational physics curriculum — working through Giordano & Nakanishi's *Computational Physics* textbook — where each chapter leaves behind a reusable slash command. Add a novel **round-trip validation** mechanism: solve forward (analytical → numerical), then recover the analytical structure from numerical data via symbolic regression, verifying the computation preserved the physics.

## Current State

- **Working:** Core pipeline exists — `/latex`, `/ode-problem-julia`, `/ode-solve-julia`, `/plot-julia` are built, tested, and synced to the OS repo (110 skills total)
- **Demonstrated:** Triangular pulse block problem solved end-to-end, including a genuine debugging moment (tstops trap) and publication-quality report
- **Not started:** Round-trip validation, symbolic regression tooling, systematic textbook progression
- **Key fact:** The pipeline already handles hybrid/switching ODEs (stick-slip friction), which is a harder class of problems than most intro textbook chapters

---

## Phase 1: Foundations — Symbolic Regression Tooling
**Goal:** Establish the reverse direction of the pipeline (numerical data → recovered ODE) and validate it on a simple problem where the answer is known.
**Status:** Not Started

| Priority | Task | Description | Dependencies |
|----------|------|-------------|-------------|
| P0 | Research symbolic regression tools | Evaluate PySR, SINDy (pysindy), DataDrivenDiffEq.jl — compare ease of use, Julia/Python interop, ability to handle piecewise functions | — |
| P0 | Build `/symbolic-regression` skill | Skill that takes numerical trajectory data and attempts to recover the governing ODE using the chosen tool | Research above |
| P1 | Validate on exponential decay | Forward: solve du/dt = -αu analytically + numerically. Reverse: recover -αu from the numerical data. Simplest possible round-trip. | `/symbolic-regression` skill |
| P1 | Validate on Lotka-Volterra | Forward: solve the predator-prey system. Reverse: recover the coupled ODEs. First test of a system (not scalar). | Exponential validation |
| P2 | Validate on triangular pulse block | Forward: today's problem. Reverse: can symbolic regression recover the piecewise-linear forcing and the stick-slip transition? This is the hard test. | Lotka-Volterra validation |

**Exit criteria:**
- [ ] `/symbolic-regression` skill exists and runs on Julia data
- [ ] Exponential decay round-trip succeeds (recovered ODE matches within tolerance)
- [ ] Lotka-Volterra round-trip succeeds for both equations
- [ ] Clear understanding of what fails on piecewise/hybrid systems and why

---

## Phase 2: Curriculum — Giordano & Nakanishi Chapters 1–5
**Goal:** Work through the first five chapters of the textbook, building new skills as needed, and validating each with the round-trip mechanism.
**Status:** Not Started

| Priority | Task | Description | Dependencies |
|----------|------|-------------|-------------|
| P0 | Ch 1: Radioactive decay / projectile motion | Simple first-order and second-order ODEs. Skills already exist — validate with round-trip. | Phase 1 complete |
| P0 | Ch 2: Realistic projectile motion | Air resistance, spin effects. Build `/drag-model` or extend existing ODE skills. Non-trivial nonlinearity. | Ch 1 |
| P1 | Ch 3: Oscillatory motion | Driven damped oscillator. Build `/phase-portrait` skill. Test round-trip on chaotic vs. periodic regimes. | Ch 2 |
| P1 | Ch 4: Chaos | Lorenz system, logistic map. Build `/bifurcation-diagram` skill. Key question: can symbolic regression recover a chaotic ODE from a trajectory? | Ch 3 |
| P2 | Ch 5: Potentials and fields | Laplace equation, relaxation methods. First PDE. Build `/pde-solve-julia` skill. Round-trip validation for PDEs is an open question. | Ch 4 |

**Exit criteria:**
- [ ] 4+ new skills built (phase-portrait, bifurcation-diagram, drag-model, pde-solve-julia or equivalent)
- [ ] Each chapter has: derivation (.tex/.pdf), numerical solution (.jl), plot (.png), report (.tex/.pdf), round-trip validation result
- [ ] Clear documentation of where round-trip validation succeeds and where it breaks down

---

## Phase 3: Advanced — Chapters 6–10 + Validation Theory
**Goal:** Extend to Monte Carlo, molecular dynamics, and wave phenomena. Develop a theoretical understanding of when round-trip validation works and when it doesn't.
**Status:** Not Started

| Priority | Task | Description | Dependencies |
|----------|------|-------------|-------------|
| P0 | Ch 6-7: Waves and PDEs | Wave equation, diffusion. Build `/animate-solution` skill for time-dependent PDEs. | Phase 2 complete |
| P0 | Ch 8: Monte Carlo methods | Random walks, Ising model. Build `/monte-carlo` skill. Round-trip: can you recover the Hamiltonian from Monte Carlo samples? | Ch 6-7 |
| P1 | Ch 9-10: Molecular dynamics | N-body simulation. Build `/parameter-sweep` skill for exploring parameter spaces. | Ch 8 |
| P1 | Validation theory writeup | LaTeX document characterizing: (1) which classes of ODEs are round-trip recoverable, (2) how noise/discretization affects recovery, (3) the role of data quantity and quality | All chapters |
| P2 | Publish the curriculum | Package the entire skill set + chapter walkthroughs + validation results as a public resource | Everything above |

**Exit criteria:**
- [ ] 6+ additional skills built
- [ ] Complete Giordano & Nakanishi coverage with skill-based approach
- [ ] Validation theory document exists with clear claims about what's recoverable and what's not
- [ ] Public repo with full curriculum

---

## Phase 4: The Webpage — Living Educational Platform
**Goal:** Turn the Feynman-style lesson page into a multi-chapter educational platform, one lesson per textbook chapter, each with interactive elements.
**Status:** Not Started

| Priority | Task | Description | Dependencies |
|----------|------|-------------|-------------|
| P0 | Template the lesson format | Extract the Feynman-structured lesson page into a reusable template — dark mode, show-before-explain, failure-as-centerpiece | Phase 2 started |
| P1 | One lesson per chapter | Each chapter gets a standalone webpage following the Feynman structure | Template + chapter content |
| P2 | Interactive elements | Embedded parameter sliders, live re-solve via WebAssembly Julia, animated plots | Chapters complete |
| P2 | Landing page + navigation | Index page linking all chapters, progress tracker, skill inventory | All lessons |

**Exit criteria:**
- [ ] At least 5 chapter lessons published as dark-mode webpages
- [ ] Consistent Feynman-style pedagogy across all lessons
- [ ] Accessible at a public URL

---

## Risks & Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|-----------|-----------|
| Symbolic regression can't handle piecewise/hybrid ODEs | High | High | Start with smooth problems, document the boundary. The failure itself is interesting and publishable. |
| SINDy/PySR tooling doesn't integrate cleanly with Julia pipeline | Medium | Medium | Consider DataDrivenDiffEq.jl (pure Julia) first. Fall back to Python via PyCall if needed. |
| Textbook progression is too rigid — some chapters may not yield interesting skills | Medium | Low | Skip or reorder chapters based on skill-building value. The curriculum serves the pipeline, not the other way around. |
| Round-trip validation is a novel idea — may hit fundamental theoretical limits | High | Medium | That's fine. Characterizing the limits IS the contribution. A paper on "what's recoverable and what isn't" is valuable. |
| Scope creep — this roadmap covers a lot | High | High | Phase 1 is self-contained and valuable on its own. Don't start Phase 2 until Phase 1 exit criteria are met. |

## Open Questions

- **Which symbolic regression tool?** PySR (Python, GP-based), pysindy (Python, sparse regression), DataDrivenDiffEq.jl (Julia, native DiffEq ecosystem). Need to evaluate all three on the exponential decay test case.
- **How much data does round-trip need?** 814 points worked for our block problem. Is that enough for symbolic regression? What's the minimum?
- **Noise tolerance?** Real experimental data has noise. How robust is the round-trip to noise in the trajectory data?
- **Piecewise recovery?** Can symbolic regression detect regime changes (stick-slip transitions)? Or does it need to be told where the switches are?
- **PDE round-trip?** Forward: solve Laplace equation numerically. Reverse: recover... what? The PDE itself? The boundary conditions? Both? This is genuinely unclear.

## Phase 5: The YouTube Lesson + Brunton Email
**Goal:** Record a YouTube tutorial that demonstrates the full round-trip — derive, solve, fail, fix, plot, recover the ODE via SINDy — all in one terminal. Then email Steve Brunton (the SINDy creator) with the result.
**Status:** Not Started
**Trigger:** Only start this after Phase 1 round-trip works on the piecewise block problem.

| Priority | Task | Description | Dependencies |
|----------|------|-------------|-------------|
| P0 | Nail the demo | Dry-run the full round-trip on the triangular pulse block: `/latex` → `/ode-problem-julia` → `/ode-solve-julia` → `/plot-julia` → `/sindy-julia` → recovered ODE matches. Must be clean and reproducible. | Phase 1 exit criteria met |
| P0 | Script the narrative | YouTube arc: (1) physical setup, (2) derive with `/latex`, (3) solve + hit the trap + fix, (4) "but how do we know the solver got it right?", (5) SINDy recovers the ODE from data, (6) round-trip closes, (7) "we never left the terminal." | Demo working |
| P1 | Record the video | Screen recording of the full session. Real terminal, real commands, real output. No slides — just the workflow. Voiceover explaining the physics and the pedagogy. | Script ready |
| P1 | Build the Feynman-style lesson page | Dark-mode webpage for this specific demo — the round-trip version of today's lesson, with the SINDy results section added | Demo working |
| P2 | Email Steve Brunton | Short email: "Used SINDy to close a round-trip validation loop in a terminal-based computational physics workflow. Recovered a piecewise stick-slip ODE from numerical data. Here's the video and the repo." Attach: YouTube link, GitHub repo, lesson page URL. | Video published |

**Exit criteria:**
- [ ] YouTube video published showing the complete round-trip in one terminal session
- [ ] Lesson webpage live with SINDy recovery results
- [ ] Email sent to Brunton with video + repo links

---

## Out of Scope

- Building a GUI or desktop application — this is terminal-first, skill-based
- Real-time or HPC simulation — the focus is pedagogy, not performance
- Rewriting the textbook — the book is the curriculum, the skills are the implementation
- Machine learning approaches to ODE discovery (neural ODEs, physics-informed networks) — interesting but a separate project
