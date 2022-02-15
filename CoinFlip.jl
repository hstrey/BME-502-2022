### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

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

# ╔═╡ Cell order:
# ╟─8b908968-8e7f-11ec-08b9-797a5b416d46
