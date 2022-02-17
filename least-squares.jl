using Polynomials: Polynomial,fit,coeffs
using Plots
using Distributions: Normal
using Random
using Statistics: mean, std

p = Polynomial([1,2,3])
@show coeffs(p)

errstd = 3
errNormal = Normal(0,errstd)

x = 0:10
y = 2 .+ 3 .* x .+rand(errNormal,11)

scatter(x,y,yerror=errstd,label=false)

fit_line = fit(x,y,1)
@show coeffs(fit_line)
plot!(x,fit_line.(x),label=false)

b_list = []
m_list = []
N = 1000
for i in 1:N
    y = 2 .+ 3 .* x .+rand(errNormal,11)
    fit_c = coeffs(fit(x,y,1))
    push!(b_list,fit_c[1])
    push!(m_list,fit_c[2])
end

@show mean(b_list)
@show mean(m_list)
@show std(b_list)
@show std(m_list)

histogram(b_list,bins=30)
histogram(m_list,bins=30)

