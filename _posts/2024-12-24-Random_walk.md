---
title: The Drunk Walker on $\mathbb{Z}^d$
date: 2024-12-24
layout: post
permalink: /Randomwalk/
excerpt : "A proof that a drunk man will find his way home, but a drunk bird may get lost forever"
---

*The complete article will be published in the next issue of the Invariant, the magazine of the [Oxford student's mathematics society](https://www.invariants.org.uk).*

<img src="../images/drinktardi.jpeg">


A random walk is a fundamental concept in probability theory, used to model stochastic processes in which an entity moves in steps determined by random choices. The most common types of random walks involve either independent identically distributed (i.i.d.) steps or steps governed by a Markov process.

In its simplest form, a random walk is defined on the integer lattice $\mathbb{Z}^d$, representing a sequence of steps taken in a $d$-dimensional space, with the direction and magnitude of each step determined by a probabilistic rule. These simple random walks have found applications in a wide range of fields, including statistical physics, computer science, finance, and ecology, where they model diverse phenomena such as diffusion, search processes, and the spread of information or disease.

In this context, the random walk on $\mathbb{Z}^d$ consists of a sequence of points $(S_n)_{n \geq 0}$, where each position $S_n \in \mathbb{Z}^d$ corresponds to the location of the walker at step $n$. The walker begins at the origin, $S_0 = 0$. At each step, it moves from its current position to a neighbouring site with direction chosen randomly.

The study of random walks on $\mathbb{Z}^d$ has a rich history. A classic result in the analysis of random walks is often stated as follows:

> **"A drunk man will find his way home, but a drunk bird may get lost forever."**

In other words, a 2D random walk will always return to the origin, whereas a 3D random walk has a positive probability of never returning. The first proof of this theorem was published in German by G. Pólya [[Pólya1921]](#polya1921), and a presentation of the proof can be found in English in [[FellerVol1]](#fellervol1). There are several proofs of this result, each employing a different strategy. Here, we propose an analytical proof inspired by [[DorianMA]](#dorianma) and [[Dym1985]](#dym1985). We show a stronger result: it's not just a drunk bird that may get lost forever, but any drunk form of life capable of moving in a $d$-dimensional space, with $d>2$.

We first look at the expected number of times the walker returns to zero and we will conclude about the probability of returning to zero in two corollaries.


## Main result

**Theorem:**
Let $d \in \mathbb{N}^{\ast}$, $\left(e_{1}, \ldots, e_{d}\right)$ be the canonical basis of $\mathbb{R}^{d}$, and $\left(X_{n}\right)_{n \in \mathbb{N}}$ be a sequence of independent and identically distributed random variables, uniformly distributed over $\left\lbrace \pm e_{1}, \ldots, \pm e_{d} \right\rbrace$. We define the Markov chain $\left(S_n\right)_{n \geq 0}$ by:



$$S_{0}=0~~\text{and}~~S_{n}=\sum_{k=1}^{n} X_{k},$$


then the expected number of visits to $0$ is finite if and only if $d \geq 3$, in other words:


$$\Sigma := \mathbb{E}\left(\sum_{n=0}^{+\infty} \mathbf{1}_{\left(S_{n}=0\right)}\right)<+\infty \Longleftrightarrow d \geq 3.$$

#### **Proof**

*The detailed proof is included in the original document published in the Invariant.*

The proof follows two key steps:

1. **Fourier Analysis Representation:** Using the characteristic function of the random walk, we express the probability of returning to zero as an integral over the torus $[0,1]^d$.
2. **Convergence Analysis:** By examining the integrability of a key function, we determine when the expected number of returns to zero is finite.

#### **Step 1: Fourier Analysis Representation**
By the Fubini–Tonelli theorem:

$$\Sigma = \sum_{n=0}^{+\infty} \mathbb{P}\left(S_{n}=0\right) = \sum_{n=0}^{+\infty} \int_{[0,1]^d} \varphi_{S_n}(2\pi x) \,dx,$$

where $\varphi_{S_n}(x)$ is the characteristic function of $S_n$. Using independence of $X_k$, we have:

$$\varphi_{S_n}(x) = \left(\varphi_{X_1}(x)\right)^n,$$

where

$$\varphi_{X_1}(x) = \frac{1}{d} \sum_{j=1}^{d} \cos(2 \pi x_j).$$

Thus,

$$\Sigma = \int_{[0,1]^d} \sum_{n=0}^{+\infty} \left(\varphi_{X_1}(2\pi x)\right)^{2n} \,dx=\int_{[0,1]^d} \frac{1}{1 - (\varphi_{X_1}(2\pi x))^2} \,dx
.$$  

#### **Step 2: Convergence Analysis**
By periodicity it suffixes to suffices to examine the integrability near $x = 0$. We approximate:

$$\varphi_{X_1}(x) \approx 1 - \frac{2 \pi^2}{d} \|x\|_2^2.$$  

Then, examining the integral:

$$\int_{[0,1]^d} \frac{1}{1 - (\varphi_{X_1}(2\pi x))^2} \,dx,$$

we find that convergence depends on the behavior of $1/\|x\|_2^2$. The integral is finite if and only if $d \geq 3$.

Thus, we conclude:

$$\Sigma < \infty \iff d \geq 3.$$  

---


## Corollaries
There is still some work required to bridge the gap between this theorem, which addresses the average number of times the walker returns to zero, and the statement in the introduction, which concerns the probability of returning to zero. The connection can be readily established using a basic lemma of probability: the Borel-Cantelli lemma.

**Corollary 1:**
If $d \geq 3$, then, almost surely, the random walk goes to infinity, i.e.,

$$\mathbb{P}\left(\left\|S_{n}\right\|_{1} \underset{n \rightarrow+\infty}{\longrightarrow}+\infty\right)=1.$$  

In other words, there is a positive probability that the random walk never returns to 0.

**Corollary 2:**
If $d \leq 2$, then almost surely the random walk passes through 0 an infinite number of times, that is,

$$\mathbb{P}\left(\sup \left\{n \in \mathbb{N}, S_{n}=0\right\}=+\infty\right)=1.$$  

In other words, for $d \leq 2$, the state 0 is recurrent, and the random walk will return to 0 with probability 1.

---

## References

- <a name="polya1921"></a>Pólya, G. (1921). ["Uber eine Aufgabe der Wahrscheinlichkeitsrechnung betreffend die Irrfahrt im Strassennetz."](http://eudml.org/doc/158886) *Mathematische Annalen*, **84**, 149-160.
- <a name="fellervol1"></a>Feller, W. (1968). [*An Introduction to Probability Theory and Its Applications, Volume 1*](https://www.bibsonomy.org/bibtex/2d8064d3a0c650a46aeb8c889eea08584/peter.ralph). John Wiley & Sons Inc.
- <a name="dym1985"></a>Dym, H., & McKean, H. P. (1985). [*Fourier Series and Integrals*](https://books.google.co.uk/books?id=atkQAQAAIAAJ). Elsevier Science.
- <a name="dorianma"></a>Cacitti-Holland, D. (2020). ["Marches aléatoires sur $\mathbb{Z}^d$"](https://perso.eleves.ens-rennes.fr/~dcaci409/marche.pdf). Accessed: 2022.

---

<script>
MathJax.typeset();
</script>
