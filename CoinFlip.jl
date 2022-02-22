### A Pluto.jl notebook ###
# v0.18.0

using Markdown
using InteractiveUtils

# ╔═╡ 2b6de7b6-832e-420f-b73c-9ebac9901547
begin
	import Distributions as di
	using Random
	using PlutoUI
end

# ╔═╡ 8b908968-8e7f-11ec-08b9-797a5b416d46
md"""
# The Basics
"There are three types of lies: lies, damned lies and statistics." -- Benjamin Disraeli (1804-1881)

This quote by Disraeli expresses a common sentiment.  Especially in the biosciences, statistics is often used in a cookie-cutter way to distinguish between significant and insignificant results, but we are all left with a bad taste in our mouth when trying to deeply think about the underlying concepts.
In this class, I would like to instead pursue the subject of data analysis using a probabilistic approach that was formulated by Bayes (published in 1763) and later refined by Laplace (1812).
# Introduction
In Science we are faced with a difficult task.  We are observing the world through experiments but what we would like to derive from this are its laws.  Unfortunately, this task is not only difficult, but it is actually an impossible task.  The reason for this is that there are many possible laws that could explain all the data that we collect.  This is in contrast to mathematical logic, where everything can be derived from a set of axioms.  The mathematician is asking: given a cause, can we work out its consequences? Scientist do the reverse: Given that certain effects have been observed, what are the underlying causes?
# Coin flip example
To illustrate the problem, we are going to start with a familiar problem: the coin flip.  Let us assume that you are visiting Las Vegas and someone invited you to a game in which you bet one dollar and after a coin flip you get paid two dollars for heads but lose your bet when tails come.  It is pretty clear from the outset that if the game uses a "fair" coin (tails:head = 1:1) then you should not win or lose any money.  To make it more interesting the person that invited you to play flips the coin 10 times and you observe that heads came 6 times and tails came 4 times.  How does this information help you to decide whether to play this game since you suspect that the coin is probably not fair (it is Las Vegas after all).

The first thing that we can do is to ask a different question: What is the probability that 6 heads out of ten resulted from a fair coin (some statistician would call the fair coin the "null hypothesis").  Here we are going to employ the Bionomial distribution which gives us what we are looking for:

$$P( X = k \mid N,p) =  \frac{N!}{(N-k)!k!}  p^k(1-p)^{N-k}$$

Notice that we wrote the Binomial distribution as a conditional probability to indicate that it represents the probability of $X=k$ given $N$ and $p$. Below we are calculating the odds for each situation:
"""

# ╔═╡ a7995c55-88d7-435c-839d-22278c0667a2
gambler = di.Binomial(100,0.5)

# ╔═╡ 0056269b-7f58-466f-acb3-f1a73f736133
with_terminal() do
	for i in 0:5:100
		println(i," ",di.pdf(gambler,i))
	end
end

