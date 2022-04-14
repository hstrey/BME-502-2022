using Plots
import Distributions
using Random
using Turing
using Statistics
using StatsPlots
using FillArrays

dataerr = 1.0
d = Cauchy(0,dataerr)

x = 0:10
y = 10.0 .* exp.(-x*0.1) .+ rand(d,length(x))

scatter(x,y,label=false)
#plot!(x_fit,y_fit,label=false)

@model function linear_fit(x,y)
    σ ~ Uniform(0.0,20.0)
    b ~ Uniform(-100.0,100.0)
    m ~ Uniform(-100.0,100.0)
    for i in 1:length(x)
        y[i] ~ Cauchy(b+m*x[i],σ)
    end
end

model_fit = linear_fit(x,y)
chain = sample(model_fit,NUTS(0.65),1000)
plot(chain)

mean(vec(chain[:b]))
std(vec(chain[:b]))

mean(vec(chain[:m]))
std(vec(chain[:m]))

@model function nonlinear_fit(x,y,f)
    σ ~ Uniform(0.0,20.0)
    b ~ Uniform(0.0,100.0)
    m ~ Uniform(0.0,1.0)
    for i in 1:length(x)
        y[i] ~ Cauchy(f(x[i],b,m),σ)
    end
end

function f(x,b,m)
    b*exp(-x*m)
end

model_nonlinear = nonlinear_fit(x,y,f)
chain2 = sample(model_nonlinear,NUTS(0.65),1000)

plot(chain2)