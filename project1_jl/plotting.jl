using Plots

include("project1.jl")
include("helpers.jl")

probname = "simple1"
num_iter = 3

f, g, x0, n = PROBS[probname]

# # x = 1:10; y = rand(10); # These are the plotting data
# # plot(x, y)
#
# α = 0.1
# β = 0.5
# x = copy(x0)
# x_history = copy(x0)
# v = zeros(length(x))
# g_curr = zeros(length(x))
# g_prev = zeros(length(x))
# μ = 0.005
# while count(f,g) < n
#     g_curr = normalize!(copy(g(x)))
#     α = α - μ*(g_curr⋅(-g_prev - β*v))
#     v[:] = β*v + g_curr
#     g_prev = copy(g_curr)
#     x = x - α*(g_curr + β*v)
#     x_history = vcat(x_history, x)
#     # println(α)
#     # # print(x)
#     # print(f(x))
# end



Plots.pyplot() # back to pyplot
x = 1:0.5:20
y = 1:0.5:10
g(x, y) = begin
        (3x + y ^ 2) * abs(sin(x) + cos(y))
    end
X = repeat(reshape(x, 1, :), length(y), 1)
Y = repeat(y, 1, length(x))
Z = map(g, X, Y)
p1 = contour(x, y, g, fill=true)
p2 = contour(x, y, Z)
plot(p1, p2)
