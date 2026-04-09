# =============================================================================
# ODE Problem Definition: Exponential Decay
# =============================================================================
#
#   ODE:     du/dt = α * u
#   IC:      u(0) = 0.5
#   Domain:  t ∈ [0, 1]
#   Params:  α = -1.0
#
# =============================================================================

using OrdinaryDiffEq

# --- Right-hand side function: f(u, p, t) → du/dt ---
function f(u, p, t)
    α = p[1]
    return α * u
end

# --- Initial condition ---
u0 = 0.5

# --- Time span ---
tspan = (0.0, 1.0)

# --- Parameters ---
p = [-1.0]   # α

# --- Define the ODE problem ---
prob = ODEProblem(f, u0, tspan, p)

println("ODEProblem defined successfully:")
println("  u0    = ", prob.u0)
println("  tspan = ", prob.tspan)
println("  p     = ", prob.p)
