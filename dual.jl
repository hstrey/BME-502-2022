### A Pluto.jl notebook ###
# v0.18.4

using Markdown
using InteractiveUtils

# ╔═╡ 066c5b84-c19e-11ec-3f27-115d87575e0d
struct Dual{T}
	val::T
	der::T
end

# ╔═╡ fd3fcf64-b334-4ba7-862f-cdc02b221d6e
a = Dual(3.0,5.0)

# ╔═╡ 393d4637-21a3-4ce3-b720-bca1439c3233
typeof(a.val)

# ╔═╡ ca1251ce-b63f-4075-94c8-c0d184655bdc
Base.:+(f::Dual, g::Dual) = Dual(f.val + g.val, f.der + g.der)

# ╔═╡ 5d59360d-fd53-4996-8400-7d218e4eb29f
Base.:+(f::Dual, α::Number) = Dual(f.val + α, f.der)

# ╔═╡ 32d7e717-6a90-4975-a20a-80c7cabcb85c
Base.:+(α::Number, f::Dual) = f + α

# ╔═╡ 8cdaede1-9825-4404-8898-295c4b0f6e94
Base.:-(f::Dual, g::Dual) = Dual(f.val - g.val, f.der - g.der)

# ╔═╡ 4acc7af2-7eba-4d68-a106-245fb310b9b9
Base.:*(f::Dual, g::Dual) = Dual(f.val * g.val, f.der*g.val + g.der*f.val)

# ╔═╡ 0b9d1885-e113-42f3-b808-90064338f9e2
Base.:^(f::Dual, n::Integer) = Base.power_by_squaring(f,n)

# ╔═╡ 0336e41f-aabd-40a9-af47-dfeed25daa68
begin
	import Base:exp
	exp(f::Dual) = Dual( exp(f.val), exp(f.val)*f.der )
end

# ╔═╡ 9f4518e5-b444-4bd9-8ecf-23450a4d9125
b = Dual(2.0,7.0)

# ╔═╡ e63e723a-e023-4a35-bdaa-be6a3bf4b628
a + b

# ╔═╡ eb39443c-1b71-4137-b777-086700d44a51
 a - b

# ╔═╡ 6b25fab1-aee7-497d-8055-444a4c03aedb
a * b

# ╔═╡ 85588519-64e0-41ba-872a-1942c5a6925d
a^3

# ╔═╡ d1227abf-b2e8-43f8-8efb-aa353455d5ba
a*(a+b)

# ╔═╡ 0609e93e-f7b4-462c-82ba-d674871dc4d5
exp(a)

# ╔═╡ Cell order:
# ╠═066c5b84-c19e-11ec-3f27-115d87575e0d
# ╠═fd3fcf64-b334-4ba7-862f-cdc02b221d6e
# ╠═393d4637-21a3-4ce3-b720-bca1439c3233
# ╠═ca1251ce-b63f-4075-94c8-c0d184655bdc
# ╠═5d59360d-fd53-4996-8400-7d218e4eb29f
# ╠═32d7e717-6a90-4975-a20a-80c7cabcb85c
# ╠═8cdaede1-9825-4404-8898-295c4b0f6e94
# ╠═4acc7af2-7eba-4d68-a106-245fb310b9b9
# ╠═0b9d1885-e113-42f3-b808-90064338f9e2
# ╠═0336e41f-aabd-40a9-af47-dfeed25daa68
# ╠═9f4518e5-b444-4bd9-8ecf-23450a4d9125
# ╠═e63e723a-e023-4a35-bdaa-be6a3bf4b628
# ╠═eb39443c-1b71-4137-b777-086700d44a51
# ╠═6b25fab1-aee7-497d-8055-444a4c03aedb
# ╠═85588519-64e0-41ba-872a-1942c5a6925d
# ╠═d1227abf-b2e8-43f8-8efb-aa353455d5ba
# ╠═0609e93e-f7b4-462c-82ba-d674871dc4d5
