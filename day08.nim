import std / [math, heapqueue, strscans, strutils, intsets, sequtils, algorithm]
let testInput = """
162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689"""

type
  Point = tuple[x, y, z: int]
  Pair = tuple[i, j: int, sim: int]
  Circuit = IntSet

func sim(p, q: Point): int =
  - ((p.x - q.x)^2 + (p.y - q.y)^2 + (p.z - q.z)^2)

func parse(text: string): seq[Point] =
  for line in text.splitLines:
    let (success, x, y, z) = line.scanTuple("$i,$i,$i")
    assert success
    result.add (x, y, z)

echo testInput.parse

func `<`(p, q: Pair): bool = p.sim < q.sim

func mostSim(p: seq[Point], n: int): HeapQueue[Pair] =
  for i in 0 ..< p.high:
    for j in (i + 1) .. p.high:
      result.push (i, j, sim(p[i], p[j]))
      if result.len > n:
        discard result.pop()

echo testInput.parse.mostSim(10)
echo testInput.parse.mostSim(10)[9] # queue does not sort (last is not most similar pair 0 19)

var q = testInput.parse.mostSim(10)
while q.len > 0:
  echo q.pop() # but it will pop them in the correct order (pops 0 19 last)

func circuits(q: HeapQueue[Pair]): seq[Circuit] =
  var q = q
  while q.len > 0:
    let (i, j, _) = q.pop()
    var a, b = -1
    for k, c in result:
      if i in c or j in c:
        assert b == -1
        if a == -1:
          a = k
        else: # b == -1
          b = k
    if a == -1: # not found in any circuit
      result.add toIntSet([i, j])
    elif b == -1: # found only in one circuit
      result[a].incl i
      result[a].incl j
    else: # two circuits are connecting!
      result[a].incl result[b]
      result.del(b)

echo testInput.parse.mostSim(10).circuits

func solve1(c: seq[Circuit]): int =
  let lens = c.mapIt(it.len).sorted()
  lens[^1]*lens[^2]*lens[^3]

echo testInput.parse.mostSim(10).circuits.solve1
echo "day08.input".readFile.parse.mostSim(1000).circuits.solve1

func mostSimReverse(p: seq[Point]): HeapQueue[Pair] =
  for i in 0 ..< p.high:
    for j in (i + 1) .. p.high:
      result.push (i, j, -sim(p[i], p[j]))

func solve2(p: seq[Point]): int =
  var q = p.mostSimReverse
  var circuits: seq[Circuit]
  while q.len > 0:
    let (i, j, _) = q.pop()
    var a, b = -1
    for k, c in circuits:
      if i in c or j in c:
        assert b == -1
        if a == -1:
          a = k
        else: # b == -1
          b = k
    if a == -1: # not found in any circuit
      circuits.add toIntSet([i, j])
    elif b == -1: # found only in one circuit
      circuits[a].incl i
      circuits[a].incl j
    else: # two circuits are connecting!
      circuits[a].incl circuits[b]
      circuits.del(b)
    
    #debugEcho circuits
    if circuits.len == 1 and circuits[0].len == p.len:
      #debugecho "i, j:", (i, j)
      #debugecho "p i, p j:", p[i], p[j]
      return p[i].x * p[j].x

when false:
  echo "---"
  for i, p in testInput.parse:
    echo i, " ", p
echo testInput.parse.solve2
echo "day08.input".readFile.parse.solve2
