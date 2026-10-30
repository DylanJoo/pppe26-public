# PPPE handout — Activities 1 and 2, and midterm review

My notes, organized around the points I got stuck on.
Machine: `login3`, AMD EPYC 7713, about 3.07 GHz.
L1d: 32 KB, 8-way, 64-byte lines, 64 sets.

## The one idea behind both activities

In both, the fast and slow versions run **the same number of instructions**.
The time difference comes from what the CPU has to **wait** for.

| | Activity 1 | Activity 2 |
|---|---|---|
| Topic | pipeline stalls | cache set conflicts |
| The CPU waits for | the previous result | a line to come back from further away |
| Cause | one long dependency chain | a column piling into one cache set |
| Fix | four independent accumulators | pad each row (`lda`) |
| What the fix changes | the order of the work | the addresses of the data |
| Measured gain | 2.15x | 4x to 5x |
| Why it is allowed | multiply is associative | padding does not change the data |

Counting instructions does not predict speed. Ask what each one waits on.

---

# Part A — Activity 1: pipeline stalls

## A1. Tools

- No environment is needed. It is one C++ file and a compiler.
- Build and run: `clang++ -std=c++17 -O1 -o activity1 activity1_pipeline.cpp && ./activity1`
- `-O0` to `-O3` are optimization levels. `-O0` does almost none.
- `-S -o file.s` writes the **assembly** instead of a program. `-S` means
  "stop after producing assembly", `-o` names the output file.

## A2. Reading the C++

| Code | Meaning |
|---|---|
| `unsigned long long` | a 64-bit whole number, never negative |
| `1ull` | the number 1, written as an `unsigned long long` |
| `(unsigned long long)data[i]` | take `data[i]` (an `int`) and widen it to 64 bits |
| `a \| b` | bitwise OR: a bit is 1 if it is 1 in either number |
| `vector<int>& data` | a list of `int`s, passed by reference (`&`): the function uses the caller's list, no copy |

**`| 1ull` is not a fallback or a safety net for errors.** I thought it meant
"use 1 if the line fails". It is arithmetic: it switches on the lowest bit,
which makes the number odd.

```
6 | 1 = 7        (110 | 001 = 111)
7 | 1 = 7        (already odd, unchanged)
```

Why it is there: multiplying by even numbers keeps adding factors of 2. After
enough of them the 64-bit product becomes 0 and stays 0, and a benchmark that
multiplies 0 by something 100 million times measures nothing useful.

Why `unsigned`: when an unsigned number overflows it wraps around, and that is
defined behaviour, so the result is well defined and checkable.

## A3. The concept

- A **pipeline** overlaps the stages of consecutive instructions.
- It can only overlap instructions that are independent.
- **RAW dependency** (read after write): a later instruction reads a value an
  earlier one writes. This is a fact about the code and is always there.
- **RAW hazard**: the dependency becomes a hazard when the reader is ready to
  start but the value is not ready yet. It has to wait. That wait is a
  **stall**. Dependency = always. Hazard = only when it causes waiting.
- **Latency**: how long one operation takes to produce its result. A 64-bit
  multiply takes about 3 cycles on this CPU.

The slow version has one accumulator, so every multiply needs the result of
the one before:

```cpp
x = x * d0;     // needs x
x = x * d1;     // needs the x just written
x = x * d2;     // needs the x just written
x = x * d3;     // needs the x just written
```

This is a **dependency chain**. Its length sets the time, however many
multipliers the chip has.

## A4. The fix

```cpp
unsigned long long x0 = 1, x1 = 1, x2 = 1, x3 = 1;     // seed with 1

for (int i = 0; i < ARRAY_SIZE; i += 4) {
    // LOAD PHASE: depends only on memory
    unsigned long long d0 = (unsigned long long)data[i]     | 1ull;
    unsigned long long d1 = (unsigned long long)data[i + 1] | 1ull;
    unsigned long long d2 = (unsigned long long)data[i + 2] | 1ull;
    unsigned long long d3 = (unsigned long long)data[i + 3] | 1ull;

    // COMPUTE PHASE: four chains that never touch each other
    x0 *= d0;
    x1 *= d1;
    x2 *= d2;
    x3 *= d3;
}
return x0 * x1 * x2 * x3;                              // combine once, after the loop
```

