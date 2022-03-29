### A Pluto.jl notebook ###
# v0.18.1

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ ae22b97a-9a72-11ec-17d5-5be07c4373a9
begin
	using Plots
	using Distributions
	using PlutoUI
end

# ╔═╡ a9658aa9-9f2b-4242-866a-22fb587e8a13
md"""
# Gamma distribution
$(@bind a Slider(1:1000))
$(@bind t Slider(1:1000))
``\alpha \qquad \qquad\qquad\qquad\Theta``
"""

# ╔═╡ 2ee86f44-144a-451f-801a-85c8d0e05ae1
begin
	alpha = a * 0.01
	theta = t * 0.01
end

# ╔═╡ 7ffbaaf8-78d1-4061-99b6-90c055142091
g = Gamma(alpha, theta)

# ╔═╡ bc0166c7-8b3a-4616-8c33-6d9e18d88c65
begin
	x = 0:0.1:10
	plot(x,pdf.(g,x))
end

# ╔═╡ 17e131ad-8382-4b42-ad6c-1896027bad60
md"""
mean:   $(mean(g))
std:   $(std(g))
"""

# ╔═╡ Cell order:
# ╠═ae22b97a-9a72-11ec-17d5-5be07c4373a9
# ╟─a9658aa9-9f2b-4242-866a-22fb587e8a13
# ╟─2ee86f44-144a-451f-801a-85c8d0e05ae1
# ╟─7ffbaaf8-78d1-4061-99b6-90c055142091
# ╟─bc0166c7-8b3a-4616-8c33-6d9e18d88c65
# ╠═17e131ad-8382-4b42-ad6c-1896027bad60
