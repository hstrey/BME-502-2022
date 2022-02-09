using Plots
using Distributions
using Random

1 + 1
a = 2.0

d = Normal(0,1)
data = rand(d,5)
plot(data)