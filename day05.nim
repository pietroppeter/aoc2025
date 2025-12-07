import std / [strutils, algorithm]

let testInput = """
3-5
10-14
16-20
12-18

1
5
8
11
17
32"""

type
  Db = object
    ranges: seq[tuple[a,b: int]]
    ingredients: seq[int]

func parse(text: string): Db =
  for line in text.splitLines:
    if '-' in line:
      let split = line.split('-')
      result.ranges.add (split[0].parseInt, split[1].parseInt)
    elif line.len > 0:
      result.ingredients.add line.parseInt

echo testInput.parse

func solve1(db: Db): int =
  for ingredient in db.ingredients:
    for ran in db.ranges:
      if ingredient >= ran.a and ingredient <= ran.b:
        inc result
        break

echo testInput.parse.solve1
echo "day05.input".readFile.parse.solve1

func solve2(db: Db): int =
  let ranges = db.ranges.sortedByIt((it.a, it.b))
  #debugEcho range
  var ingredient = ranges[0].a
  for ran in ranges:
    #debugecho "ran: ", ran
    #debugecho "  ingr: ", ingredient
    if ingredient >= ran.a and ingredient <= ran.b:
      #debugecho "  in"
      result.inc (ran.b - ingredient + 1)
      ingredient = ran.b + 1
    elif ingredient > ran.b:
      #debugecho "  after"
      continue
    else: # ingredient <= ran.b and ingreident < ran.a
      #debugecho "  before"
      result.inc (ran.b - ran.a + 1)
      ingredient = ran.b + 1
    #debugecho "  result: ", result

echo testInput.parse.solve2
echo "day05.input".readFile.parse.solve2