- **Load phase**: read the four values out of `data` into temporaries. They
  depend on nothing but memory, so all four can proceed together.
- **Compute phase**: each accumulator is multiplied only by its own value.
- **Seed with 1** because 1 is the value that changes nothing under multiply.
- **Combine after the loop.** Combining inside it would rebuild the chain.

**Why this is legal.** The four-chain version multiplies in a different order.
It gives the same answer only because 64-bit unsigned multiply is associative
and commutative. Check: `Same answer? YES`, checksum `16783984258637683210` at
every level. For an operation that is not associative, the same trick gives a
faster loop that computes the wrong number.

## A5. Reading the assembly

- **Finding a function.** C++ mangles names. Search for the plain name inside
  the label: `_Z10noTempVarsRSt6vectorIiSaIiEE`,
  `_Z12withTempVarsRSt6vectorIiSaIiEE`. The loop is the block between
  `.LBB0_1:` (or `.LBB1_1:`) and the `jb` that jumps back to it.
- **Operand order.** In this syntax the **last** operand is the destination.
  `imulq %rax, %rsi` means `rsi = rsi × rax`. It reads both and writes `rsi`,
  not `rax`. I had this backwards.
- **A register is a reusable box.** The same name holds different values at
  different moments. In `noTempVars`, `rax` holds `x`, then is reloaded with
  `d1`, then with `d3`, then ends as the new `x`.

| Instruction | Meaning |
|---|---|
| `movslq 16(%rcx,%rdx,4), %rsi` | load a 32-bit `int` from memory, widen it to 64 bits, put it in `rsi` |
| `orq $1, %rsi` | the `\| 1ull` |
| `imulq %rax, %rsi` | `rsi = rsi × rax` |
| `addq $4, %rdx` | `i += 4` |
| `cmpq` then `jb` | compare `i` with the limit, jump back if not done |

**Vector / SIMD registers.** These hold several numbers at once. The handout
names the ARM ones (`v0`, `q0`). On this x86 machine they are `xmm`, `ymm`,
`zmm`. Neither function uses any: both are plain scalar code.

## A6. Tracing the waits

`noTempVars`, one pass of the loop:

| # | Instruction | Computes | Waits for |
|---|---|---|---|
| 1 | `imulq %rax, %rsi` | `rsi = d0 × x` | `x` from the previous pass (multiply 4) |
| 2 | `imulq %rax, %rdi` | `rdi = d2 × d1` | nothing: both just came from memory |
| 3 | `imulq %rsi, %rdi` | `rdi = (d1 d2) × (x d0)` | multiply 1 (needs `rsi`) |
| 4 | `imulq %rdi, %rax` | `rax = d3 × rdi`, the new `x` | multiply 3 (needs `rdi`) |

- The chain is 1 → 3 → 4, then back to 1 on the next pass.
- **Why only 3 multiplies on the chain, not 4.** The compiler regrouped the
  work so that `d1 × d2` is computed on the side (multiply 2). It needs no
  earlier result, so it does not wait. This is the compiler using
  associativity a little, but the chain through `x` is still there.
- Multiply 3 waits for `rsi` because multiply 1 is still producing it.

`withTempVars`, one pass:

```
imulq %r9, %rcx        rcx = rcx × d0
imulq %r9, %rax        rax = rax × d1
imulq %r9, %rdx        rdx = rdx × d2
imulq %r9, %r8         r8  = r8  × d3
```

Each multiply writes its own accumulator (`rcx`, `rax`, `rdx`, `r8`). None
reads what another multiply in the same pass wrote. Each one only waits for
its own accumulator from the previous pass: a chain of 1 multiply.

## A7. Results and what they mean

| Level | One chain | Four chains | Speedup |
|---|---|---|---|
| `-O0` | 581 ms | 518 ms | 1.12x |
| `-O1` | 73 ms | 34 ms | 2.15x |
| `-O2` | 74 ms | 34 ms | 2.18x |
| `-O3` | 74 ms | 34 ms | 2.18x |

- **Instruction count is the same.** 15 in each loop body: 4 `movslq`,
  4 `orq`, 4 `imulq`, `addq`, `cmpq`, `jb`. Same work, half the time.
