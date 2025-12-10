import std / [strutils, strscans, math, sets]
import print

let testInput = """
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3""""

type
  Tile = tuple[x, y: int]

func parse(text: string): seq[Tile] = 
  for line in text.splitLines:
    let (success, x, y) = scanTuple(line, "$i,$i")
    assert success
    result.add (x, y)

echo testInput.parse

func area(t, u: Tile): int =
  (abs(t.x - u.x) + 1)*(abs(t.y - u.y) + 1)

func solve1(tiles: seq[Tile]): int =
  for i in 0 ..< tiles.high:
    for j in (i + 1) .. tiles.high:
      let a = area(tiles[i], tiles[j])
      if a > result:
        result = a

echo testInput.parse.solve1
echo "day09.input".readFile.parse.solve1

# idea for part 2
# - create a border made of horizontal and vertical lines
# - iterate like in part 1, when I have a bigger area check that all of the rectangle is inside the loop
# - to check inside the loop use borders (to be inside the loop you need to be "after" an odd number of both horizontal and vertical borders )

type
  HorLine = tuple[y, x0, x1: int]
  VerLine = tuple[x, y0, y1: int]
  Border = object
    hor: seq[HorLine]
    ver: seq[VerLine]

func getBorder(t: seq[Tile]): Border =
  for i in 0 .. t.high:
    let j = if i == t.high: 0 else: (i + 1)
    assert t[i].x == t[j].x or t[i].y == t[j].y
    if t[i].x == t[j].x:
      let
        x = t[i].x
        y0 = min(t[i].y, t[j].y)
        y1 = max(t[i].y, t[j].y)
      result.ver.add (x, y0, y1).VerLine
    elif t[i].y == t[j].y:
      let
        y = t[i].y
        x0 = min(t[i].x, t[j].x)
        x1 = max(t[i].x, t[j].x)
      result.hor.add (y, x0, x1).HorLine


proc isInside(t: Tile, b: Border): bool =
  var horBeforeCount = 0
  #print t
  for h in b.hor:
    #print h
    #print t.x >= h.x0 and t.x <= h.x1
    if t.x >= h.x0 and t.x < h.x1:
      #print h.y < t.y
      if t.y == h.y:
        return true # early break in case we are on a border
      elif h.y < t.y:
        inc horBeforeCount

  #print horBeforeCount
  if horBeforeCount mod 2 == 0:
    return false

  var verBeforeCount = 0
  for v in b.ver:
    #print v
    #print t.y >= v.y0 and t.y <= v.y1
    if t.y >= v.y0 and t.y < v.y1:
      #print v.x < t.x 
      if t.x == v.x:
        return true # early break in case we are on a border
      elif v.x < t.x:
        inc verBeforeCount
  #print verBeforeCount
  if verBeforeCount mod 2 == 0:
    return false

  true

iterator rectangle(t, u: Tile): Tile =
  let
    x0 = min(t.x, u.x)
    x1 = max(t.x, u.x)
    y0 = min(t.y, u.y)
    y1 = max(t.y, u.y)
  for y in y0 .. y1:
    yield (x0, y)
    yield (x1, y)
  for x in x0 .. x1:
    yield (x, y0)
    yield (x, y1)

proc rectangleIsInside(t, u: Tile, border: Border): bool =
  for v in rectangle(t, u):
    if not v.isInside(border):
      #print v
      return false
  true

proc solve2(tiles: seq[Tile]): int =
  let border = tiles.getBorder
  for i in 0 ..< tiles.high:
    for j in (i + 1) .. tiles.high:
      let a = area(tiles[i], tiles[j])
      #print a, tiles[i], tiles[j]
      #print rectangleIsInside(tiles[i], tiles[j], border)
      if a > result and rectangleIsInside(tiles[i], tiles[j], border):
        result = a

let borderTest = testInput.parse.getBorder
echo borderTest
#assert (4, 5).isInside(borderTest)
#assert not (4, 2).isInside(borderTest)
print (8, 3).isInside(borderTest)
print rectangleIsInside((9, 5), (2, 3), borderTest)
echo testInput.parse.solve2
echo "day09.input".readFile.parse.solve2
# 4541935424 too high