# Experimental!

R ~ "../lib"
  W  ← R~Window
  Kb ← R~Keyboard

# Reaction Diffusion
# This page served as a guide:
# https://www.karlsims.com/rd.html
# 
# Two chemicals are continuously mixing.
# Chemical A is constantly added and Chemical B removed.
# Their diffusion can be modeled using two grids,
# where each cell has a density of each chemical.
# A & B are the densities of the chemicals.
# A' ← A + Δt * (D₀▽²(A) - AB² + f(1 - A))
# B' ← B + Δt * (D₁▽²(B) + AB² - (k + f)B)
# 
# ▽² is like a weighted neighbor sum.

D₀ ← 1
D₁ ← 0.5
Δt ← 1

F ← 0.055
K ← 0.062
# F ← 0.0367 K ← 0.0649
# F ← 0.0545 K ← 0.062

# weighted neighbor sum
WNS ← /+×[...0.1 ¯1 ...0.15]≡⌟↻ ⊂C₂ ⊂0 A₂

# A' ? A B
A ← +⟜(×Δt ++⊃(×D₀ WNS|¯×⊙ⁿ₂|×F-⊙1))

# B' ? B A
B ← +⟜(×Δt ++⊃(×D₁ WNS|×ⁿ₂|¯×+K F))

F ← ⍜°⊟(⊃A˜B)

# Square starting state
Chemicals ← [
  ...[0_1 0_1 0_1 0_1 0_1 0_1 0_1 0_1 0_1 0_1 0_1]
  .. [0_1 0_1 0_1 0_1 1_0 1_0 1_0 0_1 0_1 0_1 0_1]
  ...[0_1 0_1 0_1 0_1 0_1 0_1 0_1 0_1 0_1 0_1 0_1]
]

▽⟜≡▽20 Chemicals
W ⊃(⊢₂⊓△"Reaction Diffusion")°⍉
°W~FPS 60
Kb~Exit @q

◌ W~Loop!(R~ShowArray ⊃(⍉⊂⊙0)F)