- **`-O1`, `-O2`, `-O3` give the same times because the two functions are
  compiled to identical instructions at all three.** The `.s` files do differ,
  but only elsewhere (the benchmark and `main`). Compare the function blocks,
  not the whole files.
- **`-O0` barely benefits.** With no optimization every variable is stored to
  memory and reloaded between statements. That traffic takes up much of the
  time in both versions, so removing the stall changes the total less. `-O0`
  does this on purpose: a debugger must be able to show every variable's
  current value.
- **The vectorizer (`-O2` and up) could not help the one-chain loop.** Every
  multiply needs the previous multiply's result, so there are no independent
  multiplies to put side by side.
- **The compiler did not split the chain for me.** It was allowed to, since
  multiply is associative, and it did regroup `d1 × d2`. It still left one
  chain through `x`. Do not rely on the optimizer for this. Write the
  independent accumulators yourself. "Allowed" and "actually done" are
  different things.
- For a floating-point sum the compiler is not even allowed to split the
  chain, because floating-point addition is not associative, unless you pass
  `-ffast-math`.

**Checking with cycles** (25 million loop passes, about 3.07 GHz):

| Version | Time per pass | Cycles per pass | Chain alone predicts |
|---|---|---|---|
| One chain | 2.9 ns | about 9 | 3 multiplies × 3 cycles = 9 |
| Four chains | 1.4 ns | about 4 | 1 multiply × 3 cycles = 3 |

The one-chain version matches its chain exactly. The four-chain version is a
little slower than its chain allows, so something else became the limit. My
guess is reading 400 MB of data from memory, but I have not verified it.
(My answer sheet wrote the speedup as 9 / 4. The 9 is the chain. The 4 matches
the measurement, but it is not "4 multiplies".)

---

# Part B — Activity 2: cache set conflicts

## B1. Hardware numbers vs. software numbers

| Fixed by the CPU | Chosen in the code |
|---|---|
| line size = 64 bytes | `lda` = slots per row |
| ways = 8 | element type = `double` = 8 bytes |
| sets = 64 | `N` = 2048 |

`sets = size / (ways × line) = 32768 / (8 × 64) = 64`

- Line size and ways are different things. Line size is how big one line is
  (64 bytes). Ways is how many lines one set holds (8).
- The handout's "12-way" is its example machine. Mine is 8-way.
- The program reads these from `/sys/devices/system/cpu/cpu0/cache/index0/`.
  I only write `sets_reachable`; everything else is provided.
- In the output the size appears as `L1d: 32 KB`. "L1d capacity" is only a
  comment in the code.

## B2. Numbers that look the same but are not

| Number | Meaning | Where it comes from |
|---|---|---|
| 8 in `lda × 8` | bytes per double | the data type |
| 8 in `k × 8` | lines per set (ways) | the CPU |
| 8 doubles per line | 64 bytes / 8 bytes | both |
| 64 in `÷ 64` | bytes per line | the CPU, `g.line` |
| 64 in `% 64` | number of sets | the CPU, `g.sets` |

The two 64s are equal only by coincidence on this machine. In code always use
`g.line` and `g.sets`, never a literal 64.

## B3. What `lda` is

- The matrix is one long 1-D array with rows stored end to end.
- `lda` (leading dimension) = how many slots each row occupies.
- Element (row `j`, col `i`) is at index `j * lda + i`.
- `lda` must be at least `N` (2048). Anything more is unused padding at the
  end of every row.
- `lda` is **not** set by the architecture. The harness loops over ten values.
- Padding does not change the data or the amount of work. It only changes how
  far apart rows sit in memory.

## B4. Lines, sets, and what a column touches

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

- Inside that set it may use any of the 8 ways. It can never go to another set.
- The CPU does not travel through the sets. It reads the set bits of the
  address and goes straight there. Other sets are not touched by that access.
- **Why it is designed this way:** a lookup only has to check 8 lines, not all
  512, so it is very fast. The price is that lines sharing a set can push each
  other out while the rest of the cache has room. That is a **conflict miss**.

## B5. The chain: three different numbers

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

## B6. From `adv` to sets reached

