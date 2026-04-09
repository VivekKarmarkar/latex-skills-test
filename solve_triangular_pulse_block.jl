# =============================================================================
# ODE Solve: Block on Rough Surface Under Triangular Force Pulse
# =============================================================================
#
#   Source:  triangular_pulse_block.jl
#   ODE:    du₁/dt = u₂
#           du₂/dt = [F(t) - μₖ m g] / m   (sliding)
#                  = 0                       (stuck)
#   IC:     u₁(0) = 0.0, u₂(0) = 0.0
#   Domain: t ∈ [0, 8]
#   Params: m = 2.0, μₛ = 0.5, μₖ = 0.3, g = 9.81, Fmax = 15.0
#
# =============================================================================

using OrdinaryDiffEq

# --- Problem definition (from source file) ---

function F_pulse(t, Fmax)
    if t < 1.0
        return 0.0
    elseif t ≤ 3.0
        return Fmax * (t - 1.0) / 2.0
    elseif t ≤ 5.0
        return Fmax * (5.0 - t) / 2.0
    else
        return 0.0
    end
end

function f!(du, u, p, t)
    m, μₛ, μₖ, g, Fmax = p

    x = u[1]
    v = u[2]

    F = F_pulse(t, Fmax)
    fₛ = μₛ * m * g
    fₖ = μₖ * m * g

    if v ≤ 0.0 && F ≤ fₛ
        du[1] = 0.0
        du[2] = 0.0
    else
        du[1] = v
        du[2] = (F - fₖ) / m
    end
end

u0 = [0.0, 0.0]
tspan = (0.0, 8.0)
p = [2.0, 0.5, 0.3, 9.81, 15.0]   # m, μₛ, μₖ, g, Fmax
prob = ODEProblem(f!, u0, tspan, p)

# --- Solve ---
# tstops forces the integrator to step at force discontinuities (t=1,3,5).
# dtmax prevents the solver from leaping over the stick-slip transition.
sol = solve(prob, Tsit5(), tstops=[1.0, 3.0, 5.0], dtmax=0.01)

# --- Confirmation ---
println("ODE solved successfully:")
println("  retcode  = ", sol.retcode)
println("  t length = ", length(sol.t))
println("  t range  = [", sol.t[1], ", ", sol.t[end], "]")
println("  u(0)     = ", sol.u[1])
println("  u(end)   = ", sol.u[end])
