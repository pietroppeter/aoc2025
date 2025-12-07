import std / [strutils, tables]

let testInput = """
.......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
..............."""


type
  Lab = object
    start: int # only x coordinate, assume y is 0
    splits: seq[seq[int]] # index [y] tells the x positions (can be empty sequence)
    beams: seq[seq[int]] # same as splits
    timelines: seq[CountTable[int]] # number of timelines across a beam, added for part 2

func parse(text: string): Lab =
  let lines = text.splitLines()
  for x, c in lines[0]:
    if c == 'S':
      result.start = x
  result.splits.add @[]
  for y, line in lines[1 .. lines.high]:
    result.splits.add @[]
    for x, c in line:
      if c == '^':
        result.splits[y].add x

echo testInput.parse

proc addTimeline(lab: var Lab, y, x: int, tc: int) =
  while y >= lab.timelines.len:
    lab.timelines.add initCountTable[int]()
  lab.timelines[y].inc(x, tc)

proc addBeam(lab: var Lab; y, x: int, tc: int) =
  lab.addTimeline(y, x, tc)
  if x notIn lab.beams[y]:
    lab.beams[y].add x

func beam(lab: Lab): Lab =
  result = lab
  result.beams.add @[result.start]
  for y in 1 .. lab.splits.high:
    result.beams.add @[]
    for x in result.beams[y - 1]:
      let tc = if (y-1) < result.timelines.len:
          result.timelines[y - 1][x]
        else:
          1
      if x in result.splits[y]:
        result.addBeam(y, x - 1, tc)
        result.addBeam(y, x + 1, tc)
      else:
        result.addBeam(y, x, tc)

echo testInput.parse.beam

func solve1(lab: Lab): int =
  for y, splits in lab.splits:
    for x in splits:
      if x in lab.beams[y - 1]:
        inc result

echo testInput.parse.beam.solve1
echo "day07.input".readFile.parse.beam.solve1

func solve2(lab: Lab): int =
  for x, n in lab.timelines[^1]:
    result.inc n

echo testInput.parse.beam.solve2
echo "day07.input".readFile.parse.beam.solve2
