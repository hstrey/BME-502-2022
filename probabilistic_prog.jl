using Plots
#using LsqFit
import Distributions as di
using Random
using Turing
using Statistics
using StatsPlots
using FillArrays

n = di.Normal(1,2)
sample_n = rand(n,20)

@model function normal_fit(data)
	μ ~ Uniform(-10,10)
	σ ~ Uniform(0,20)
	for i in 1:length(data)
		data[i] ~ Normal(μ,σ)
	end
end

model1 = normal_fit(sample_n)
chain = Turing.sample(model1,NUTS(0.65),1000)
plot(chain)

rwd = Normal(0,1)
rw_steps = rand(rwd,999)

x = [0.0]
for step in rw_steps
    push!(x,x[end]+step)
end
plot(x)

steps = []
for i in 1:length(x)-1
    push!(steps,x[i+1]-x[i])
end

rw_steps
steps

@model function diffusion_fit(data)
	μ = 0
	σ ~ Uniform(0,20)
	for i in 1:length(data)
		data[i] ~ Normal(μ,σ)
	end
end

model2 = diffusion_fit(steps)
chain2 = Turing.sample(model2,NUTS(0.65),1000)