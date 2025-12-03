import std / [math, strutils]

type
  InvalidId = distinct int

converter toInt(id: InvalidId): int =
  let tens = 10^(($(id.int)).len)
  result = id.int + tens*id.int

assert 10.InvalidId.toInt == 1010

func nextInvalidId(num: int): InvalidId =
  # if its invalid, keep it
  if num < 10: return 1.InvalidId
  let
    halfLen = (($(num)).len + 1) div 2
    tens = 10^(halfLen)
    right = num mod tens
  var
    left = num div tens
  #debugEcho tens
  #debugEcho right
  #debugecho left
  if ($left).len < halfLen:
    left = tens div 10
    return left.InvalidId
  if left < right:
    return (left + 1).InvalidId
  else:
    return left.InvalidId

assert 2665.nextInvalidId == 2727
assert 613600462.nextInvalidId == 1000010000
assert 565653.nextInvalidId == 566566
assert 10.nextInvalidId == 11
assert 999.nextInvalidId == 1010
assert 1312.nextInvalidId == 1313
assert 1313.nextInvalidId == 1313
assert 3.nextInvalidId == 11
assert 22.nextInvalidId == 22

func `<`(id: InvalidId, num: int): bool = (id.toInt < num)

assert 10.InvalidId < 1011

func incr(id: var InvalidId) =
  id = (id.int + 1).InvalidId.toInt.nextInvalidId

func sumIdInRange(a, b: int): int =
  var id = a.nextInvalidId
  #debugEcho "range ", a, "-", b
  assert id.toInt >= a
  #debugEcho "  first id: ", id
  while id < b + 1:
    #debugecho "  id:", id
    result += id.toInt
    incr id

assert sumIdInRange(11, 22) == 33
assert sumIdInRange(95,115) == 99
assert sumIdInRange(998,1012) == 1010
assert sumIdInRange(1188511880,1188511890) == 1188511885
assert sumIdInRange(222220,222224) == 222222
assert sumIdInRange(1698522,1698528) == 0
assert sumIdInRange(446443,446449) == 446446
assert sumIdInRange(38593856,38593862) == 38593859
assert sumIdInRange(565653,565659) == 0
assert sumIdInRange(824824821,824824827) == 0
assert sumIdInRange(2121212118,2121212124) == 0


type
  Range = tuple[a,b: int]

proc parse(text: string): seq[Range] = # nimcheck says it can have side effect as func (but compiles fine)
  for pair in text.split(','):
    let two = pair.split('-')
    assert two.len == 2
    let
      a = parseInt(two[0])
      b = parseInt(two[1])
    result.add (a, b)

let testInput = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

func solve1(ranges: seq[Range]): int =
  for r in ranges:
    result += sumIdInRange(r.a, r.b)

assert testInput.parse.solve1 == 1227775554
assert "day02.input".readFile.parse.solve1 == 55916882972


  
    
