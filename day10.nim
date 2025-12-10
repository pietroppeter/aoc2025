import std / [bitops, strutils, intsets]
import print
import npeg

let testInput = """
[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}"""

# first step: light indicator and buttons will be parsed as integers with bits as on positions
# apply buttons is then equivalent to xoring integers
# checking if light pattern is achieved is an equality check
func parseLights(text: string): int =
  for i, c in text:
    if c == '#':
      result.setBit(i)

func parseButton(bits: openarray[int]): int =
  for bit in bits:
    result.setBit(bit)

print ".##.".parseLights # 6
print [1, 3].parseButton # 10

func pushButtons(buttons: openarray[int]): int =
  assert buttons.len >= 2
  result = bitxor(buttons[0], buttons[1])
  for i in 2 .. buttons.high:
    result = bitxor(result, buttons[i])

print pushButtons([[0, 2].parseButton, [0, 1].parseButton]) # 6

# ok light and buttons logic works, now let's parse the whole input (with npeg)

type
  Machine = object
    lights: int
    buttons: seq[int]
    joltages: seq[int]

func parseButton(digits: string): int =
  var bits: seq[int]
  for digit in digits.split(','):
    bits.add digit.parseInt
  result = bits.parseButton

proc parseMachine(line: string): Machine =
  let parser = peg("machine", obj: Machine):
    machine <- '[' * >lights * "]" * Blank * buttons * Blank * joltages:
      obj.lights = parseLights($1)
    lights <- +{'.', '#'}
    buttons <- button * *(Blank * button)
    button <- '(' * >digits * ')':
      obj.buttons.add parseButton($1)
    digits <- +Digit * *(',' * +Digit)
    joltages <- +(1)
  let r = parser.match(line, result)
  assert r.ok

print "[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}".parseMachine

proc parse(text: string): seq[Machine] =
  for line in text.splitLines:
    result.add line.parseMachine

print testInput.parse
# ok for parsing, now onto logic of solution
# plan is to have a intset of reachable light states that I update every time
# for now I do not care of keeping track of which buttons, just which states I reach after n steps

func solve1(machine: Machine): int = 
  var
    states = machine.buttons.toIntSet
  result = 1
  while machine.lights notIn states:
    var newStates = initIntSet()
    for state in states:
      for button in machine.buttons:
        newStates.incl state.bitxor(button)
    states = newStates
    inc result

func solve1(machines: seq[Machine]): int = 
  for machine in machines:
    result.inc machine.solve1

print testInput.parse.solve1
print "day10.input".readFile.parse.solve1