```
row not a whole number of lines   →  sets reached = 64   (drifts through all)
adv = 0                           →  sets reached = 1
otherwise                         →  sets reached = 64 / gcd(adv, 64)
```

- **`adv = 0` gives 1, not 0.** `next set = (current set + 0) % 64`, so every
  row lands in the same set. One set is used. Zero would mean the lines went
  nowhere. At `lda` = 2048 a step is 256 lines = exactly 4 laps of 64.
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

Mistakes in my first pseudocode: returned 64 for `adv == 0`, left out the
whole-lines check, and used a literal 64 for both line size and sets.

## B7. My table (AMD, `login3`)

| `lda` | row bytes | lines per row | `adv` | sets reached | time |
|---|---|---|---|---|---|
| 2048 | 16384 | 256 | 0 | 1 | 35.4 ms |
| 2049 | 16392 | 256.125 | not whole | 64 | 9.1 ms |
| 2050 | 16400 | 256.25 | not whole | 64 | 7.9 ms |
| 2052 | 16416 | 256.5 | not whole | 64 | 7.7 ms |
| 2056 | 16448 | 257 | 1 | 64 | 7.9 ms |
| 2064 | 16512 | 258 | 2 | 32 | 6.8 ms |
| 2080 | 16640 | 260 | 4 | 16 | 7.6 ms |
| 2112 | 16896 | 264 | 8 | 8 | 11.9 ms |
| 2176 | 17408 | 272 | 16 | 4 | 14.8 ms |
| 2304 | 18432 | 288 | 32 | 2 | 20.1 ms |

- Threshold: fast if sets reached ≥ 16. The curve is flat past 16.
- Timings on this shared node move by about 1 ms between runs.

## B8. Which `lda` values are good

- The size of the row tells you nothing. Only the remainder matters. A row as
  big as the whole cache (`lda` = 6144) has `adv = 0`: 1 set.
- The ways play no part in **where** a line lands, only in how many fit there.
- Every extra factor of 2 in `lda` halves the sets reached.
- On this machine: `lda` not a multiple of 16 → all 64 sets.
- "Avoid powers of two" is wrong: 2304 is not a power of two and reaches 2
  sets; 2056 is not one either and reaches 64. More padding can be worse.
- Cheapest fix: `lda` = 2049, 1/2048 = 0.049% more memory, about 4x faster.
  2056 (one whole line, 0.39%) keeps rows line-aligned and was the better
  choice on the Intel machine.

## B9. The cache holds copies; the data lives in memory

- The whole matrix is always in RAM. L1 holds temporary copies of a few lines.
- On each access: line already in the cache = **hit** (fast). Not there =
  **miss**: fetch it, put it in its set, pushing out an older line if full.
- A pushed-out line is not lost. It moves down: L1 → L2 → L3 → RAM.
- The cache never changes the result, only the time. The checksum is the same
  for every `lda`.

## B10. The column never fits in L1, and does not need to

- 2048 lines × 64 bytes = 128 KB. L1 is 32 KB = 512 lines.
- The loop writes one element at a time, so it needs only one line of `out`
  present at any moment. After the write, the line may be pushed out.
- A line is not removed when its write finishes. It stays until a new line
  needs its place.

## B11. Laps: where `k × 8` comes from

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

## B12. Why piling up is slow

8 neighbouring columns share each line. After column 0, column 1 needs the
same 2048 lines again. The cost is how far away each line has been pushed by
then: still close = cheap, pushed far down = expensive. Spreading over more
sets keeps more lines close.

Reads and writes behave differently in the same loop:

- **Reads** go along a row, 8 bytes at a time, set by set. Evenly spread.
  Fine at every `lda`.
- **Writes** jump down a column, `lda × 8` bytes at a time. Only these depend
  on `lda`, which is why the prediction looks at writes only.

## B13. Does the rule transfer (two machines)

`login3` has one type of core, so I compared two machines.

| | AMD EPYC 7713 | Intel Xeon Silver 4114 |
|---|---|---|
| Clock | 3.08 GHz | 2.48 GHz |
| L1d size / ways / sets | 32 KB / 8 / 64 | 32 KB / 8 / 64 |
| Time at `lda` = 2048 | 35.4 ms | 144.7 ms |
| Best time | 6.8 ms | 13.7 ms |
| Padding speedup | 5.2x | 10.5x |

