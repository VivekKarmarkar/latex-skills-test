# =============================================================================
# Plot: Exponential Decay
# =============================================================================
#
#   Source: solve_exponential_decay_problem.jl
#   Data:   sol.t (time), sol.u (numerical solution)
#
# =============================================================================

using OrdinaryDiffEq
using Plots

# --- Data source (from solve file) ---
function f(u, p, t)
    α = p[1]
    return α * u
end

u0 = 0.5
tspan = (0.0, 1.0)
p = [-1.0]   # α
prob = ODEProblem(f, u0, tspan, p)
sol = solve(prob, Tsit5(), saveat=0.01)

# --- Plot ---
plot(sol.t, sol.u,
    label      = "Numerical (Tsit5)",
    xlabel     = "t",
    ylabel     = "u(t)",
    title      = "Exponential Decay: du/dt = αu,  u₀ = ½,  α = -1",
    linewidth  = 2,
    linecolor  = :crimson,
    legend     = :topright,
    size       = (900, 600),
    dpi        = 300
)

# --- Save ---
savefig("exponential_decay_problem.png")
println("Plot saved: exponential_decay_problem.png")
