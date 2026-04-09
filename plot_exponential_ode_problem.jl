# =============================================================================
# Plot: Exponential ODE (from derivation PDF)
# =============================================================================
#
#   Source: solve_exponential_ode_problem.jl
#   Data:   sol.t (time), sol.u (numerical), analytical u(t) = ½ eᵅᵗ
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
p = [1.0]   # α
prob = ODEProblem(f, u0, tspan, p)
sol = solve(prob, Tsit5())

# --- Analytical ground truth (dense) ---
t_dense = range(0.0, 1.0, length=200)
u_exact = 0.5 .* exp.(p[1] .* t_dense)

# --- Plot ---
plot(t_dense, u_exact,
    label      = "Analytical: u(t) = ½ eᵅᵗ",
    xlabel     = "t",
    ylabel     = "u(t)",
    title      = "Exponential ODE: du/dt = αu,  u₀ = ½,  α = 1",
    linewidth  = 2,
    linecolor  = :black,
    legend     = :topleft,
    size       = (900, 600),
    dpi        = 300
)
scatter!(sol.t, sol.u,
    label      = "Numerical (Tsit5, $(length(sol.t)) pts)",
    markersize = 7,
    markercolor = :dodgerblue,
    markerstrokewidth = 1.5,
    markerstrokecolor = :black
)

# --- Save ---
savefig("exponential_ode_problem.png")
println("Plot saved: exponential_ode_problem.png")
