# EIME

**EIME** (Estimator of Indirect Measurement Errors) takes measurements and a formula as input and subsequently uses it to estimate measurement errors and calculate values using a given formula.

## Usage

Julia is required to use EIME, you can install it from https://julialang.org/downloads/

Via CLI:

```shell-session
julia eime.jl [in.eime.jl]
```

`[in.eime.jl]` is to be substituted for a path to an input file.

## Input

EIME takes a single argument - path to a Julia source file - and evaluates it.

You can write any Julia code in an input file, but for the estimator to work properly you have to define the following variables:

- `f` - main formula for calculations
- `measurements` - a named tuple of measurement values
- `errors` - a named tuple of systematic error values

And optionally:

- `label` (default: `"f"`) - escaped label for the main value to be calculated
- `unit` (default: `""`) - string that will denote the unit of the main value
- `digits_after_decimal_point` (default: `4`) - number of digits after decimal point

See [in.eime.jl](in.eime.jl) for more information.

See [in.eime.example.jl](in.eime.example.jl) for an example.

## Output

EIME outputs a minimal LaTeX string that documents every step of estimating errors for given measurement data. It may then be rendered by a LaTeX renderer like MathJax.

The image below was rendered with https://latexeditor.lagrida.com/ by pasting in the string generated by EIME from [an example input file](in.eime.example.jl).

![Rendered output example](https://user-images.githubusercontent.com/47787629/201762691-fb70a2c6-e03c-4e94-9cb5-2ca9482178a6.png)
