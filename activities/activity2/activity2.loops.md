# Activity 2 — Cache Set Conflicts: Predicting Which Array Sizes Are Slow

(co-authored by Claude and Codex)

## Background

A matrix transpose reads one row of the input left to right — stride 1, which
the hardware prefetcher handles easily — and writes one *column* of the output,
stepping a full row between consecutive writes. That write stride is where the
time goes, and how much time depends on a number you might not expect: the
**leading dimension**, which is how many elements one row occupies in memory.

The logical matrix here is always 2048 × 2048. What changes is `lda`, the row
stride. `lda = 2048` is the obvious, tight-packed choice. It is also, on most
machines, the worst one you could pick.

Here is the mechanism. Cache lines are assigned to sets by their address:

```
set index = (address / line_size) % number_of_sets
```

Stepping down one column advances the address by one row — `lda * 8` bytes for
doubles. In cache lines that is `lda * 8 / line_size`, so each step down the
column advances the set index by

```
adv = (lda * 8 / line_size) % number_of_sets
```

Repeatedly adding `adv` modulo the set count visits only some of the sets, and
possibly very few of them. When `adv` is 0, every element of the column lands in
**one single set** — and a set holds only `ways` lines. A 2048-element column
fighting over a 12-way set evicts itself continuously, from the top of the
column to the bottom, every time.

Your job is to turn that paragraph into a function that **predicts**, before
running anything, which leading dimensions will be slow.

## Getting started

Two files come with this assignment:

* [`activity2.loops.starter.cpp`](activity2.loops.starter.cpp) — the harness.
  Rename it to `activity2_conflicts.cpp` and work in it.
* This handout.

The harness already reads your machine's cache geometry from
`/sys/devices/system/cpu/cpu*/cache/`, pins itself to a core, warms the clock,
runs the transpose across ten leading dimensions, and prints a table. **You
write exactly one function.**

```bash
g++     -std=c++17 -O1 -o activity2 activity2_conflicts.cpp && ./activity2   # Linux
clang++ -std=c++17 -O1 -o activity2 activity2_conflicts.cpp && ./activity2   # macOS
```

It runs on x86-64 and on Apple silicon. If the program cannot work out your
cache geometry, supply it by hand and it will use what you give it:

```bash
L1_SIZE=131072 L1_WAYS=8 L1_LINE=128 ./activity2
```

macOS does not report associativity at all, so on a Mac the program measures
it — by chasing a pointer around W lines that all land in one set and finding
the W where the hops stop being L1 hits. It prints what it found.

> **Two things the harness does that you should not remove.** It pins to one
> core, because this machine has fast and slow cores and an unpinned run lands
> on whichever the scheduler picks. And it spins on a high-IPC loop before
> measuring, because the clock governor boosts on instructions-per-cycle, not on
> the core being busy — a memory-bound loop left alone runs the whole way at the
> base clock, and *every* repetition is equally slow, so taking the minimum of
> five does not save you. Both are why the program prints the clock it measured
> at, at the start and at the end.

## Part 1 — Read your machine

Run the starter as given and record what it prints for your machine:

| Quantity | Value |
|---|---|
| L1d size | 32768 bytes |
| Associativity (ways) | 8 |
| Line size (bytes) | 64 bytes |
| Number of sets | 64 sets |
| Core clock after warm-up | 3.07GHz |

**(a)** The harness computes `sets = size / (ways * line)`. Verify that
arithmetic by hand for your machine and show the calculation.

<!-- # cat /sys/devices/system/cpu/cpu0/cache/index0/size -->
> 32768 / (8 * 64) = 64 sets 

**(b)** How many doubles fit in one cache line on your machine?

> Each line is 64 bytes / 8 bytes = 8 doubles

## Part 2 — Predict, before you measure

Implement `sets_reachable(lda, g)` in your `activity2_conflicts.cpp`. It returns how many
distinct L1 sets one column of the matrix touches, given the leading dimension
and your machine's geometry.

```cpp
int sets_reachable(int lda, const Geometry& g) {
    // your code
}
```

Two cases are easy to get wrong, and both appear in the table below:

