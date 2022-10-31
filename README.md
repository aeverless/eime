# EIME

**EIME** (Estimator of Indirect Measurement Errors) takes measurements and a formula as input and subsequently uses it to estimate measurement errors and calculate values using a given formula.

## Input

EIME takes a single argument - path to a Julia source file - and evaluates it.

You can write any Julia code in an input file, but for the estimator to work properly you have to define the following variables:

- `f` - main formula for calculations
- `measurements` - a named tuple of measurement values
- `errors` - a named tuple of systematic error values

And optionally:

- `flabel` (default: `"f"`)- escaped label for the main value to be calculated
- `digits_after_decimal_point` (default: `4`) - number of digits after decimal point

See [in.eime.jl](in.eime.jl) for more information.

See [in.eime.example.jl](in.eime.example.jl) for an example.

## Output

EIME outputs a minimal LaTeX string that documents every step of estimating errors for given measurement data. It is recommended to use a MathJax renderer.

## Usage

Julia is required to use EIME, you can install it from https://julialang.org/downloads/

Via CLI:

```shell-session
julia eime.jl [in.eime.jl]
```

`[in.eime.jl]` is to be substituted for a path to an input file.
