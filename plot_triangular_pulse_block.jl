# =============================================================================
# Plot: Block on Rough Surface Under Triangular Force Pulse
# =============================================================================
#
#   Source: solve_triangular_pulse_block.jl
#   Data:   sol.t (time), sol.u[:,1] (position), sol.u[:,2] (velocity)
#           F(t) (applied force), friction levels
#
# =============================================================================

using OrdinaryDiffEq
using Plots

# --- Data source (from solve file) ---

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
sol = solve(prob, Tsit5(), tstops=[1.0, 3.0, 5.0], dtmax=0.01)

# --- Extract components ---
t  = sol.t
x  = [sol.u[i][1] for i in eachindex(sol.u)]
v  = [sol.u[i][2] for i in eachindex(sol.u)]

m, μₛ, μₖ, g, Fmax = p
F_vals = [F_pulse(ti, Fmax) for ti in t]
fₛ = μₛ * m * g
fₖ = μₖ * m * g

# --- Critical times ---
t₁ = 1.0 + 2.0 * fₛ / Fmax
t₂ = 5.0 - 2.0 * fₖ / Fmax

# --- Plot (3-panel subplot) ---
p1 = plot(t, F_vals,
    label     = "F(t)",
    ylabel    = "Force [N]",
    title     = "Block on Rough Surface — Triangular Force Pulse",
    linewidth = 2,
    color     = :royalblue,
    legend    = :topright,
)
hline!(p1, [fₛ], label="μₛmg = $(round(fₛ, digits=2)) N", linestyle=:dash, color=:red, linewidth=1.5)
hline!(p1, [fₖ], label="μₖmg = $(round(fₖ, digits=2)) N", linestyle=:dot, color=:orange, linewidth=1.5)
vline!(p1, [t₁], label="t₁ = $(round(t₁, digits=2)) s", linestyle=:dashdot, color=:gray, linewidth=1)

p2 = plot(t, v,
    label     = "v(t)",
    ylabel    = "Velocity [m/s]",
    linewidth = 2,
    color     = :firebrick,
    legend    = :topright,
)
vline!(p2, [t₁], label="onset", linestyle=:dashdot, color=:gray, linewidth=1)
vline!(p2, [t₂], label="F < μₖmg", linestyle=:dashdot, color=:gray, linewidth=1)

p3 = plot(t, x,
    label     = "x(t)",
    xlabel    = "t [s]",
    ylabel    = "Position [m]",
    linewidth = 2,
    color     = :forestgreen,
    legend    = :topleft,
)
vline!(p3, [t₁], label="onset", linestyle=:dashdot, color=:gray, linewidth=1)

# --- Combine ---
plt = plot(p1, p2, p3,
    layout = (3, 1),
    size   = (800, 700),
    dpi    = 150,
)

# --- Save ---
savefig(plt, "triangular_pulse_block.png")
println("Plot saved: triangular_pulse_block.png")