* A row that is **not a whole number of cache lines**. The set index no longer
  cycles through a fixed pattern — think about what it does instead.
* An advance of **exactly 0**. Do not let this fall out of your `gcd` as if it
  were an ordinary case; reason about what the column actually does.

Now **fill in the prediction column before you run the program.** This is the
graded part of the assignment, and predictions submitted after measuring are
worth nothing — the whole point is that the formula tells you the answer in
advance.

| `lda` | row bytes | sets reached (predicted) | fast or slow? (predicted) |
|---|---|--- |---|
| 2048  | 16384  | 1  | slow |   
| 2049  | 16392  | 64 | fast | 
| 2050  | 16400  | 64 | fast |    
| 2052  | 16416  | 64 | fast | 
| 2056  | 16448  | 64 | fast | 
| 2064  | 16512  | 32 | fast | 
| 2080  | 16640  | 16 | fast | 
| 2112  | 16896  | 8  | slow |  
| 2176  | 17408  | 4  | slow |  
| 2304  | 18432  | 2  | slow |  


**(c)** State your rule for "fast or slow" as a threshold on sets reached, and
justify the number you picked using the associativity of your L1. How many
lines of a single column can be resident at once if the column reaches `k`
sets?
> sets reached >= 16 is fast, reaching 4 to 5x. When <= 8, it is slow.

> Reaching k sets means k * 8-way (this machine has only 8) = 8k lines.
> Each set holds only 8, so every later write evicts a line the same column just loaded.
> I set k=16 because below it the column is confined to 8 or fewer of the 64 sets 
> ~ around an eighth of the cache (64 / 8) or less.

## Part 3 — Measure, and score yourself

Run the program and fill in the measured column:

|   `lda` | sets reached | measured time | speedup vs `lda`=2048 | prediction correct? |
|-------- |-----------   |----------     |-----------  |  ------ | 
|    2048 |          1   |    35.4 ms    |       1.00x | correct | 
|    2049 |         64   |     9.1 ms    |       3.90x | correct | 
|    2050 |         64   |     7.9 ms    |       4.50x | correct | 
|    2052 |         64   |     7.7 ms    |       4.60x | correct | 
|    2056 |         64   |     7.9 ms    |       4.47x | correct | 
|    2064 |         32   |     6.8 ms    |       5.23x | correct | 
|    2080 |         16   |     7.6 ms    |       4.67x | correct | 
|    2112 |          8   |    11.9 ms    |       2.98x | correct | 
|    2176 |          4   |    14.8 ms    |       2.40x | correct | 
|    2304 |          2   |    20.1 ms    |       1.76x | correct |   


**(d)** Sort your rows by sets reached rather than by `lda`. Is the time
monotonic in sets reached? Where does the curve flatten out — that is, past what
number of sets does reaching more sets stop buying you anything?

> Mostly yes. Starting from only 1 set reached is 35.4ms, and gradually improves along
> with set reached increase until >16, it flattens out.


**(e)** `2304` is not a power of two, and it is one of the slowest rows in the
table. `2049` is odd and is one of the fastest. A classmate tells you the rule
is "avoid powers of two." Using your formula, explain in one or two sentences
what the actual rule is.

> That is not the rule. The formula matters, the main cause is 
> the adv shared with the number of sets: (`lda` * 8 / line size 64 ) % number of sets 64. 
> For example, 2304 is not a power of two, but its adv is 32 = (2304/8) % 64
> And then calculate the sets reached is 2 = 64 / gcd(adv, 64). 
> 2049 is not a whole number so it reaches all the sets equally.

**(f)** You have a 2048 × 2048 matrix of doubles and you are allowed to waste
some memory on padding. What is the **smallest** `lda ≥ 2048` that reaches your
threshold from (c)? How much extra memory does that padding cost, as a
percentage? Verify by adding it to the `ldas[]` list and re-running.

> 2049
> 1/2048 = 0.049%
> It's already in the above table, which speeds up 3.9x.

## Part 4 — Does the rule transfer?

This machine is not one processor. `cpu0`–`cpu3` are Zen 5 cores; `cpu4`–`cpu11`
are Zen 5c "dense" cores with a lower clock. The harness reads `PIN_CPU` so you
can run the same binary on each:

