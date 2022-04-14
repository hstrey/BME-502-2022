using Plots
import Distributions
using Random
using Turing
using Statistics
using StatsPlots
using FillArrays

d1 = Normal(1,1)
d2 = Normal(2,1)

sample1 = rand(d1,20)
sample2 = rand(d2,20)

histogram(sample1)
histogram!(sample2)

@model function bayesgroups(sample1,sample2)
    m ~ Normal(0,10)
    σ ~ Uniform(0.001,5)
    μ ~ Uniform(-10,10)
    sample1 ~ MvNormal(fill(μ+m/2,length(sample1)),σ)
    sample2 ~ MvNormal(fill(μ-m/2,length(sample2)),σ)
end

model1 = bayesgroups(sample1,sample2)
chain = sample(model1,NUTS(0.65),1000)

plot(chain)