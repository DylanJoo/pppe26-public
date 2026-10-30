# Activity 3 — Vectorizing a Table Lookup: Hex Encoding with a Byte Shuffle

(drafted with Claude)

## Background

Lecture 04 replaced a computation with a lookup table, and Lecture 07 showed
what a vector register can do with arithmetic and compares. This activity puts
the two together. The question is: **can a vector unit look things up in a
table?**

For a small enough table it can, and the instruction that does it is one of the
most useful in the whole vector instruction set. On x86 it is `vpshufb`
(`_mm256_shuffle_epi8`); on Arm it is `tbl` (`vqtbl1q_u8`). NEON treats one
vector register as a **16-entry table of bytes** and another as 16 **indices**.
AVX2 does this independently in each 128-bit half, for 32 lookups total. They
replace every index with the table entry it points to:

```
table    | '0' '1' '2' '3' '4' '5' '6' '7' '8' '9' 'a' 'b' 'c' 'd' 'e' 'f' |
indices  |  7   10   0   15  ...                                          |
result   | '7' 'a'  '0' 'f'  ...                                          |
```

Sixteen lookups per 128-bit block, one instruction, no table memory access. Notice that this moves data
*between* lanes — the result in lane 1 came from lane 10 of the table — which
the arithmetic you have seen so far never does.

The problem we will use it on is **hex encoding**: turning each byte into the
two characters that spell it, so `0x7a` becomes `"7a"`. Each byte splits into
two 4-bit **nibbles**, and each nibble is looked up in a 16-entry table:

```cpp
static const uint8_t HEX[16] = {'0','1','2','3','4','5','6','7',
                                '8','9','a','b','c','d','e','f'};

void to_hex(const uint8_t* in, size_t n, char* out) {
  for (size_t i = 0; i < n; i++) {
    out[2 * i]     = HEX[in[i] >> 4];   // high nibble first
    out[2 * i + 1] = HEX[in[i] & 15];   // then low nibble
  }
}
```

The table is exactly sixteen bytes — one 128-bit register. You will investigate
whether your compiler notices this, and then write an explicit shuffle version.
Compiler behavior can change with version and flags; report what you observe.

## Getting started

Two files come with this assignment:

* [`activity3.vectorization.starter.cpp`](activity3.vectorization.starter.cpp)
  — the harness. Rename it to `activity3_hex.cpp` and work in it.
* This handout.

The harness has the scalar `to_hex` already. On Linux it requests a fixed core;
on macOS it requests performance-core scheduling through QoS (not a fixed
core). It warms the clock, **checks your versions against the scalar one** at every length from
0 to 300, and times every version that passes at five input sizes. **You write
exactly two functions:** `to_hex_simd` with intrinsics for your machine, and
`to_hex_highway` with Google Highway.

**Install Highway** if you do not have it. It is required to complete Part 4;
the harness can run Parts 1–3 without it (omit `-lhwy` from the build command):

```bash
sudo apt install libhwy-dev     # Ubuntu / Pop!_OS
brew install highway            # macOS
```

**Build:**

```bash
# Linux, x86-64
g++ -O3 -std=c++17 -mavx2 -mbmi -mbmi2 -mfma -mf16c -maes -mpclmul \
    activity3_hex.cpp -o activity3 -lhwy

# macOS, Apple silicon
clang++ -O3 -std=c++17 -I/opt/homebrew/include -L/opt/homebrew/lib \
    activity3_hex.cpp -o activity3 -lhwy

./activity3
```

The long list of `-m` flags on x86 is not decoration. Highway chooses its
instruction set from those flags, and `-mavx2` alone is **not** enough for it to
choose AVX2 — it silently falls back to a 16-byte target and runs at half
width. The program prints the target Highway selected. On x86 it should say
`AVX2, 32 byte lanes per vector`; on a Mac, `NEON, 16 byte lanes per vector`.

Run the starter as given before you change anything. It builds, reports
`simd: not implemented yet` and `highway: not implemented yet`, and times the
scalar version alone.

> **If your version is wrong**, the harness tells you the first length and the
> first output character where it differs from the scalar version, and leaves
> it out of the timing table. The position of that first wrong character is
> usually the best clue you have.

Record your CPU model, operating system, compiler version, build flags, and
Highway target with your results. Close other CPU-heavy programs and keep the
machine plugged in. Timings and compiler reports may differ from other machines.
The x86 build requires a CPU supporting the listed instruction sets.

The function contract is: read exactly `n` input bytes and write exactly `2*n`
lowercase hex characters into a separate output buffer. No terminating NUL is
required. Handle `n = 0`, unaligned buffers, and leftover bytes after full vectors.

## Part 1 — Ask the compiler (10 points)

