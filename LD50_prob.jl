import Distributions
using Plots
using Statistics
using Turing
using StatsPlots

function invlogit(x)
	return exp(x)/(1+exp(x))
end

dose = [-0.86,-0.3,-0.05,0.73]
n = ones(4)*5
nd = [0,1,3,5]

@model function ld50_fit(dose,deaths,n)
    α ~ Uniform(-4.0,6.0)
    β ~ Uniform(-5.0,50)
	for i in 1:length(dose)
		Θ = invlogit(α+β*dose[i])
		deaths[i] ~ Binomial(n[i],Θ)
	end
end
    
model1 = ld50_fit(dose,nd,n)
chain = Turing.sample(model1,NUTS(0.65),1000)

alpha = vec(chain[:α])
beta = vec(chain[:β])

histogram(alpha)
histogram(beta)

ld50 = -alpha ./ beta

histogram(ld50)

mean(ld50)
std(ld50)
