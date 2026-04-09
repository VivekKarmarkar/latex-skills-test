# =============================================================================
# ODE Problem Definition: Block on Rough Surface Under Triangular Force Pulse
# =============================================================================
#
#   System (2nd-order → 1st-order):
#       du₁/dt = u₂                          (velocity)
#       du₂/dt = [F(t) - μₖ m g] / m         (when sliding)
#              = 0                             (when stuck)
#
#   where F(t) is a symmetric triangular pulse:
#       F(t) = 0                              t < 1
#       F(t) = Fmax * (t - 1) / 2            1 ≤ t ≤ 3
#       F(t) = Fmax * (5 - t) / 2            3 < t ≤ 5
#       F(t) = 0                              t > 5
#
#   Stick-slip transition:
#       Block is stuck when u₂ ≤ 0 and F(t) ≤ μₛ m g
#       Block slides when u₂ > 0 or F(t) > μₛ m g
#
#   IC:      u₁(0) = 0.0  (position),  u₂(0) = 0.0  (velocity)
#   Domain:  t ∈ [0, 8]
#   Params:  m = 2.0, μₛ = 0.5, μₖ = 0.3, g = 9.81, Fmax = 15.0
#
# =============================================================================

using OrdinaryDiffEq

# --- Triangular force pulse ---
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

# --- Right-hand side function: f!(du, u, p, t) → mutates du in-place ---
function f!(du, u, p, t)
    m, μₛ, μₖ, g, Fmax = p

    x = u[1]   # position
    v = u[2]   # velocity

    F = F_pulse(t, Fmax)
    fₛ = μₛ * m * g   # max static friction
    fₖ = μₖ * m * g   # kinetic friction

    # Determine if block is stuck or sliding
    if v ≤ 0.0 && F ≤ fₛ
        # Stuck: static friction balances applied force
        du[1] = 0.0
        du[2] = 0.0
    else
        # Sliding: kinetic friction opposes motion
        du[1] = v
        du[2] = (F - fₖ) / m
    end
end

# --- Initial condition ---
u0 = [0.0, 0.0]   # [x₀, v₀]

# --- Time span ---
tspan = (0.0, 8.0)

# --- Parameters ---
p = [2.0, 0.5, 0.3, 9.81, 15.0]   # m, μₛ, μₖ, g, Fmax

# --- Define the ODE problem ---
prob = ODEProblem(f!, u0, tspan, p)

println("ODEProblem defined successfully:")
println("  u0    = ", prob.u0)
println("  tspan = ", prob.tspan)
println("  p     = ", prob.p)
println()
println("  Critical values:")
m, μₛ, μₖ, g, Fmax = p
println("    μₛ m g  = ", μₛ * m * g, " N  (static friction limit)")
println("    μₖ m g  = ", μₖ * m * g, " N  (kinetic friction)")
println("    Fmax    = ", Fmax, " N  (peak force)")
println("    t₁      = ", 1.0 + 2.0 * μₛ * m * g / Fmax, " s  (onset of motion)")
println("    t₂      = ", 5.0 - 2.0 * μₖ * m * g / Fmax, " s  (force < kinetic friction)")
