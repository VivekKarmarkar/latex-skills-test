# =============================================================================
# ODE Solve: Exponential Decay
# =============================================================================
#
#   Source:  exponential_decay_problem.jl
#   ODE:    du/dt = α * u
#   IC:     u(0) = 0.5
#   Domain: t ∈ [0, 1]
#   Params: α = -1.0
#
# =============================================================================

using OrdinaryDiffEq

# --- Problem definition (from source file) ---
function f(u, p, t)
    α = p[1]
    return α * u
end

u0 = 0.5
tspan = (0.0, 1.0)
p = [-1.0]   # α
prob = ODEProblem(f, u0, tspan, p)

# --- Solve (dense output for plotting) ---
sol = solve(prob, Tsit5(), saveat=0.01)

# --- Confirmation ---
println("ODE solved successfully:")
println("  retcode  = ", sol.retcode)
println("  t length = ", length(sol.t))
println("  t range  = [", sol.t[1], ", ", sol.t[end], "]")
println("  u(0)     = ", sol.u[1])
println("  u(end)   = ", sol.u[end])
