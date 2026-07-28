# Numerical Methods & Data Analysis — MOwNiT 2026

A collection of laboratory projects completed for **Computational Methods in Science and Technology** (*Metody Obliczeniowe w Nauce i Technice*) at **AGH University of Krakow**.

The repository presents practical implementations of numerical algorithms in Python, with emphasis on **data analysis, optimization, model evaluation, numerical stability and scientific communication**.

> **Portfolio context:** this repository demonstrates how I translate mathematical problems into reproducible computational experiments, compare alternative methods and communicate conclusions using notebooks, visualizations and technical reports.

## What this repository demonstrates

* Building reproducible numerical experiments in **Jupyter Notebook**
* Loading, preparing and analysing real tabular datasets
* Applying vectorized numerical linear algebra with **NumPy** and **SciPy**
* Implementing algorithms instead of relying only on high-level library calls
* Comparing methods using error metrics, convergence rates and execution time
* Investigating numerical stability, matrix conditioning and algorithmic trade-offs
* Presenting results with plots, tables, conclusions and PDF reports

## Selected Data & AI highlights

### Regression on a large dataset

The least-squares and optimization exercises use the **YearPredictionMSD** dataset:

* **515,345 observations**
* **90 input features**
* predefined training and test partitions
* feature standardization and intercept handling
* linear regression solved with least squares and gradient descent
* evaluation using **RMSE** and **MAE**
* analysis of convergence, condition number and computational cost

### Optimization

Implemented and compared optimization techniques including:

* gradient descent with a fixed learning rate
* preconditioned gradient descent
* backtracking line search with the Armijo condition
* convergence monitoring using objective values and gradient norms
* optimization of a physical spring-chain model
* regression formulated as minimization of a quadratic objective function

### Model fitting and interpolation

The repository includes experiments with:

* polynomial fitting and extrapolation
* model comparison using **AIC/AICc**
* Vandermonde matrices and their condition numbers
* data scaling to improve numerical stability
* cubic splines and shape-preserving interpolation
* practical analysis of approximation error

### Numerical simulation

The ODE laboratories cover:

* Van der Pol and Blasius equations
* two-body and restricted three-body problems
* explicit, implicit and semi-implicit Euler methods
* fourth-order Runge–Kutta method
* stability regions and empirical convergence order
* Lagrange points, trajectories, energy and the Jacobi integral

### Numerical integration and nonlinear equations

Additional work includes:

* midpoint, trapezoidal and Simpson quadrature
* error and convergence analysis
* integration of sampled physical data
* fixed-point iterations and Newton-type methods
* theoretical and empirical analysis of convergence

## Technologies

| Area                  | Tools                         |
| --------------------- | ----------------------------- |
| Language              | Python 3                      |
| Numerical computing   | NumPy, SciPy                  |
| Data analysis         | pandas                        |
| Visualization         | Matplotlib                    |
| Symbolic calculations | SymPy                         |
| Development           | Jupyter Notebook, Git, GitHub |
| Reporting             | Typst, PDF technical reports  |

## Repository structure

The repository is organized into laboratory directories. A typical directory contains:

```text
labXX/
├── labXX.ipynb       # implementation, experiments and analysis
├── labXX_spr.pdf     # technical report
├── labXX_spr.typ     # report source, where available
└── figures/          # generated visualizations, where available
```

The main subject areas covered across the laboratories are:

| Laboratory area                 | Main topics                                                |
| ------------------------------- | ---------------------------------------------------------- |
| Linear algebra and regression   | least squares, large tabular data, prediction error        |
| Interpolation and approximation | polynomial models, splines, conditioning, AIC              |
| Numerical integration           | composite quadrature, accuracy and convergence             |
| Nonlinear equations             | fixed-point iterations, Newton method, convergence order   |
| Differential equations          | Euler methods, RK4, stability, physical simulations        |
| Optimization                    | gradient methods, preconditioning, line search, regression |

## Running the notebooks

```bash
git clone https://github.com/siemaxinh0/MOwNiT-2026.git
cd MOwNiT-2026

python -m venv .venv
source .venv/bin/activate        # Linux/macOS
# .venv\Scripts\activate         # Windows

pip install jupyter numpy scipy pandas matplotlib sympy
jupyter lab
```

Some notebooks use the `YearPredictionMSD.txt` dataset, which is not stored in the repository because of its size. Place the file in the directory expected by the selected notebook before running it.

## Engineering approach

For each problem, the usual workflow is:

1. formulate the mathematical problem and assumptions
2. implement one or more numerical methods
3. validate the implementation against an exact or reference solution
4. measure error, stability, convergence or runtime
5. visualize results and explain the observed behaviour
6. summarize practical limitations and trade-offs

This approach is directly applicable to Data & AI work, where a model result is useful only when the data pipeline, assumptions, metrics and limitations are understood.

## Authors and collaboration

This repository was created jointly by:

* **Hubert Kukla** — Computer Science student at AGH University of Krakow
* **Maksymilian Siemek** — Computer Science student at AGH University of Krakow

**All laboratory assignments, implementations, experiments and reports included in this repository were completed collaboratively by both authors.**

The project reflects shared work involving problem analysis, Python implementation, numerical experiments, visualization of results and preparation of technical reports.

---

*Academic portfolio repository — MOwNiT, 2026.*