- **Predictions did not change.** The formula uses `lda`, element size, line
  size and number of sets. It does not use the clock, the model, the L1 size
  or the ways.
- **The ratio test.** Slow time / fast time, compared with the clock ratio
  (1.24). Near the clock ratio = limited by the core. Far from it = waiting
  on something else.
  - best `lda`: 13.7 / 6.8 = 2.0 (closer: mostly the core)
  - `lda` = 2048: 144.7 / 35.4 = 4.1 (far: waiting on memory)
- **The slower machine gains more from padding.** 4.1 / 2.0 = 2.0, the same
  as 10.5 / 5.2. Same fact seen from both sides.
- Neither ratio equals 1.24 because two machines differ in more than clock.
- Exception on Intel: 2049 and 2050 reach 64 sets but took 29.6 and 25.9 ms,
  against 13.7 ms for 2056. Sets reached does not explain that.

---

# Part C — Habits that apply to both

## C1. Measuring properly

| Habit | Why |
|---|---|
| Take the minimum of several runs | other activity only makes a run slower, never faster |
| Check the answer (checksum, "Same answer?") | a faster loop that computes something else is a bug |
| Keep the result used (`result +=`, `clobber()`) | otherwise the compiler may delete the work being timed |
| Warm up before timing | the clock rises only after the core has been busy |
| Pin to one core | different cores can have different speeds |
| Repeat the whole run | tells you how big the noise is before you compare numbers |

## C2. Turn times into cycles

```
cycles per item = time / number of items × clock (GHz, with time in ns)
```

| Loop | Per item | Cycles | Reading |
|---|---|---|---|
| A1, one chain | 2.9 ns per pass | about 9 | 3 multiplies of 3 cycles in a chain |
| A1, four chains | 1.4 ns per pass | about 4 | chain broken |
| A2, `lda` 2048 | 8.4 ns per element | about 26 | about 20 cycles of waiting for lines |
| A2, `lda` 2080 | 1.8 ns per element | about 6 | conflicts gone |

## C3. Running things

- Compiling prints nothing on success. Run the result as a second step:
  `g++ -std=c++17 -O1 -o activity2 activity2_conflicts.cpp && ./activity2`
- `./activity2 | head -2` shows only the machine header.
- A file open in an editor does not pick up changes made on disk. Reload it
  (`:e!` in vim) before saving, or the save overwrites them.

## C4. Formulas in one place

```
Activity 1
  time per pass   ≈ (multiplies on the longest chain) × (multiply latency)

Activity 2
  sets            = size / (ways × line)
  row bytes       = lda × 8
  lines per row   = row bytes / line
  adv             = lines per row % sets
  sets reached    = sets                      if row bytes is not a multiple of line
                    1                         if adv = 0
                    sets / gcd(adv, sets)     otherwise
  lines that fit  = sets reached × ways
  padding cost    = (lda − N) / N
```

---

# Part D — Midterm review (from the practice midterm)

Answers checked against the course's own answer key
(`exams/midterm/practice_midterm.answers.md`).

## D0. What it covers

| Problem | Topic | Lecture |
|---|---|---|
| 1 | RAW dependencies, scheduling straight-line code by hand | pipeline |
| 2, 3 | dependencies carried from one loop iteration to the next | ILP |
| 4 | optimization levels (Activity 1) | pipeline |
| 5, 6 | branch prediction, branch-free code | branches |
| 7 | reorder buffer and distance | ILP |
| 8 | how far away the data is | memory hierarchy |
| 9 | hardware prefetching | memory hierarchy |

The practice set has no cache-set-conflict problem, but Part B ideas appear in
8 and 9: a line is 64 bytes = 8 doubles, and stride decides the cost.

## D1. Scheduling by hand (Problem 1)

Rules given: add = 1 cycle, multiply = 3 cycles, at most one instruction
starts per cycle **in the order written**, and an instruction cannot start
until its inputs are ready.

**Method.** Make a table: waits for, starts, result ready. An instruction that
starts in cycle *t* with latency *L* has its result usable in cycle *t + L*
(so it is finished at the end of cycle *t + L − 1*).

