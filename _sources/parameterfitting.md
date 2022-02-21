# Fitting data to models

Parametric fitting involves finding coefficients (parameters) for one or more
models that you want to fit to some experimental data.

In general we assume data to be statistical in nature, this means that we can
assume it to be divided into two components:
```{math}
\text{``data''}\;=\;\text{``true value''}\;+\;\text{``statistical error''},
```
the other fundamental part is that we are assuming the deterministic component
to be given by a model for which the random component is described as an error
associated with the data:
```{math}
\text{``data''}\;=\;\text{``model''}\;+\;\text{``error''}.
```
The model is a function of the independent data (predictor) and one or more
coefficients, that are the quantities we want to compute. The error represents
random variations in the data. For doing a mathematical analysis one usually
assumes that they follow a specific probability distribution - in most of the
case Gaussian. The source of the error can be varied, but it is always present,
errors are bound to happen when you are dealing with measured data.

## An example with hydraulic conductivity

To see how we can solve these problem in MATLAB we start again from an example
and we work out to the end. We have some data that can be used to determine the
water retention curve for a given soil. This is the relationship between the
water content and the soil water potential. This curve is characteristic for
different types of soil. The most frequently used model for this curve is
the van Genuchten model
```{math}
S_e(h_m) = \frac{1}{(1+|\alpha h_m|^n)^m}, \quad K(\theta) = K_s S_e^l[1-(1-S_e^{1/m})^m]^2,
```
where $\theta$ is the volumetric water content $L^3 L^{-3}$,
$h_m$ is the soil water matric head $L$, $K$ is the hydraulic
conductivity $LT^{-1}$, $S_e$ is effective fluid saturation,
$K_s$ is the saturated hydraulic conductivity $LT^{-1}$,
$\theta_r$ and $\theta_s$ denote the residual and saturated
water contents, respectively; $l$ is the pore-connectivity
parameter, and $\alpha$ $L^{-1}$, $n$, and $m = 1 - 1/n$ are
empirical shape parameters.

We have got two functions, one relating the matric head and the water content:
```{code-block} matlab
headwcontent = [-293.9 0.165
-322.5 0.162
-409.6 0.147
-453.2 0.139
-596.6 0.127
-641.5 0.125
-801.5 0.116
-860.1 0.113
-949.7 0.109
-1192.0 0.103
-1298.0 0.101
-1445.0 0.0988
-1594.0 0.0963
-1760.0 0.0915
-1980.0 0.0875];
```
and one relating the water content and the hydraulic conductivity:
```{code-block} matlab
wcontenthcond = [0.0859 0.000411
0.0912 0.000457
0.0948 0.000719
0.0982 0.00087
0.102 0.00149
0.108 0.00314
0.114 0.00377
0.125 0.00635
0.140 0.018
0.161 0.0303];
```
The two hydraulic functions contain six unknown parameters:
```{math}
\theta_r,\,\theta_s,\,\alpha,\,n,\,l,\,K_s.
```
The objective function we need to optimize is then defined as a
weighted least-squares problem in the following way
```{math}
\Phi(\beta) = \sum_{i=1}^{n_1} w_i \left[ \theta^*(h_{m,i}) - \theta(h_{m,i},\beta) \right]^2 + W \sum_{i=1}^{n_2} w_i \left[ \ln K^*(\theta_i) - \ln K(\theta_i,\beta) \right]^2,
```
where
```{math}
W = \frac{ n_2 \sum_{i=1}^{n_1} w_i \theta^*(h_{m,i}) }{n_1 \sum_{i=1}^{n_2} w_i |\ln K^*(\theta_i)|}.
```
