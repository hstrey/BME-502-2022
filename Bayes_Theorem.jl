### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ f019936e-8e7f-11ec-2c9e-3b68771ae51c
md"""
## The basics 2
We just learned how to use Bayes theorem to calculate the posterior probability distribution that allows us to make a quantitative assessment of our decision whether we should accept this gambling game or not.  Such decisions are constantly made in the financial industry and Bayesian methods are commonly used in this environment.  In the financial industry the goal is to maximize profit and to minimize losses, so it is imperative to use quantitative tools.  In science, we have the problem that scientists are not in the same situation.  For scientists it is more important to get more grants, to write more papers since this is what is seen as the deliverables of their efforts.  What I would like to teach you is that by following Bayes theorem, we can improve the reliability of our research without sacrificing academic productivity.  We need to know our data though.
"""

# ╔═╡ 88d6a70f-85aa-41a1-b159-ce7c16238e5c
md"""
# Some important properties of Bayes theorem

Before we continue, I would like to point out a few important properties of Bayes theorem and its application.  The first property has to do with the way the posterior is calculated.  Let us go back to the coin flipping experiment and assume that we did an experiment with the coin in question that initially involved N=10 coin flips.  We used our prior and by combining it with the Bionomial likelihood, we were able to calculate the posterior:

$$P(p \mid \alpha,\beta, N, k) =  \frac{\Gamma(\alpha + \beta +N)}{\Gamma(\alpha+k)\Gamma(\beta + N -k)}  p^{\alpha-1+k}(1-p)^{\beta-1+N-k}$$

Lets now say that we are not quite sure about what to do and we ask the Gambler to let us flip another 10 times.  What we would do is to take the posterior that we derived, use it as our prior and then again use the Bionomial distribution as likelihood.  When looking back at the equations, it is pretty obvious that it does not matter whether you analyze the data sequentially (flip 10 times, calculate the posterior, flip 10 more times, update the posterior) or analyze it in one shot (take result of 20 flips, use prior, calculate posterior).  This is an important property of Bayes theorem.  It should not matter how you do the analysis.  It would be perfectly fine to flip the coin and update the posterior each time.  The result should be the same.  This statement is pretty obvious in our case but it holds in general. Later in this class we will see examples that are much more complicated than simple coin flips and here it sometimes makes sense to perform a complicated analysis with parts of the data and then repeat the process, rather than take all the data at once.  Also, in science it often happens that you measure some data, and you want to see whether it makes sense to persue this direction further.  That is perfectly ok.  If your inital posterior looks promising then go ahead and do some more measurements.  Bayesian analysis allows you to improve your statistics by repeating the experiment.
"""

# ╔═╡ dbec33c5-8ae8-4c77-8adc-979259063dad
md"""
The next property has to do with the shape of the posterior.  We have seen last lecture that a typical outcome of your posterior can be described by the maximum of the distribution (or the 50th percentile) and its width.  In our coin flipping experiment, the maximum will tell you whether or not the gamble will be profitable for you and the width will tell you about the certainty or uncertainty that this will happen.  In the financial market you would be interested whether a stock is likely to go up or down, and what the volatility is.  So lets use our posterior to calculate these quantities.

The first thing that we want to do is to take the natural logarithm of the probability distribution.  This will not change the maximum of $P(x)$ since the transformation is monotonic.  This transformation is often using in computational approaches to probability because it turns multiplication into additions.  You will see another reason in the next paragraph.

$$logp(x) = \log(P(x | D)$$

Now we can do a Taylor expansion around $x=x_{0}$.  Since we are concerned about a peaked probability distribution we only have a constant term and a quadratic term.

$$logp(x) = logp(x_{0}) + \frac{1}{2}\frac{d^{2}logp(x)}{dx^{2}}\big | _{x_{0}}(x-x_{0})^{2}+\dots$$

Putting this back into the previous equation yields:

$$P(x|D) \propto A \exp\big[\frac{1}{2}\frac{d^{2}logp(x)}{dx^{2}}\big | _{x_{0}}(x-x_{0})^{2}\big]$$
"""


# ╔═╡ ec134312-fdcf-4ec4-990f-3156cd9d0095
md"""
If you look at this equation you will recognize that what we have just done is to approximate our pdf with a Gaussian distribution.  Gaussian distributions are very commonly found, and the reason for this is beyond this class, but suffice to say that in many cases posterior distributions tend to approach Gaussian distributions for large N (law of large numbers).  Lets look at a Gaussian distribution:

$$P(x \mid \mu, \sigma) = \frac{1}{{\sigma \sqrt {2\pi } }}e^{{{ - \left( {x - \mu }\right)^2 } /{2\sigma ^2 }}}$$
"""



# ╔═╡ 73af177b-3dd3-4785-af4d-3191ed96efde
md"""
The maximum of this distribution can be found by finding the root of the first derivative with respect to x, and the standard deviation can be found by taking the second derivative.  Here is the calculation.  You can check it if you want yourself.  In particuar,

$$ \sigma = (-\frac{d^{2}logp(x)}{dx^{2}}|_{x_{0}})^{-\frac{1}{2}}$$

Once we know $\mu$ and $\sigma$ we can report our posterior pdf as:

$$ x = x_{0} \pm \sigma$$

Since we approximated our pdf with a Gaussian we also know that true value of x lies in within $\pm \sigma$ $67\%$ of the time and within $\pm 2\sigma$ $95\%$ of the time.
"""

# ╔═╡ 4d018fd2-5971-48ba-896a-27170f138b82
md"""
Lets get back to our example posterior and see what happens

$$P(p \mid |N,k) \propto p^{k}(1-p)^{N-k}$$ with
$$logp = c + k\log(p)+(N-k)\log(1-p)$$

The derivatives are:

$$\frac{dlogp}{dp}=\frac{k}{p}-\frac{N-k}{1-p}$$
$$\frac{d^2 logp}{dp^2}=-\frac{k}{p^2}-\frac{N-k}{(1-p)^2}$$

The maximum can be found

$$\frac{dlogp}{dp}\big | _{p_{0}} = \frac{k}{p_{0}}-\frac{N-k}{1-p_{0}}=0$$
$$p_{0}=\frac{k}{N}$$

which is not surprising.  The second derivate is then:
$$\frac{d^2 logp}{dp^2}\big | _{p_{0}}=-\frac{N}{p_{0}(1-p_{0})}$$

$$\sigma = \sqrt{\frac{p_{0}(1-p_{0})}{N}}$$

For larger N, p_{0} will not change much and the numerator will be essentially constant.  In this regime, the standard deviation \mu is inversely proportional to the square root of the number of tries.
"""

# ╔═╡ Cell order:
# ╠═f019936e-8e7f-11ec-2c9e-3b68771ae51c
# ╠═88d6a70f-85aa-41a1-b159-ce7c16238e5c
# ╠═dbec33c5-8ae8-4c77-8adc-979259063dad
# ╠═ec134312-fdcf-4ec4-990f-3156cd9d0095
# ╠═73af177b-3dd3-4785-af4d-3191ed96efde
# ╠═4d018fd2-5971-48ba-896a-27170f138b82
