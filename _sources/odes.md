# Modeling evolutionary problems

One of the ways in which mathematics is used to translate experimental
measurements into an understanding of the underlying regulating mechanisms is
represented by **ordinary differential equations**. Indeed if we consider the
values of variables these do not provide themselves insight on the underlying
phenomena we want to describe. The fundamental insight is that is *the change
in the magnitude* of a variable *as a function of time* that is the important
quantity. These changes can be often be described in terms of differential
equations.

The first class of problems we will address in this course is then their
numerical solution with MATLAB. To arrive at this we will start by (quickly)
recalling the mathematical background.

## Ordinary differential equations

Let us suppose that we have a variable $x$ that depends on time $t$, we can
represent its evolution on a graph
```{image} images/differentiation.png
:alt: Differentiation
:width: 400px
:align: center
```
There are intervals during which $x$ increases and others during which it
decreases. We can denote the **slope** of the change as
```{math}
\frac{\Delta x}{\Delta t} = \frac{x(t_2) - x(t_1)}{t_2 - t_1} =
\frac{x(t_1 + \Delta t) - x(t_1)}{\Delta t}, \quad \Delta t = t_2 - t_1,
```
when we define it in this way, the *slope* is a function of the selected
interval.  We are the interested in what happens as we let the time interval
decrease by approaching zero, i.e., $\Delta t \rightarrow 0$,
```{math}
\lim_{\Delta t \rightarrow 0}\frac{\Delta x}{\Delta t} =
\lim_{\Delta t \rightarrow 0} \frac{x(t_1 + \Delta t) - x(t_1)}{\Delta t}
= x'(t) = \frac{ {\rm d} x }{{\rm d} t} = \dot{x}(t),
```
that is, we are interested in its **derivative**. Specifically, we are
interested in making **predictions** about phenomena that are
subject to change, e.g.,
- the rate at which the food supply for a given specie is related to the growth
of its population,
- the variation of a drug concentration in an organ,
- the rate of decay of a radioactive substance.

Thus we are particularly interested in equations that tell us how
this rate at which a given quantity changes when it is related to some
function of the quantity itself. In mathematical terms these are equations
of the form
```{math}
x'(t) = f(t,x(t)), \quad t \in [t_0,t_f].
```
These type of equations are called **ordinary differential equations**. Their
solution cannot be determined uniquely without employing some
**outside condition**. This is typically an *initial value*, e.g., the quantity
of radioactive material at the beginning of the decay or the number of members
of our population.

There is a very rich mathematical theory behind these objects that is involved
in
1. having strategies useful for the development of models of physical phenomena;
2. discovering whether the model we (or our *friendly neighborhood
  mathematician* ) have just devised is **well-posed** ( are there solutions?
    are these unique? do the solutions correspond to the phenomenon we were
    modeling?);

**But don't worry**, what we are interested in here is using MATLAB to
investigate them, and approximate their solution 👍. So we will assume that you
have got your ODE from a good dealer, and avoid investigating the theory.

We will start from **an example** doing the whole analysis from top to bottom,
then you will have the opportunity to work on a **gallery of problems** testing
what we have learned.

## A completely worked out example

The model we want to study is an of example of **compartment analysis** related
to the time evolution of a drug concentration in an organ. We let now $x(t)$
denote the amount of substance in some compartment at time $t$. We can then
compute the change in the quantity $x(t)$ in terms of the amount of
the quantity flowing into and out the compartment, i.e., we are assuming that
the substance does not "disappear" in the process,
```{math}
\frac{{\rm d} x(t)}{{\rm d}t} = \text{input rate}\;-\text{output rate},
```
this principle is based on the **law of conservation of mass** and is known as
the *Balance Law*.

The first example we look at is a simple process of drug administration through
the stomach and the blood
```{image} images/drug1.png
:alt: A simple drug absorption system
:width: 400px
:align: center
```
We enter in the system $y_0$ unit of drugs (*initial condition*), then the
quantity of drug that is in the stomach (*first compartment*) is denoted by
$y_1(t)$. From here it can only go to the blood (*second compartment*) with
a transition rate of $k_1$. We denote with $y_2(t)$ the quantity of drug in
the second compartment, from here then the drug is eliminated through some
metabolic process at rate $k_e$. Let us write down the differential model
for this case
```{math}
\begin{cases}
\dot{y}_1(t) = - k_1 y_1(t), & y_1(0) = y_0, \\
\dot{y}_2(t) = + k_1 y_1(t) - k_e y_2(t), & y_2(0) = 0,
\end{cases} \quad t \in [0,t_f],
```
we have written down a system of two differential equations for the quantity of
drug in the two compartments.