Ask the compiler what it did with the scalar loop: both gcc and clang on
Linux, clang alone on a Mac. Find the line number of `to_hex`'s loop in your
file and look for it in the output:

```bash
# Linux, x86-64
g++     -O3 -std=c++17 -mavx2 -fopt-info-vec-all -c activity3_hex.cpp -o /dev/null
clang++ -O3 -std=c++17 -mavx2 -Rpass=loop-vectorize -Rpass-missed=loop-vectorize \
        -c activity3_hex.cpp -o /dev/null

# macOS, Apple silicon
clang++ -O3 -std=c++17 -I/opt/homebrew/include \
        -Rpass=loop-vectorize -Rpass-missed=loop-vectorize \
        -c activity3_hex.cpp -o /dev/null
```

> **If clang on Linux says `'atomic' file not found`** (or `'chrono'`, or
> another standard header): on Ubuntu and Pop!_OS 24.04, clang picks GCC 14's
> library directory, but only GCC 13's C++ headers are installed. Run
> `sudo apt install libstdc++-14-dev`, or add `-stdlib=libc++` to every clang
> command.

**(a)** What does each compiler report for the `to_hex` loop? Copy the line.
Did it report the loop as vectorized?

==
gcc reports
> activity3_hex.cpp:124:24: missed: couldn't vectorize loop
> activity3_hex.cpp:125:36: missed: not vectorized: not suitable for gather load _5 = HEX[_4];
> didn't vectorize

clang reports
> activity3_hex.cpp:124:3: remark: vectorized loop (vectorization width: 32, interleaved count: 1) [-Rpass=loop-vectorize]
> it was vectorized. 32 bytes per iteration
==

