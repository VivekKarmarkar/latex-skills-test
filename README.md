# latex-skills-test

Computational physics problems worked end-to-end — from derivation to numerical solution to publication-quality report — using a composable skill pipeline in Claude Code.

## Overview

Each problem follows the same workflow: derive the governing equations in LaTeX, formulate the ODE in Julia, solve it numerically, plot the results, and write a polished report combining everything. The entire pipeline runs from a single terminal session via slash commands (`/latex`, `/ode-problem-julia`, `/ode-solve-julia`, `/plot-julia`).

## Problems

### Triangular Force Pulse on a Rough Surface
A block on a rough surface is hit with a symmetric triangular force pulse that exceeds the static friction threshold. The system exhibits stick-slip dynamics with piecewise-linear forcing.

- **Derivation notes:** `triangular_pulse_block_ode.tex` / `.pdf` — 6-page derivation with four phases of motion, critical times, and dimensionless form
- **ODE definition:** `triangular_pulse_block.jl` — first-order system with stick-slip conditional RHS
- **Solve:** `solve_triangular_pulse_block.jl` — Tsit5 with `tstops` to handle discontinuities
- **Plot:** `plot_triangular_pulse_block.jl` — 3-panel figure (force, velocity, position)
- **Full report:** `triangular_pulse_block_report.tex` / `.pdf` — 8-page report combining derivation, Julia code, plot, and discussion of the numerical trap where adaptive solvers miss the event

### Exponential ODE
- **Derivation:** `exponential_ode_derivation.tex` / `.pdf`
- **ODE definition:** `exponential_ode_problem.jl`, `exponential_decay_problem.jl`
- **Solve:** `solve_exponential_ode_problem.jl`, `solve_exponential_decay_problem.jl`
- **Plot:** `plot_exponential_ode_problem.jl`, `plot_exponential_decay_problem.jl`

### Heat Equation
- **Derivation:** `heat_equation_derivation.tex` / `.pdf`

## Tech Stack

- **LaTeX** — `pdflatex` with `amsmath`, `tcolorbox`, `listings`, `fancyhdr`, `titlesec`
- **Julia** — `OrdinaryDiffEq.jl` (Tsit5 solver), `Plots.jl` (GR backend)

## Prerequisites

- A TeX distribution (`texlive` or equivalent) with `pdflatex`
- Julia 1.x with `OrdinaryDiffEq` and `Plots` packages

## Usage

Compile any `.tex` file:
```bash
pdflatex -interaction=nonstopmode <file>.tex
pdflatex -interaction=nonstopmode <file>.tex  # twice for cross-references
```

Run any `.jl` file:
```bash
julia <file>.jl
```

The files follow a naming convention: `<problem>.jl` (define), `solve_<problem>.jl` (solve), `plot_<problem>.jl` (plot).
