---
jupytext:
  formats: md:myst
  text_representation:
    extension: .md
    format_name: myst
kernelspec:
  display_name: Matlab
  name: matlab
  language: Matlab
---

# Graphs and Networks

Understanding complex systems often requires a bottom-up analysis. This can be
done by examining the elementary parts of the system individually and then
by turning the analysis towards the connection between them. A natural way of
performing this type of analysis is through the use of **networks** or
**graphs**.

```{prf:definition}
A **graph** $G=(V,E)$ consists of a finite set $V$ of **vertices** (or nodes)
and a finite set $E$ of **edges**, where each edge $e\in E$ is of the form
$e=\{u,v\}$ with $u,v\in V$.
```

And we will make here the following simplifying assumptions:
- we do not allow any edge to be a self-loop, i.e., an edge that starts and ends
at the same vertex,
- we do not allow more than one edge between any pair of vertices,
- unless mentioned otherwise we will mostly consider undirected edges, that is
edge $e = \{u,v\} = \{v,u\}$.

Now, let us fix some notation and nomenclature.
```{prf:definition}
Two vertices, $u$ and $v$, are called **adjacent** if there is an edge, $uv$,
connecting them. We can express adjacency of $u$ and $v$ by writing $u\sim v.$
```

```{prf:definition}
If $v$ is a vertex in a graph $G$, the **degree** of $v$, denoted $\operatorname{deg}(v)$,
is the number of edges adjacent to $v$.
```

```{prf:definition}
A **walk** in a graph is a sequence of vertices and edges $v_0$, $e_1$, $v_1$, $e_2$, $v_2$, $\ldots$, $v_{k-1}$, $e_k$, $v_k$ such that edge $e_i$ connects vertices $v_{i-1}$ and $v_i$, for $1 \leq i \leq k$.
```

```{prf:definition}
A graph $G$ is **connected** if for any two vertices $u$ and $v$ of $G$,
there is a *walk* in $G$ from $u$ to $v$.
```

The first way to store a graph into a computer is as an **adjacency matrix**.
Given a graph $G$ with $n$ vertices, we start by label them from $1$ to $n$, then
the adjacency matrix representing this graph will be an $n\times n$ matrix
whose entries are either 0 or 1, specifically
```{math}
A(i,j) = \begin{cases}
1, & (v_i,v_j) \in E,\\
0, & \text{otherwise}.
\end{cases}
```

We now have much of the dictionary we need to start investigating some examples
of graphs and networks that are used in applications. We will uncover some more
information by working through the test cases.

## A social network made of dolphins

How can we use these abstract objects to model some systems of interest? We have
said from the beginning that graphs are useful to describe pairwise interactions
between vertices. We will start as usual from an example, and in particular we
will focus on the network of social relationship between a population of
Doubtful Sound bottlenose dolphins {cite}`lusseau2003emergent`. It has been
observed that gregarious, long-lived animals, such as gorillas (*Gorilla
gorilla*), deer (*Cervus elaphus*), elephants (*Loxodonta
africanus*) and bottlenose dolphins (*Tursiops truncatus*) rely
on information transfer to exploit their habitat. Thus investigating their
social structure is surely of interest.

First of all, let us fetch and load the data into the MATLAB environment
```{code-cell} matlab
websave('dolphins.mat','https://suitesparse-collection-website.herokuapp.com/mat/Newman/dolphins.mat');
load('dolphins.mat')
disp(Problem)
```
The variable `Problem` is a `struct` variables containing several information,
what mostly concerns us now is the field `Problem.A` that contains the **adjacency**
matrix of our graph. We can now use MATLAB to transform it into the graph
format and visualize it
```{code-cell} matlab
G = graph(Problem.A);
figure(1)
plot(G)
title(Problem.title)
```
What are we seeing? In the word of the *author* {cite}`lusseau2003emergent`:
> Every time that
a school of dolphins was encountered in the fjord between 1995 and
2001, each adult member of the school was photographed and identified from natural markings on the dorsal fin. This information was
used to determine how often two individuals were seen together. To
measure how closely two individuals were associated in the population (i.e. how often they were to be found together) I calculated a half-weight index (HWI) of association for each pair of individuals
(Cairns & Schwäger 1987). This index estimates the likelihood that
two individuals would be seen together compared with the likelihood
of seeing any of the two individuals when encountering a school: [...]
Over the 7 years of observation the composition of 1292
schools was gathered. There were 64 adult individuals in
this social network linked by 159 preferred companionships (edges)