**(b)** Now look at the assembly clang actually generated for `to_hex`. Paste
just the scalar function into [Compiler Explorer](https://godbolt.org/) with
the same flags, or generate it yourself and find the function, whose name is
mangled as `_Z6to_hexPKhmPc`:

```bash
clang++ -O3 -std=c++17 -mavx2 -masm=intel -S activity3_hex.cpp            # x86-64
clang++ -O3 -std=c++17 -I/opt/homebrew/include -S activity3_hex.cpp       # Apple silicon
```

How many shuffle instructions (`vpshufb` on x86, `tbl` on Arm) are in it?
Which instructions implement the table lookups?

==
> 0 vpshufb instruction in clang's to_hex. 
> The table lookups are done by movzx and vpinsrb instructions that read the HEX table (_ZL3HEX).
> 
> 49:     movzx   edx, byte ptr [rdx + _ZL3HEX]
> ...
> 159:    vpinsrb xmm0, xmm0, byte ptr [rdx + _ZL3HEX], 1
> ...
> 200:    vpinsrb xmm0, xmm0, byte ptr [rdx + _ZL3HEX], 13
> ...
==

**(c)** Whatever the report in (a) said, did the compiler vectorize this loop
in any way that matters for speed? Explain in two or three sentences what
happened to the table lookups.

==
No. the lookup table stil processes one byte at a time. It's still going to memory like scalar loop
==

## Part 2 — Predict, before you write anything (10 points)

Fill in this table for your machine **before** you write any vector code.

| Quantity | Value |
|---|---|
| Vector register width (bits) | 256 |
| Bytes per vector register | 32 |
| Input bytes per loop iteration | 32 |
| Ideal speedup from lane count alone | 32x |
| Your predicted speedup at 16 KiB | ~18x |

**(d)** Justify your predicted speedup. Count the loads and stores the scalar
loop does per input byte, and estimate how many instructions the vector loop
needs per register of input. Is your prediction above or below the lane-count
estimate, and why?

==
Difference of instructions:
- one-by-one: Load byte (1) --> shift (2) --> load from HEX (2) --> store character (2) + loop (1) = 8
- vectorize: 1 + 2 + look up with shuffle (2) + interleave> (4) + store char (2) + loop (3) = 14

8 * 32 / 14 = 18.2857
==

## Part 3 — Write `to_hex_simd` (25 points for code + 10 points)

Write `to_hex_simd` for your machine — AVX2 on x86, NEON on Apple silicon. The
starter lists the intrinsics you need above each function. The loop has the
same shape as every hand-written vector loop in Lecture 07: whole vectors while
they fit, then the scalar `to_hex` for the leftover bytes. Inside the loop there
are five steps:

1. **Load** a register of input bytes.
2. **Split** every byte into its high nibble and its low nibble.
3. **Look up** both nibble vectors in the table — one shuffle each.
4. **Interleave** the two results, so each high character is followed by its
   low character.
5. **Store** twice as many bytes as you loaded.

Read the documentation for every intrinsic you use, and pay attention to the
word **lane**. Several x86 instructions that look like they operate on a whole
256-bit register in fact operate on its two 128-bit halves separately.

Keep going until the harness reports `simd: agrees with scalar`.

**(e)** How does your version split a byte into nibbles? Which instructions did
you use, and why is a mask needed after the shift — or, if your machine needs
none, why not?

==
> Split each byte with _mm256_srli_epi16(bytes, 4): 
> _mm256_and_si256(..., mask) for high and low nibble (with mask).
> Because AVX2 has no 8 bit shift so use 16 bit shift. Without mask.
> The index would be larger than 15.
==

**(f)** How does your version get the output characters into the right order?
If you are on x86: what does the output look like if you leave out the final
permute, and at which output character does the harness first report a
difference? If you are on Arm: what does `vst2q_u8` do, and what would you have
had to write without it?

==
After two shuffles, we have two registers, each holding 32 chars. The interleaved version pairs high-nibble and low-nibble characters. They work within each 128 bit half separatetly. 

Leaving out final permute would make each 64 character block has its middle two 16 character pieces swapped, which is the wrong order.

This machine is using AMD x86.
==

## Part 4 — Write `to_hex_highway` (15 points for code + 5 points)

Write the same algorithm with Highway. Use only `hn::` operations — no x86 or
Arm intrinsics — so the same source builds on both supported architectures. The starter lists
the operations you need; Highway's [quick reference](https://google.github.io/highway/en/master/quick_reference.html) documents them.

**(g)** Compare your two versions: how many lines is each loop body, and how
does the speed compare? What did `hn::StoreInterleaved2` do for you, and which
step of Part 3 does it replace?

==
> to_hex_simd: 11 lines; to_hex_highway: 4 lines
> The speed is the same because highway isnt doing anything in the run time. They run at the same speed: 0.0440 ns/byte.
> It replaces step 4 interleave along with two stores of steps 5.
==

## Part 5 — Measure (20 points)

Run the finished program and fill in the table:

| input | scalar ns/byte | simd ns/byte | highway ns/byte | simd speedup | highway speedup |
|---|---|---|---|---|---|
| 1 KiB   | 0.7966 | 0.0353 | 0.0358 | 22.6x | 22.3x |
| 16 KiB  | 0.8057 | 0.0441 | 0.0440 | 18.3x | 18.3x | 
| 256 KiB | 0.8060 | 0.0549 | 0.0545 | 14.7x | 14.8x |
| 4 MiB   | 0.8100 | 0.0576 | 0.0571 | 14.1x | 14.2x |
| 64 MiB  | 0.8098 | 0.1164 | 0.1162 | 7.0x  | 7.0x  |

**(h)** How close did your prediction from Part 2 come at 16 KiB? If you were
off, what did you miss? Is the measured speedup below or above your lane-count estimate? Explain
using instruction overhead and, where relevant, memory bandwidth. Lane count
alone is a model, not a strict bound on speedup over this scalar implementation.

==
Predictio is very close (18x)
Similar speedup but way slower than my original intuition (32x). The speed up is smaller than 32 because there are some instruction overhead for vectorization.
For example, mask, permutation, interleave, which might be different from the scalar version.

The speedup also depends on size because of memory bandwidth.
==

## Part 6 — AI Use Disclosure (5 points)

State whether you used AI tools for this assignment. If you did, name the tools
and briefly describe how you used them. Full credit is earned at every level of
use; the course was designed with AI as a partner in mind.

==
Yes. I used Claude Code (Anthropic, model Claude Opus 5.5) as a tutor and implementation assistant throughout this assignment.
I draft my answer (~part 4) or ask hints from claude. Then, discuss with claude to refine my answer if the answer is incorrect or not precise enough.
==

## What to submit

1. Your completed `activity3_hex.cpp`, with `to_hex_simd` and `to_hex_highway`
   implemented and passing the harness. (40 points: 25 for `to_hex_simd`, 15
   for `to_hex_highway`)
2. A document with your written answers:
   - 3a. Answers (a)–(c). (10 points)
   - 3b. Part 2 table and answer (d). (10 points)
   - 3c. Answers (e)–(f). (10 points)
   - 3d. Answer (g). (5 points)
   - 3e. Part 5 table and answer (h). (20 points)
   - 3f. AI use disclosure. (5 points)

Raw terminal output is fine for the tables — screenshots or copy-pasted text
both work.

## RB Questions/Reflection

Not required, but worth thinking about:

- The compiler had everything it needed: a constant 16-entry table and indices
  that provably fit in 4 bits. Why do you think it still did not use a shuffle?
- A 16-entry table fits one register. What would you do with a 256-entry table?
  (AVX-512's `vpermb` and Arm's `tbl` with four registers each take a 64-byte
  table. Look them up.)
- Hex *decoding* — two characters back to one byte — has to reject input that
  is not a hex digit. How would you detect a bad character with vector
  instructions, without a branch per byte?