We now use MATLAB to get a **numerical solution** of this system. In this case
a numerical solution is nothing more than an evaluation of the two functions
$y_1(t)$, and $y_2(t)$ over a grid of time values
```{math}
0 = t_1 < t_2 < \ldots < t_n = t_f.
```

Let us start by creating a `matlab script` called `drugdelivery.m`.
```matlab
%% Drug Delivery
% This script will be used to solve a simple drug-delivery model in the form
% of two linear coupled odes

clear; clc; close all; % Clean the memory
```
In MATLAB you can specify any number of coupled ODE equations to solve, and
at least in principle the number of equations is only limited by the available
computer memory. In our case we can specify our *dynamic* by using a `function
handle`, by adding to the previous script
```matlab
k1 = 0.9776;      % Transition rate between stomach and blood
ke = 0.2213;      % Eliminatio rate from the blood
A = [ -k1 0; k1 -ke]; % Two by two matrix
f = @(t,y) A*y;   % Right-hand side of the ODE
```
We have firs fixed the values of the two constants for the model. Then we
have rewritten the right-hand side of the model as a matrix vector product
```{math}
\dot{
\begin{bmatrix}
y_1(t)\\y_2(t)
\end{bmatrix}} = \begin{bmatrix}
-k_1 & 0 \\
+k_1 & -k_e
\end{bmatrix}\begin{bmatrix}
y_1(t)\\y_2(t)
\end{bmatrix} \Leftrightarrow \dot{\mathbf{y}} = A \mathbf{y} = f(t,\mathbf{y}).
```
in a `function handle` form. That is, we can call `f(t,y)` to evaluate the
dynamic.
```{warning}
The dynamic of the system must always be expressed with the arguments in this
order: first the independent variable ($t$), then the function ($\mathbf{y}$).
MATLAB expects it to be this way!
```
The other two data from the system that we need are the *initial condition*,
and the maximum time $t_f$. We can add them to the script by doing
```matlab
y0 = [600;0]; % firt component is the initial condition for y1, the second for y2
t0 = 0;
tf = 6;
```
Now we have specified all the needed data and we can use one of the MATLAB
**ODE integrator** to solve the system
```matlab
[T,Y] = ode45(@(t,y) f(t,y),[t0,tf],y0);
```
After this call had been executed the variable `T` will contain the values
```{math}
0 = t_1 < t_2 < \ldots < t_n = t_f
```
on which we have approximated the solution, while $Y$ will be a
$\operatorname{lenght}(T) \times 2$ matrix containing the approximation of the
two solutions on each time step. We can visualize what we have obtained by
doing
```matlab
figure(1)
plot(T,Y(:,1),'r-')
xlabel('T (h)')
ylabel('y_1(t)')
figure(2)
plot(T,Y(:,2),'r-')
xlabel('T (h)')
ylabel('y_2(t)')
```
and obtaining the two figures
````{list-table} Simple drug delivery solutions
:header-rows: 1

* - Compartment 1, stomach: $y_1(t)$
  - Compartment 2, blood: $y_2(t)$
* - ![](images/drug1-res1.png)
  - ![](images/drug1-res2.png)
````
```{tip}
`ode45` performs well with *most* ODE problems and should generally be your
first choice of solver. However, `ode23`, `ode78`, `ode89` and `ode113` can
be more efficient than `ode45` for problems with looser or tighter accuracy
requirements.

Some ODE problems exhibit **stiffness**. Stiffness is a term that defies a
precise definition, but in general, stiffness occurs when there is a
difference in scaling somewhere in the problem. For example, if an ODE has
two solution components that vary on drastically different time scales,
then the equation might be stiff. You can **identify a problem as stiff** if
nonstiff solvers (such as `ode45`) are unable to solve the problem or are
extremely slow. If you observe that a nonstiff solver is very slow, try using
a stiff solver such as `ode15s` instead. 
```


## A gallery of test problems
