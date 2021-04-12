using Plots

include("project1.jl")
include("helpers.jl")

probname = "simple1"
n_seeds = 3
seed = 50
num_iter = 30

prob = PROBS[probname]

x0 = prob.x0()

# x = 1:10; y = rand(10); # These are the plotting data
# plot(x, y)
# #
#
# V(x,y) = x^2 + y^2
# x = range(-10,stop=10,length=50)
# y = range(-10,stop=10,length=50)
# contour(x,y, (x,y)->V(x,y), levels=30)

function optimize_plot_data(f, g, x0, n, prob)
    α = 0.1
    β = 0.5
    x = copy(x0)
    x_history = copy(x0)
    f_history = copy(f(x0))
    v = zeros(length(x))
    g_curr = zeros(length(x))
    g_prev = zeros(length(x))
    μ = 0.005
    for i = 1:num_iter-1
        g_curr = normalize!(copy(g(x)))
        α = α - μ*(g_curr⋅(-g_prev - β*v))
        v[:] = β*v + g_curr
        g_prev = copy(g_curr)
        x = x - α*(g_curr + β*v)
        x_history = vcat(x_history, x)
        f_history = vcat(f_history, f(x))
    end
    return x_history, f_history
end

# TODO: Contour plot for Rosenbrock function:
# use range of (-3.0, 3.0) for x1, x2
# z(x1, x2) = f([x1, x2])
x1 = range(-3.0,stop=3.0,length=50)
x2 = range(-3.0,stop=3.0,length=50)
rbrock = zeros(50,50)
for i = 1:50
    for j = 1:50
        rbrock[i,j] = prob.f([x1[i], x2[j]])
    end
end

# contour(x1,x2, (x1,x2)->f([x1,x2]), levels=30)
# contour(x1,x2, rbrock, levels=[10,25,50,100,200,250,300])
xhist_nseeds = zeros(num_iter, 2, n_seeds)
for i = 1:n_seeds
    Random.seed!(seed+i)
    xhist_nseeds[:,:,i], _ = optimize_plot_data(prob.f, prob.g, prob.x0(), prob.n, probname)
    plot!(xhist_nseeds[:,1,i], xhist_nseeds[:,2,i])
end

p1 = contour(x1, x2, rbrock, levels=[10,25,50,100,200,250,300], colorbar = false, c = cgrad(:viridis, rev = true), legend = false, xlims = (-2, 2), ylims = (-2, 2), xlabel = "x₁", ylabel = "x₂", aspectratio = :equal, clim = (2, 500))
plot!(xhist_nseeds[:,1,1], xhist_nseeds[:,2,1])
plot!(xhist_nseeds[:,1,2], xhist_nseeds[:,2,2])
plot!(xhist_nseeds[:,1,3], xhist_nseeds[:,2,3])
scatter!([xhist_nseeds[end,1,1]], [xhist_nseeds[end,2,1]], marker=:circle, markercolor=:red)
scatter!([xhist_nseeds[end,1,2]], [xhist_nseeds[end,2,2]], marker=:circle, markercolor=:green)
scatter!([xhist_nseeds[end,1,3]], [xhist_nseeds[end,2,3]], marker=:circle, markercolor=:purple)
savefig(p1, "rosenbrock_trajectories.pdf")


# Plot x_history on top of function contour


# # CONVERGENCE PLOTS
# fhist_nseeds = zeros(num_iter, n_seeds)
#
# for i = 1:n_seeds
#     Random.seed!(seed+i)
#     _, fhist_nseeds[:,i] = optimize_plot_data(prob.f, prob.g, prob.x0(), prob.n, probname)
# end
#
# p = plot(1:num_iter, fhist_nseeds, xlabel = "Iterations", ylabel = "Function value", title = "Rosenbrock Convergence Plot", label = ["Seed 1" "Seed 2" "Seed 3"], lw = 2)
# savefig(p, "rosenbrock_convergence.pdf")
