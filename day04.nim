import std / [sets, strutils]

let testInput = """
..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@."""

type
  Point = tuple[x, y: int]
  Grid = object
    rolls: HashSet[Point]
    maxX, maxY: int

proc parse(text: string): Grid =
  var y = 0
  for line in text.splitLines:
    for x, c in line:
      result.maxX = x # not efficient but don't care
      if c == '@':
        result.rolls.incl (x, y)
    result.maxY = y
    inc y

echo testInput.parse

func solve1(grid: Grid): int =
  for roll in grid.rolls:
    var n = 0
    for d in [(-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (-1, 1), (0, 1), (1, 1)]:
      if (roll.x + d[0], roll.y + d[1]) in grid.rolls:
        inc n
    if n < 4:
      inc result

echo testInput.parse.solve1
echo "day04.input".readFile.parse.solve1

func solve2(grid: Grid): int =
  var rolls = grid.rolls
  while true:
    var toRemove = initHashSet[Point]()
    for roll in rolls:
      var n = 0
      for d in [(-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (-1, 1), (0, 1), (1, 1)]:
        if (roll.x + d[0], roll.y + d[1]) in rolls:
          inc n
      if n < 4:
        inc result
        toRemove.incl roll
    if toRemove.len == 0:
      break
    for roll in toRemove:
      rolls.excl roll

echo testInput.parse.solve2
echo "day04.input".readFile.parse.solve2
