# Raylib Bindings for Uiua

These are some work in progress bindings for raylib in Uiua.
Not a lot of raylib is actually supported as of right now, really only 2d
(texture) drawing and user input.

This is heavily inspired by [Rayua](https://github.com/uiua-lang/rayua),
but I felt my code was too opinionated to add this to Rayua itself.
Most code is organized into modules and some higher level abstractions
are available. This is mainly what I want to improve further.
I also added the ability to load a Uiua array as an image, and then turn
that image into a texture which can be drawn.

## Examples

I updated [Lenia in Uiua](https://github.com/donstenzel/lenia) with
a live renderer which makes bigger demos possible.
Maybe some interactive stuff in the future?

[Reaction Diffusion](examples/reaction-diffusion.ua) is a simple live simulation.
Maybe add some interactions here aswell?

I also made a simple [Game of Life](examples/game-of-life.ua) implementation.