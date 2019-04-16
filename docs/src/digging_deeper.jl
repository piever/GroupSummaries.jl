# # Digging deeper

# The core functioning of Recombinase is based on a set of preimplemented analysis
# functions and on the [OnlineStats](https://github.com/joshday/OnlineStats.jl) package
# to compute summary statistics efficiently.

# ## Analysis functions

# Under the hood, the actual computations are implemented in some built-in `Analysis`
# objects. Each `Analysis` takes some vectors (a varying number, one for `density`
# and two for `prediction` for example), an optional `axis` argument to specify
# the `x` axis argument and returns an iterator of `(x, y)` values, representing
# the `y` value corresponding to each point of the `x` axis.

using Recombinase: density, hazard, cumulative, prediction
x = randn(100)
res = density(x)
collect(Iterators.take(res, 5)) # let's see the first few elements

# We can collect the iterator in a table container to see
# that we recover the `x` and `y` axis, ready for plotting

using JuliaDB
s = table(res)

# `prediction` is similar but requrires two arguments:

xs = 10 .* rand(100)
ys = sin.(xs) .+ 0.5 .* rand(100)

res = prediction(xs, ys)
table(res)

# The function `discrete` can turn any analysis into its discrete counter-part
# (analyses are continuous for numerical axes and discrete otherwise by default).
# It also automatically comutes the error of the prediction (s.e.m).

using Recombinase: discrete

x = rand(1:3, 1000)
y = rand(1000) .+ 0.1 .* x

res = discrete(prediction)(x, y)
table(res)

# ## OnlineStats integration