# ╔═╡ 3c768871-2f62-4ae2-980b-aa9494e32a80
md"""
We just learned how to use Bayes theorem to calculate the posterior probability distribution that allows us to make a quantitative assessment of our decision whether we should accept this gambling game or not.  Such decisions are constantly made in the financial industry and Bayesian methods are commonly used in this environment.  In the financial industry the goal is to maximize profit and to minimize losses, so it is imperative to use quantitative tools.  In science, we have the problem that scientists are not in the same situation.  For scientists it is more important to get more grants, to write more papers since this is what is seen as the deliverables of their efforts.  What I would like to teach you is that by following Bayes theorem, we can improve the reliability of our research without sacrificing academic productivity.  We need to know our data though.

# Some important properties of Bayes theorem

Before we continue, I would like to point out a few important properties of Bayes theorem and its application.  The first property has to do with the way the posterior is calculated.  Let us go back to the coin flipping experiment and assume that we did an experiment with the coin in question that initially involved N=10 coin flips.  We used our prior and by combining it with the Bionomial likelihood, we were able to calculate the posterior:

$$P(p \mid \alpha,\beta, N, k) =  \frac{\Gamma(\alpha + \beta +N)}{\Gamma(\alpha+k)\Gamma(\beta + N -k)}  p^{\alpha-1+k}(1-p)^{\beta-1+N-k}$$

Lets now say that we are not quite sure about what to do and we ask the Gambler to let us flip another 10 times.  What we would do is to take the posterior that we derived, use it as our prior and then again use the Bionomial distribution as likelihood.  When looking back at the equations, it is pretty obvious that it does not matter whether you analyze the data sequentially (flip 10 times, calculate the posterior, flip 10 more times, update the posterior) or analyze it in one shot (take result of 20 flips, use prior, calculate posterior).  This is an important property of Bayes theorem.  It should not matter how you do the analysis.  It would be perfectly fine to flip the coin and update the posterior each time.  The result should be the same.  This statement is pretty obvious in our case but it holds in general. Later in this class we will see examples that are much more complicated than simple coin flips and here it sometimes makes sense to perform a complicated analysis with parts of the data and then repeat the process, rather than take all the data at once.  Also, in science it often happens that you measure some data, and you want to see whether it makes sense to persue this direction further.  That is perfectly ok.  If your inital posterior looks promising then go ahead and do some more measurements.  Bayesian analysis allows you to improve your statistics by repeating the experiment.

The next property has to do with the shape of the posterior.  We have seen last lecture that a typical outcome of your posterior can be described by the maximum of the distribution (or the 50th percentile) and its width.  In our coin flipping experiment, the maximum will tell you whether or not the gamble will be profitable for you and the width will tell you about the certainty or uncertainty that this will happen.  In the financial market you would be interested whether a stock is likely to go up or down, and what the volatility is.  So lets use our posterior to calculate these quantities.

The first thing that we want to do is to take the natural logarithm of the probability distribution.  This will not change the maximum of $P(x)$ since the transformation is monotonic.  This transformation is often using in computational approaches to probability because it turns multiplication into additions.  You will see another reason in the next paragraph.

$$logp(x) = \log(P(x | D)$$

Now we can do a Taylor expansion around $x=x_{0}$.  Since we are concerned about a peaked probability distribution we only have a constant term and a quadratic term.

$$logp(x) = logp(x_{0}) + \frac{1}{2}\frac{d^{2}logp(x)}{dx^{2}}\big | _{x_{0}}(x-x_{0})^{2}+\dots$$

Putting this back into the previous equation yields:

$$P(x|D) \propto A \exp\big[\frac{1}{2}\frac{d^{2}logp(x)}{dx^{2}}\big | _{x_{0}}(x-x_{0})^{2}\big]$$

If you look at this equation you will recognize that what we have just done is to approximate our pdf with a Gaussian distribution.  Gaussian distributions are very commonly found, and the reason for this is beyond this class, but suffice to say that in many cases posterior distributions tend to approach Gaussian distributions for large N (law of large numbers).  Let look at a Gaussian distribution:

$$P(x \mid \mu, \sigma) = \frac{1}{{\sigma \sqrt {2\pi } }}e^{{{ - \left( {x - \mu } \right)^2 } /{2\sigma ^2 }}}$$
"""


# ╔═╡ a73a746c-cfdf-434b-89ba-a77b98543a81
md"""
The maximum of this distribution can be found by finding the root of the first derivative with respect to $x$, and the standard deviation can be found by taking the second derivative.  Here is the calculation.  You can check it if you want yourself.  In particuar,

$$\sigma = \big(-\frac{d^{2}logp(x)}{dx^{2}}\big | _{x_{0}}\big)^{-\frac{1}{2}}$$
"""

# ╔═╡ 8f0d784e-7f3f-4aee-80df-a9e2f5f31157
md"""
Once we know $\mu$ and $\sigma$ we can report our posterior pdf as:

$$x = x_{0} \pm \sigma$$

Since we approximated our pdf with a Gaussian we also know that true value of x lies in within $\pm \sigma$ $67$ of the time and within $\pm 2\sigma$ $95$ of the time.

Lets get back to our example posterior and see what happens

$$P(p \mid |N,k) \propto p^{k}(1-p)^{N-k}$$ with
$$logp = c + k\log(p)+(N-k)\log(1-p)$$
"""

