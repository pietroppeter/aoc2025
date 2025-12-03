
import std / [strutils]

type
  Dir = enum Left, Right
  Move = tuple[dir: Dir, num: int]

let testInput = """
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82""" 

func parse(inp: string): seq[Move] =
  var move: Move
  for line in inp.strip.splitLines:
    if line.startsWith("L"):
      move.dir = Left
    else:
      move.dir = Right
    move.num = parseInt(line[1 ..< line.len])
    result.add move

#echo testInput.parse

func solve1(moves: seq[Move]): int =
  var pos: int = 50
  for move in moves:
    if move.dir == Left:
      pos = pos - move.num
    else:
      pos = pos + move.num
    pos = pos mod 100
    if pos < 0:
      pos += 100
    if pos == 0:
      inc result
    #debugecho pos


doassert testInput.parse.solve1 == 3
doassert "day01.input".readFile.parse.solve1 == 989
# had a bug with num > 100

func solve2(moves: seq[Move]): int =
  var pos: int = 50
  for move in moves:
    var num = move.num mod 100
    result.inc (move.num div 100)
    if move.dir == Left:
      pos = pos - num
    else:
      pos = pos + num
    if pos < 0:
      inc result      
      pos += 100
    elif pos > 99:
      inc result
      pos -= 100
    if pos == 0:
      inc result
    #debugecho "pos post: ", pos

func solve2brute(moves: seq[Move]): int =
  var pos: int = 50
  for move in moves:
    var num = move.num
    while num > 0:
      if move.dir == Left:
        dec pos
      else:
        inc pos

      if pos == -1:
        pos = 99
      elif pos == 100:
        pos = 0

      if pos == 0:
        inc result
        #debugEcho "  +1 on move", move
      dec num
    #debugEcho "pos after move ", move, " is ", pos
    #debugecho "pos post: ", pos

echo testInput.parse.solve2brute

echo "day01.input".readFile.parse.solve2brute

# non brute force still does not work
echo "day01.input".readFile.parse.solve2
# 2381 too low
# 6327 too high
# 5949 too high
# 5581 no
