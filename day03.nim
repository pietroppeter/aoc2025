import std / [strutils, math, algorithm]

func maxJoltage(bank: seq[int]): int =
  var maxFirst = 0
  for i in 0 ..< (bank.len - 1):
    if bank[i] < maxFirst:
      continue
    maxFirst = bank[i]
    for j in (i + 1) ..< bank.len:
      result = max(result, bank[i]*10 + bank[j])

func bankToInts(bank: string): seq[int] =
  for c in bank:
    result.add (ord(c) - ord('0'))

assert "987654321111111".bankToInts.maxJoltage == 98

let testInput = """
987654321111111
811111111111119
234234234234278
818181911112111"""

func solve1(text: string): int =
  for line in text.splitLines:
    result.inc line.bankToInts.maxJoltage

assert testInput.solve1 == 357
assert "day03.input".readFile.solve1 == 16993

func maxJoltage2rec(bank: seq[int], n = 12): int =
  var maxFirst = 0
  if n == 2:
    for i in 0 ..< (bank.len - 1):
      if bank[i] < maxFirst:
        continue
      maxFirst = bank[i]
      for j in (i + 1) ..< bank.len:
        result = max(result, bank[i]*10 + bank[j])
  else:
    for i in 0 ..< (bank.len - (n - 1)):
      if bank[i] < maxFirst:
        continue
      maxFirst = bank[i]
      result = max(result, bank[i]*10^(n - 1) + maxJoltage2rec(bank[(i + 1) ..< bank.len], n - 1))

assert "987654321111111".bankToInts.maxJoltage2rec == 987654321111

func solve2rec(text: string): int =
  for line in text.splitLines:
    result.inc line.bankToInts.maxJoltage2rec

assert testInput.solve2rec == 3121910778619
# echo "day03.input".readFile.solve2rec # recursive is too slow!

# idea: turn bank into couples digit, position from end
# for n = 12
# pick highest digit with position at least 12
# pick next highest digit with position at least 11 and so forth

type
  Battery = tuple[digit, order: int]


func bankToBatteries(text: string): seq[Battery] =
  const base = ord('0')
  for i in 0 .. text.high:
    result.add (ord(text[i]) - base, text.high - i)
  result = result.sortedByIt((it.digit, it.order)).reversed

#echo "987654321111111".bankToBatteries

func maxJoltage(bank: seq[Battery]): int =
  var bank = bank

  var n = 12 # number of batteries yet to be picked
  var i = 0
  var lastOrder = bank.len # position of last battery (in terms of how many are after it)
  while n > 0:
    if bank[i].order < lastOrder and bank[i].order >= (n - 1):
      # picked battery needs to come after last battery and needs to have enough batteries after it
      result = 10*result + bank[i].digit
      lastOrder = bank[i].order
      dec n
      i = 0 # after you pick a battery restart to make sure you can pick bigger digits
    else:
      inc i


echo "987654321111111".bankToBatteries.maxJoltage
assert "987654321111111".bankToBatteries.maxJoltage == 987654321111

func solve2(text: string): int =
  for line in text.splitLines:
    #debugEcho line
    result.inc line.bankToBatteries.maxJoltage

assert testInput.solve2 == 3121910778619
assert "day03.input".readFile.solve2 == 168617068915447