# ╔═╡ 5b24e37c-a5ce-40b2-97db-d850ac74523f
md"""
The derivatives are:

$$\frac{dlogp}{dp}=\frac{k}{p}-\frac{N-k}{1-p}$$
$$\frac{d^2 logp}{dp^{2}}=-\frac{k}{p^2}-\frac{N-k}{(1-p)^2}$$

The maximum can be found

$$\frac{dlogp}{dp}\big | _{p_{0}} = \frac{k}{p_{0}}-\frac{N-k}{1-p_{0}}=0$$
$$p_{0}=\frac{k}{N}$$

which is not surprising.  The second derivate is then:
$$\frac{d^2 logp}{dp^2}\big | _{p_{0}}=-\frac{N}{p_{0}(1-p_{0})}$$

$$\sigma = \sqrt{\frac{p_{0}(1-p_{0})}{N}}$$

For larger $N$, $p_{0}$ will not change much and the numerator will be essentially constant.  In this regime, the standard deviation $\mu$ is inversely proportional to the square root of the number of tries
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[compat]
Distributions = "~0.25.48"
PlutoUI = "~0.7.34"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "f9982ef575e19b0e5c7a98c6e75ee496c0f73a93"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.12.0"

[[ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "44c37b4636bc54afac5c574d2d02b625349d6582"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.41.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3daef5523dd2e769dad2365274f760ff5f282c7d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.11"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[DensityInterface]]
deps = ["InverseFunctions", "Test"]
git-tree-sha1 = "80c3e8639e3353e5d2912fb3a1916b8455e2494b"
uuid = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
version = "0.4.0"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Distributions]]
deps = ["ChainRulesCore", "DensityInterface", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "38012bf3553d01255e83928eec9c998e19adfddf"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.48"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "deed294cde3de20ae0b2e0355a6c4e1c6a5ceffc"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.12.8"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "a7254c0acd8e62f1ac75ad24d5db43f5f19f3c65"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.2"

[[IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "e5718a00af0ab9756305a0392832c8952c7426c1"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.6"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "ee26b350276c51697c9c2d88a072b339f9f03d73"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.5"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "13468f237353112a01b2d6b32f3d0f80219944aa"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.2"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "8979e9802b4ac3d58c503a20f2824ad67f9074dd"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.34"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "2cf929d64681236a2e074ffafb8d568733d2e6af"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.3"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "78aadffb3efd2155af139781b8a8df1ef279ea39"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.4.2"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "bf3188feca147ce108c76ad82c2792c57abe7b1f"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.0"

[[Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "68db32dff12bb6127bac73c209881191bf0efbb7"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.3.0+0"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "8d0c8e3d0ff211d9ff4a0c2307d876c99d10bdf1"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.2"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c3d8ba7f3fa0625b062b82853a7d5229cb728b6b"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.2.1"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8977b17906b0a1cc74ab2e3a05faa16cf08a8291"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.16"

[[StatsFuns]]
deps = ["ChainRulesCore", "InverseFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "f35e1879a71cca95f4826a14cdbf0b9e253ed918"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "0.9.15"

[[SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╠═2b6de7b6-832e-420f-b73c-9ebac9901547
# ╟─8b908968-8e7f-11ec-08b9-797a5b416d46
# ╠═a7995c55-88d7-435c-839d-22278c0667a2
# ╠═0056269b-7f58-466f-acb3-f1a73f736133
# ╟─3c768871-2f62-4ae2-980b-aa9494e32a80
# ╟─a73a746c-cfdf-434b-89ba-a77b98543a81
# ╟─8f0d784e-7f3f-4aee-80df-a9e2f5f31157
# ╟─5b24e37c-a5ce-40b2-97db-d850ac74523f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