```bash
PIN_CPU=2 ./activity2     # a Zen 5 core
PIN_CPU=6 ./activity2     # a Zen 5c core
```

On Apple silicon there is no way to pin to a numbered core, so the program asks
for a *cluster* instead via its quality-of-service class: `PIN_CPU` under 4
requests a performance core, 4 or above an efficiency core. Same experiment,
same two questions — a fast cluster and a slow one.

Run both and fill in:

| 		     | AMD | Intel |
|---|---|---|
| Model 	          | EPYC 7713 | Xeon Silver 4114 |
| Clock after warm-up     | 3.08GHz | 2.48 GHz |
| L1d size / ways / sets  | 32KB/8/64 | 32KB/8/64 |
| Time at `lda` = 2048    | 35.4 ms | 144.7 ms|
| Best time in the table  | 6.8ms   | 13.7 ms |
| Speedup, worst to best  | 5.2x    | 10.5x   |

> I ran the experiments on the lab cluster with two machines with different CPU cores.
> So I don't have comparison like the different cores Zen 5/5c.

**(g)** Did your Part 2 predictions need to change at all for the second core?
Explain why or why not in terms of what the formula actually depends on.

> No. The formula doesn't change because the lda, L1 size, ways and sets are the same. 
> Thus, the sets reached are identical. 
> The results are largely matched. The only difference comes from the different machines.


**(h)** Compute two ratios: the slow core's time divided by the fast core's
time at `lda = 2048`, and the same ratio at your best `lda`. Then compute the
ratio of the two clock speeds. One of your two ratios is close to the clock
ratio and the other is much smaller.

Which is which, and what does that tell you about where the time goes in each
case? (Hint: a loop whose time scales with the core clock is limited by the
core. A loop whose time barely moves when the clock changes is limited by
something else.)

> Time at lda = 2048: 144.7  / 35.4 (Intel vs AMD) = 4.1
> Time at best lda  : 13.7  / 6.8   (Intel vs AMD) = 2.0
> Clock speeds:     : 3.08 / 2.48   (Intel vs AMD) = 1.24

> We can see that "Time at best lda" is closer to the ratio 1.24, 
> which depends mostly on the core itself.
> While "Time at lda" has very high ratio because it involves more factors 

> PS. the other confounders might also affect the results (e.g., memory). 

**(i)** The padding speedup is *larger* on the slower core. Is that consistent
with your answer to (h)? Explain.

> Yes. The padding speedup is 10.5x on the slow machine and 5.2x on the fast one.
> This is consistent with the finding in (h). 
> The main reason is that the time at 2048 is waiting for evicted lines, but padding
> removes it so it gains more with larger ratio.

## Part 5 — AI Use Disclosure

State whether you used AI tools for this assignment. If you did, name the tools
and briefly describe how you used them. Full credit is earned at every level of
use; the course was designed with AI as a partner in mind.

> I used Claude Code (Claude Opus 5.5) to explain the concepts step by step,
> to finish the implementation and review execution results. 
> I draft the answer with Claude and debug with Claude.

## What to submit

1. Your completed `activity2_conflicts.cpp`, with `sets_reachable` implemented.
   (30 points)
2. A document with your written answers:
   - 2a. Part 1 table and answers (a)–(b). (10 points)
   - 2b. Part 2 prediction table and answer (c). (20 points)
   - 2c. Part 3 measured table and answers (d)–(f). (20 points)
   - 2d. Part 4 table and answers (g)–(i). (15 points)
   - 2e. AI use disclosure. (5 points)

Raw terminal output is fine for the tables — screenshots or copy-pasted text
both work.

## RB Questions/Reflection

These are not required, but worth thinking about:

- Every element of the matrix gets read exactly once and written exactly once,
  no matter what `lda` is. The instruction count barely changes. Where does a
  4x difference in running time come from, if not from doing more work?
- Tiling is the textbook fix for a slow transpose, and it is real — but on this
  machine a padded naive transpose beats the best tile size. When would you
  still reach for tiling?
- Your formula depends on the line size, the set count, and the element size.
  If you switched from `double` to `float`, which rows of your table would
  change, and which would not?
