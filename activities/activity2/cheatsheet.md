# Activity 2 cheatsheet — cache set conflicts

Notes on the points I got stuck on. Numbers are for `login3`
(AMD EPYC 7713): L1d 32 KB, 8-way, 64-byte lines, 64 sets.

## 1. Hardware numbers vs. software numbers

| Fixed by the CPU | Chosen in the code |
|---|---|
| line size = 64 bytes | `lda` = slots per row |
| ways = 8 | element type = `double` = 8 bytes |
| sets = 64 | `N` = 2048 |

`sets = size / (ways × line) = 32768 / (8 × 64) = 64`

- The handout's "12-way" is its example machine. Mine is 8-way.
- The program reads these from `/sys/devices/system/cpu/cpu0/cache/index0/`.
  I only write `sets_reachable`; everything else is provided.
- In the output the size appears as `L1d: 32 KB`. "L1d capacity" is only a
  comment in the code.

## 2. Numbers that look the same but are not

| Number | Meaning | Where it comes from |
|---|---|---|
| 8 in `lda × 8` | bytes per double | the data type |
| 8 in `k × 8` | lines per set (ways) | the CPU |
| 64 in `÷ 64` | bytes per line | the CPU, `g.line` |
| 64 in `% 64` | number of sets | the CPU, `g.sets` |

The two 64s are equal only by coincidence on this machine. In code always use
`g.line` and `g.sets`, never a literal 64.

## 3. What `lda` is

- The matrix is one long 1-D array with rows stored end to end.
- `lda` (leading dimension) = how many slots each row occupies.
- Element (row `j`, col `i`) is at index `j * lda + i`.
- `lda` must be at least `N` (2048). Anything more is unused padding at the
  end of every row.
- `lda` is **not** set by the architecture. The harness loops over ten values.
- Padding does not change the data or the amount of work. It only changes how
  far apart rows sit in memory.

## 4. Lines, sets, and what a column touches

- A **line** = 64 bytes = 8 doubles next to each other **in the same row**.
- A **set** holds 8 lines (the ways).
- Elements from different rows are never in the same line.

Going down one column touches **one element per row**, so one line per row:
2048 rows → 2048 different lines.

```
row 0:  [X . . . . . . .] ...      X = written now
row 1:  [X . . . . . . .] ...      . = skipped for now
row 2:  [X . . . . . . .] ...
```

- A whole row covers every set, but the column only touches one line of it.
  That is why a column can end up in a single set.
- The skipped elements are written later, when the outer loop reaches their
  column. Every element is written exactly once in the end.
- The analysis is the same for every column, so the function only needs `lda`.

Where a line goes:

```
memory line number = address / 64        (rounded down)
set                = memory line number % 64
```

Inside that set it may use any of the 8 ways. It can never go to another set.

## 5. The chain: three different numbers

```
lda            slots per row
  × 8          (bytes per double)
row bytes      distance of one step down a column, in bytes
  ÷ 64         (line size)          ← divide by 64, NOT by 8
lines per row  the same distance, in lines            e.g. 257
  % 64         (number of sets)
adv            how far the set number moves per step   0 to 63
  ↓
sets reached   how many different sets the column uses 1 to 64
```

| | Kind of number | Example (`lda` = 2176) |
|---|---|---|
| lines per row | a distance | 272 |
| `adv` | a jump, after removing full laps | 16 |
| sets reached | a count | 4 (sets 0, 16, 32, 48) |

Track picture: lines per row is the stride, `adv` is where the stride leaves
you after ignoring full laps, sets reached is how many different spots you
stand on if you keep taking that stride.

## 6. From `adv` to sets reached

```
row not a whole number of lines   →  sets reached = 64   (drifts through all)
adv = 0                           →  sets reached = 1
otherwise                         →  sets reached = 64 / gcd(adv, 64)
```

- **`adv = 0` gives 1, not 0.** The set number does not move, so every row
  lands in the same set. One set is used. Zero would mean the lines went
  nowhere.
