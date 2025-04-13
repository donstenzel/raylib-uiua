# Experimental!
R ~ "../lib"
  W  ← R~Window
  Kb ← R~Keyboard

GoL ← ⨬(=₃|∊2_3)⟜(/+≡⌟↻⊂C₂ A₂)

World ← ⁅ gen 240_320 1

W 640 480 "Rayua Exploration"
°W~FPS 60
Kb~Exit @q

◌ W~Loop!(R~ShowArray⊃(▽⟜≡▽2)GoL) World
