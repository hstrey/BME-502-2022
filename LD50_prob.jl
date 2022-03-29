import Distributions
using Plots
using Statistics
using Turing

function invlogit(x)
	return exp(x)/(1+exp(x))
end

dose = [-0.86,-0.3,-0.05,0.73]
n = ones(4)*5
nd = [0,1,3,5]

function posterior(α,β,dose,deaths,n)
	p_list = []
	for (d,nd,nn) in zip(dose,deaths,n)
		θ = invlogit(α+β*d)
		push!(p_list,θ^nd*(1-θ)^(nn-nd))
	end
	return prod(p_list)
end

@model function ld50_fit(dose,deaths,n)
    α ~ Uniform(-4.0,6.0)
    β ~ Uniform(-5.0,50)
    