- **Not a whole number of lines** (2049: 256 lines + 8 bytes). The leftover
  bytes add up; every 8 rows the set moves on by 1, so the column drifts
  through every set. Integer division would hide this, so check
  `row_bytes % g.line != 0` first.
- **Why gcd.** You can only land on multiples of what `adv` and 64 share.
  `adv = 24`: 0, 24, 48, 8, 32, 56, 16, 40 → 8 sets = 64 / gcd(24, 64).
- **Mistake I made:** answering with the step size (32, 16, 1) instead of the
  count (2, 4, 64). Big step = few sets.

The function:

```cpp
long row_bytes = (long)lda * 8;
if (row_bytes % g.line != 0) return g.sets;
long lines = row_bytes / g.line;
int  adv   = lines % g.sets;
if (adv == 0) return 1;
return g.sets / std::gcd(adv, g.sets);
```

## 7. My table

| `lda` | row bytes | lines per row | `adv` | sets reached |
|---|---|---|---|---|
| 2048 | 16384 | 256 | 0 | 1 |
| 2049 | 16392 | 256.125 | not whole | 64 |
| 2050 | 16400 | 256.25 | not whole | 64 |
| 2052 | 16416 | 256.5 | not whole | 64 |
| 2056 | 16448 | 257 | 1 | 64 |
| 2064 | 16512 | 258 | 2 | 32 |
| 2080 | 16640 | 260 | 4 | 16 |
| 2112 | 16896 | 264 | 8 | 8 |
| 2176 | 17408 | 272 | 16 | 4 |
| 2304 | 18432 | 288 | 32 | 2 |

## 8. Which `lda` values are good

- The size of the row tells you nothing. Only the remainder matters. A row as
  big as the whole cache (`lda` = 6144) has `adv = 0`: 1 set.
- The ways play no part in **where** a line lands, only in how many fit there.
- Every extra factor of 2 in `lda` halves the sets reached.
- On this machine: `lda` not a multiple of 16 → all 64 sets.
- "Avoid powers of two" is wrong: 2304 is not a power of two and reaches 2
  sets; 2056 is not one either and reaches 64. More padding can be worse.

## 9. The cache holds copies; the data lives in memory

- The whole matrix is always in RAM. L1 holds temporary copies of a few lines.
- On each access: line already in the cache = **hit** (fast). Not there =
  **miss**: fetch it, put it in its set, pushing out an older line if full.
- A pushed-out line is not lost. It moves down: L1 → L2 → L3 → RAM.
- The cache never changes the result, only the time. The checksum is the same
  for every `lda`.

## 10. The column never fits in L1, and does not need to

- 2048 lines × 64 bytes = 128 KB. L1 is 32 KB = 512 lines.
- The loop writes one element at a time, so it needs only one line of `out`
  present at any moment. After the write, the line may be pushed out.
- A line is not removed when its write finishes. It stays until a new line
  needs its place.

## 11. Laps: where `k × 8` comes from

Each lap around the reachable sets adds one line to each. A set has 8 ways, so
after **8 laps** it is full and lines start being pushed out.

| `lda` | sets used `k` | rows before lines are pushed out (`k × 8`) |
|---|---|---|
| 2056 | 64 | 512 |
| 2080 | 16 | 128 |
| 2304 | 2 | 16 |
| 2048 | 1 | 8 |

- sets decide how long a lap is and which sets are usable.
- ways decide how many laps fit.

## 12. Why piling up is slow

8 neighbouring columns share each line. After column 0, column 1 needs the
same 2048 lines again. The cost is how far away each line has been pushed by
then: still close = cheap, pushed far down = expensive. Spreading over more
sets keeps more lines close.

Same number of reads and writes at every `lda`. Only the fetching changes.

## 13. Running it

- Compiling prints nothing on success. Run the result as a second step:
  `g++ -std=c++17 -O1 -o activity2 activity2_conflicts.cpp && ./activity2`
- `./activity2 | head -2` shows only the machine header.
- Timings on this shared node move by about 1 ms between runs.
