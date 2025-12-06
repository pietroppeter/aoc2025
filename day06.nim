import std / [strutils, parseutils]

let testInput = """
123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  """

type
  Op = enum plus star
  Ex = object
    nums: seq[int]
    op: Op

func parseOpLine(line: string): seq[Op] =
  for c in line:
    if c == '+':
      result.add plus
    elif c == '*':
      result.add star

func parseNumLine(line: string): seq[int] =
  var i = 0
  var num: int
  while i < line.len:
    let more = parseInt(line, num, start=i)
    if more == 0:
      inc i
    else:
      i.inc more
      result.add num


func parse(text: string): seq[Ex] =
  let
    lines = text.splitLines
    opLine = lines[^1]
    ops = opLine.parseOpLine  
  var ex: Ex

  var numsSeq: seq[seq[int]]
  for j in 0 ..< lines.high:
    numsSeq.add lines[j].parseNumLine

  for i, op in ops:
    ex.op = op
    ex.nums = @[]
    for nums in numsSeq:
      ex.nums.add nums[i]
    result.add ex

echo testInput.parse

func solve1(exes: seq[Ex]): int =
  var res: int
  for ex in exes:
    if ex.op == plus:
      res = 0
      for num in ex.nums:
        res.inc num
    else:
      res = 1
      for num in ex.nums:
        res *= num
    result.inc res

echo testInput.parse.solve1
echo "day06.input".readFile.parse.solve1

func parse2(text: string): seq[Ex] =
  let
    lines = text.splitLines
    opLine = lines[^1]
  let numLen = lines.len - 1
  var i = 0
  var ex: Ex
  while i < opLine.len:
    if opLine[i] == '+':
      if ex.nums.len > 0:
        result.add ex
      ex.op = plus
      ex.nums = @[]
    elif opLine[i] == '*':
      if ex.nums.len > 0:
        result.add ex
      ex.op = star
      ex.nums = @[]
    var num = 0
    for j in 0 ..< numLen:
      if lines[j][i] != ' ':
        num = num*10 + ord(lines[j][i]) - ord('0')
    if num > 0:
      ex.nums.add num
    inc i
  if ex.nums.len > 0:
    result.add ex


echo testInput.parse2
echo testInput.parse2.solve1
echo "day06.input".readFile.parse2.solve1
