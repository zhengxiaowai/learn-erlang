-module(geometry).
-export([area/1]).

area({rectangle, Width, Height}) -> Width * Height;
area({cycle, Radius}) -> 3.14159 * Radius * Radius;
area({square, Side}) -> Side * Side.

