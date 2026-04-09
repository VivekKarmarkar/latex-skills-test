# The Narrative Arc: Feynman's Method Made Computational

> "A really good physicist should be able to solve a differential equation without actually solving it."
> — Richard Feynman (paraphrased)

## The Core Idea

Physics teaches how to think. The computer helps you solve problems. The real lesson lives in the space between the two — where human intuition and computational power validate each other.

## The Three-Step Arc

### Step 1: Think First

Before touching a computer, the physicist:

- Draws the force diagram
- Sketches a "predicted output" — a rough, hand-drawn curve of what she *expects* to happen
- Identifies the qualitative features from intuition alone: the block sits still (static friction absorbs the force), then breaks free (force exceeds threshold), then overshoots (kinetic friction is less than static), then brakes to a stop (friction wins)

This sketch is qualitative. It's rough. But it's *physics*. It comes from understanding, not calculation. No computer was involved. This is the part Feynman said matters most.

### Step 2: Compute

Run the skill pipeline:

- `/latex` — derive the governing ODE from first principles
- `/ode-problem-julia` — formulate the ODE for the computer
- `/ode-solve-julia` — solve it numerically
- `/plot-julia` — visualize the result

Now compare the numerical output to the hand sketch. Does the shape match? Do the qualitative features line up?

- If yes → you understand the problem. The computer confirmed your intuition.
- If no → either your intuition or your code is wrong. Figuring out *which one* is the real learning.

### Step 3: Reverse It

This is the deep move. The Feynman-level move.

Hand the computer the displacement trajectory — just the raw x(t) data, 814 points — and say: **"Find me the force law that produced this."**

Not numerical differentiation. Not "take two derivatives and see what you get." That gives noisy acceleration values.

Instead: **SINDy and PySR** — symbolic regression tools that discover the *structure* of the governing equation from data.

- **SINDy** (Sparse Identification of Nonlinear Dynamics): given a library of candidate functions, it finds the sparse combination that best fits the data. It tells you "the force law is piecewise-linear with a constant offset" and hands you the coefficients.
- **PySR** (Symbolic Regression via genetic programming): searches the space of possible expressions *without* you specifying a library. It discovers the functional form on its own.

Both are available in Julia (DataDrivenDiffEq.jl, SymbolicRegression.jl). Both become slash commands: `/sindy-julia`, `/symbolic-regression-julia`.

If the recovered force law matches the triangular pulse + Coulomb friction you started with... **the loop closes.**

## The Three-Way Validation

Each step operates at a different level of description:

| Step | What it produces | Level |
|------|-----------------|-------|
| **Physicist's sketch** | "It should overshoot and stop" | Qualitative — from intuition |
| **Forward solve** | "It overshoots by 11.85 m and stops at t ≈ 7" | Quantitative — from the ODE |
| **SINDy/PySR recovery** | "The force law is F(t) = 7.5(t−1) − 5.89 during sliding" | Structural — from data alone |

Three independent confirmations that you understood the physics. The sketch validates your intuition. The solver validates the math. The reverse recovery validates the solver.

## Why This Matters

Standard computational physics validation asks: "Is the numerical answer close to the analytical one?" That's comparing numbers.

Round-trip validation asks: **"Does the numerical answer contain enough information to reconstruct the physics?"** That's comparing *structure*.

This distinction matters for:
- **Problems without known analytical solutions** — you can't compare to a closed form, but you can check if the recovered ODE makes physical sense
- **Hybrid/switching systems** — did the solver preserve the stick-slip transition, or did it smooth it away?
- **Building confidence** — not "the numbers are close" but "the physics survived the computation and came back"

## The Deliverables

1. **The YouTube tutorial** — screen recording of the full arc: sketch → solve → recover. One terminal, one session.
2. **The Feynman-style lesson page** — dark-mode webpage opening with the hand sketch, not the equation
3. **The Brunton email** — "Used SINDy to close a round-trip validation loop on a piecewise stick-slip ODE. Recovered the force law from numerical displacement data. Here's the video."
4. **The skill vocabulary** — `/sindy-julia` and `/symbolic-regression-julia` join the pipeline, making round-trip validation a one-command operation

## The Pipeline (Complete)

```
Hand sketch (qualitative prediction)
        ↓
/latex (derive the ODE)
        ↓
/ode-problem-julia (formulate)
        ↓
/ode-solve-julia (solve forward)
        ↓
/plot-julia (visualize — compare to sketch)
        ↓
/sindy-julia (recover the ODE from data)
        ↓
Compare recovered ODE to original → loop closes
        ↓
/latex (write the report with all three validations)
```

Physics teaches how to think. The computer helps you solve. SINDy helps you verify. And the sketch — the rough, hand-drawn "I think it'll look like this" — is the part no computer can replace.

That's the arc.