```
1.  x = a + b
2.  y = x * 2
3.  w = y + 1
4.  z = c + d
5.  v = z * 2
```

Dependencies: 1 → 2 (`x`), 2 → 3 (`y`), 4 → 5 (`z`).

| Instruction | Waits for | Starts | Result ready |
|---|---|---|---|
| 1 | nothing | 1 | 2 |
| 2 | `x`, ready in 2 | 2 | 5 |
| 3 | `y`, ready in 5 | **5** (stalls 2) | 6 |
| 4 | stuck behind 3 | 6 | 7 |
| 5 | `z`, ready in 7 | 7 | 10 |

- All done at the end of **cycle 9**.
- Instruction 4 depends on nothing, yet starts late because it is stuck
  behind 3. In-order execution lets one stall delay unrelated work.
- **Reordered 1, 2, 4, 5, 3**: starts in cycles 1, 2, 3, 4, 5. No stalls. Done
  at the end of **cycle 6**. The independent work fills the waiting cycles.
- An out-of-order core does this itself. To do it safely it needs the
  **dependencies**: which instruction reads which earlier result. Written
  order only matters where there is a RAW dependency.

## D2. Dependencies carried between iterations (Problems 2, 3)

On an out-of-order core, the only thing that makes an iteration wait is a
value from an **earlier iteration**.

| Loop | Carried? | Fewest cycles per iteration |
|---|---|---|
| `b[i] = 2 * a[i] + 1` | no | no RAW limit |
| `x = x * a[i]` | yes, through `x` | 3 (multiply latency) |
| `c[i] = a[i] + a[i-1]` | no | no RAW limit |
| `p[i] = p[i-1] + a[i]` | yes, through `p` | 1 (add latency) |

- **Fewest cycles per iteration = latency of the operations on the carried
  chain**, however many execution units the core has.
- **Two reads are not a dependency.** `c[i] = a[i] + a[i-1]` reads something
  an earlier iteration also read, but nothing writes `a`. RAW needs a write.
- `x = x * a[i]` can be split into accumulators (associative). The running
  sum `p[i]` cannot: every output is itself a running total.

**Dot product, `s = s + a[i] * b[i]` (Problem 3).** One hazard only: the add
to `s` in one iteration → the add to `s` in the next (register `x2`).

- The loads depend only on `i`, so the core issues them early.
- The multiply is fed by fresh loads. It is not on the chain between
  iterations.
- Loop control (`i + 1`, compare, branch) is predicted.
- Trap: on an **in-order** pipeline the load → multiply and multiply → add
  arrows are real stalls. On an out-of-order core they are not.

How to spot it in assembly: an instruction that reads and writes the same
register, like `add x2, x2, x9`, where the value comes from the previous
iteration.

## D3. Optimization levels (Problem 4)

See A7. The three answers:

- `-O0` speedup is small because both versions spend most of their time
  storing and reloading variables.
- The compiler did not split the chain. It is allowed to. That job is mine.
- The vectorizer cannot help: no independent multiplies to put side by side.

## D4. What makes a branch predictable (Problem 5)

**A predictor learns patterns in a branch's history, not how often it is
taken.** "Taken 50% of the time" does not mean unpredictable.

| Test | Taken | Mispredicted | Why |
|---|---|---|---|
| `i % 2 == 0` | 50% | almost never | fixed pattern: taken, not taken, ... |
| `x[i] % 2 == 1` | 50% | about half | random data, nothing to learn |
| `x[i] < 250` | about 98% | about 2% | usually the same way |
| `i < n / 2` | 50% | about once | changes once, at the halfway point |

**Estimating the cost:**

```
extra time = mispredictions × cycles each ÷ clock
           = 16 million × 20 ÷ (4 × 10^9 per second) = 80 ms
```

Measured: 79 − 7.5 ≈ 72 ms. A misprediction costs about 20 cycles.

A rare misprediction still adds up: 2% of 32 million is about 750,000
mispredictions, a few milliseconds.

## D5. Branch or no branch (Problem 6)

Branch-free code is a **trade**: it never mispredicts, but it always does the
work, even when the result is thrown away.