Now let us  try to investigate some properties of the network to infer some
information on the dolphins. The first thing we want to look at are the **degrees**
of the vertexes:
```{code-cell} matlab
degree = G.degree;
[sorted_degree,rank] = sort(degree,'descend');
figure(2)
plot(1:G.numnodes,sorted_degree,'o');
axis([1 64 1 max(degree)])
xlabel('Vertex')
ylabel('Degree')
xticks(1:G.numnodes)
xticklabels(rank)
xtickangle(90)
```
The behavior of the (reordered) degree distribution seem suspicious... let us
look more into it, we call $k$ the degree and $p(k)$ the number of nodes with
that degree
```{code-cell} matlab
[gc,gr] = groupcounts(degree);
figure(3)
plot(gr,gc,'o')
xlabel('k')
ylabel('p(k)')
```
Now we observe that the behavior for smaller degree is uncertain, while the data
clearly exhibit a *tail* (an *asymptotic*) that decays as a power law. Let us
use the techinique for parameter estimation we have seen in the last topic for
this case
```{code-cell} matlab
fo = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[0 0],...
               'Upper',[Inf Inf],...
               'StartPoint',[1 1]);
ft = fittype('a*x.^(-b)','options',fo);
[curve,gof] = fit(gr(6:end),gc(6:end),ft);
% We plot the results
figure(1)
plot(curve,gr(6:end),gc(6:end))
xlabel('k');
ylabel('p(k)');
```
We have obtained a reasonable fit
```{code-cell} matlab
disp(curve);
```
with $p(k) \sim k^{-2.365}$.

::::{admonition} Scale-free networks
:class: tip

A **scale-free** network is a network whose degree distribution follows a power
law, at least *asymptotically*. That is, the fraction $p(k)$ of nodes in the
network having degree $k$ behaves for large values of $k$ as
```{math}
p(k) \sim k^{-\alpha}, \quad 2 < \alpha < 3.
```
::::

This type of networks have usually several properties that we can use to
interpret the underlying phenomena. One of them is that they usually have a
*small diameter*, that is, the length of the "longest shortest path", i.e.,
the largest number of vertices which must be traversed in order to travel
from one vertex to another when paths which backtrack, detour, or loop are
excluded from consideration. We can compute it by doing
```{code-cell} matlab
diameter = max(distances(G),[],'all');
disp(diameter)
```
Thank to this property, dolphin scale-free network is *resilient to random
attacks*. If we remove some random nodes the increase in the diameter is small:
```{code-cell} matlab
percentage_of_removed = [0.05,0.01,0.15,0.20];

for j=1:length(percentage_of_removed)
    percentage = percentage_of_removed(j);
    for i = 1:500
        H = G;
        removednodes = randi(G.numnodes,floor(percentage*G.numnodes),1);
        H = H.rmnode(removednodes);
        [bin,binsize] = conncomp(H);
        idx = binsize(bin) == max(binsize);
        SG = subgraph(H, idx);
        diameters(j,i) = max(distances(SG),[],'all');
    end
end

figure(4)
boxplot(diameters.')
ylabel('Diameter')
xlabel('Percentage of removed nodes')
xticklabels(percentage_of_removed);
```



## Bibliography

```{bibliography}
:filter: docname in docnames
```