| Situation | Winner | Why |
|---|---|---|
| skewed classes (10% / 90%) | `if` | predictor is right about 90% of the time, and `if` skips 90% of the work |
| balanced, random, 4 features | branch-free | wrong half the time, and 20 cycles costs more than the small update |
| balanced, random, 16 features | `if` | the update now costs more than a misprediction |

Rule: branch-free wins when the branch is **unpredictable** and the needless
work is **cheap**. It loses when the branch is predictable, or the needless
work costs more than a misprediction.

## D6. The reorder buffer and distance (Problem 7)

The core can only overlap instructions that are in the reorder buffer at the
same time. Take about 600 entries, and a lookup that misses for about 500
cycles.

```
iterations in the buffer ≈ buffer size ÷ instructions per iteration
```

- **Small `f` (20 instructions):** about 25 per iteration, so about **24
  lookups** are in the buffer together. They are independent, so their waits
  overlap. The loop pays the memory wait about once per 24 lookups.
- **Big `f` (2,000 instructions):** the missing lookup sits at the head.
  Nothing can retire until it completes, so the buffer fills with `f` and
  fetching stops. The next lookup is 2,000 instructions away and never gets
  in. **One** lookup waits at a time: every iteration pays the full 500.
- The lookups are just as independent in both cases. What changed is the
  **distance** between them.
- **Fix: loop fission.** Split into two loops, lookups first, then the calls
  to `f`. Legal because `f` does not use the loaded values.

## D7. How far away is the data (Problem 8)

Class machine (AMD Zen 5, about 5 GHz). Remember the ratios, not the digits.

| Where | Size | Latency (cycles) |
|---|---|---|
| register | a few bytes | 0 extra |
| L1 | 48 KB | 4 |
| L2 | 1 MB | 14 |
| L3 | 16 MB | about 70 |
| memory (DRAM) | many GB | about 500 |

Each level is roughly 4 to 7 times slower than the one above. Memory is about
130 times slower than L1.

| Example | Where the read lands | Why |
|---|---|---|
| a counter in a loop | register, 0 extra | used every iteration, so the compiler keeps it in a register |
| a 16-entry table read over and over | L1, about 4 | **repeated reference** to small data stays in the fastest cache |
| a linked list scattered over 1 GB | memory, about 500 | every node is a **new reference**, the prefetcher cannot guess it, and each `p.next` needs the previous read, so reads cannot overlap |

Pointer chasing is the worst case: a miss on every step **and** a dependency
chain, so the misses happen one after another.

## D8. Hardware prefetching (Problem 9)

| Pattern | ns per load | Why |
|---|---|---|
| in order: 0, 1, 2, ... | 0.53 | prefetched, and all 8 doubles of each line are used |
| every 8th: 0, 8, 16, ... | 0.82 | prefetched, but a new line for every load |
| one per line, lines in random order | 2.9 | cannot be predicted, so every load waits for memory |

- The prefetcher watches the addresses and recognises **constant strides**,
  not just "the next line".
- Patterns 2 and 3 read the same lines. Only the order differs, and random
  order defeats the prefetcher.
- Pattern 1 beats pattern 2 because it needs one line per 8 loads. Same
  prefetching, one eighth of the data moved.

## D9. Three assembly syntaxes

| Syntax | Where I see it | Destination | Example |
|---|---|---|---|
| AT&T | my Activity 1 `.s` files | **last** | `imulq %rax, %rsi` → `rsi = rsi × rax` |
| Intel | midterm Problem 8 | **first** | `mov rdi, [rdi + 8]` → `rdi = memory at rdi + 8` |
| Arm64 | midterm Problem 3 | **first** | `add x2, x2, x9` → `x2 = x2 + x9` |

Square brackets (Intel, Arm64) or parentheses (AT&T) mean a read from memory.
`[rsi + 4*rax]` is element `rax` of an array of 4-byte values starting at
`rsi`.

## D10. Exam formulas

```
result usable in cycle       = start cycle + latency
cycles per iteration         ≥ latency of the chain carried between iterations
extra time from mispredicts  = mispredictions × ~20 cycles ÷ clock
iterations in reorder buffer = buffer size ÷ instructions per iteration
lines needed                 = loads ÷ (elements used per line)
```

One question to ask of any loop: **what is it waiting for?** A previous
result (chain), a wrong guess (branch), or data that is far away (cache).
