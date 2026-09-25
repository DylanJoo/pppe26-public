	.file	"activity1_pipeline.cpp"
                                        # Start of file scope inline assembly
	.globl	_ZSt21ios_base_library_initv

                                        # End of file scope inline assembly
	.text
	.globl	_Z10noTempVarsRSt6vectorIiSaIiEE # -- Begin function _Z10noTempVarsRSt6vectorIiSaIiEE
	.p2align	4
	.type	_Z10noTempVarsRSt6vectorIiSaIiEE,@function
_Z10noTempVarsRSt6vectorIiSaIiEE:       # @_Z10noTempVarsRSt6vectorIiSaIiEE
	.cfi_startproc
# %bb.0:
	movq	(%rdi), %rcx
	movl	$1, %eax
	movq	$-4, %rdx
	.p2align	4
.LBB0_1:                                # =>This Inner Loop Header: Depth=1
	movslq	16(%rcx,%rdx,4), %rsi
	orq	$1, %rsi
	imulq	%rax, %rsi
	movslq	20(%rcx,%rdx,4), %rax
	orq	$1, %rax
	movslq	24(%rcx,%rdx,4), %rdi
	orq	$1, %rdi
	imulq	%rax, %rdi
	imulq	%rsi, %rdi
	movslq	28(%rcx,%rdx,4), %rax
	orq	$1, %rax
	imulq	%rdi, %rax
	addq	$4, %rdx
	cmpq	$99999996, %rdx                 # imm = 0x5F5E0FC
	jb	.LBB0_1
# %bb.2:
	retq
.Lfunc_end0:
	.size	_Z10noTempVarsRSt6vectorIiSaIiEE, .Lfunc_end0-_Z10noTempVarsRSt6vectorIiSaIiEE
	.cfi_endproc
                                        # -- End function
	.globl	_Z12withTempVarsRSt6vectorIiSaIiEE # -- Begin function _Z12withTempVarsRSt6vectorIiSaIiEE
	.p2align	4
	.type	_Z12withTempVarsRSt6vectorIiSaIiEE,@function
_Z12withTempVarsRSt6vectorIiSaIiEE:     # @_Z12withTempVarsRSt6vectorIiSaIiEE
	.cfi_startproc
# %bb.0:
	movq	(%rdi), %rsi
	movl	$1, %ecx
	movq	$-4, %rdi
	movl	$1, %eax
	movl	$1, %edx
	movl	$1, %r8d
	.p2align	4
.LBB1_1:                                # =>This Inner Loop Header: Depth=1
	movslq	16(%rsi,%rdi,4), %r9
	orq	$1, %r9
	imulq	%r9, %rcx
	movslq	20(%rsi,%rdi,4), %r9
	orq	$1, %r9
	imulq	%r9, %rax
	movslq	24(%rsi,%rdi,4), %r9
	orq	$1, %r9
	imulq	%r9, %rdx
	movslq	28(%rsi,%rdi,4), %r9
	orq	$1, %r9
	imulq	%r9, %r8
	addq	$4, %rdi
	cmpq	$99999996, %rdi                 # imm = 0x5F5E0FC
	jb	.LBB1_1
# %bb.2:
	imulq	%r8, %rdx
	imulq	%rcx, %rax
	imulq	%rdx, %rax
	retq
.Lfunc_end1:
	.size	_Z12withTempVarsRSt6vectorIiSaIiEE, .Lfunc_end1-_Z12withTempVarsRSt6vectorIiSaIiEE
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0                          # -- Begin function main
.LCPI2_0:
	.long	0                               # 0x0
	.long	1                               # 0x1
	.long	2                               # 0x2
	.long	3                               # 0x3
.LCPI2_1:
	.long	4                               # 0x4
	.long	4                               # 0x4
	.long	4                               # 0x4
	.long	4                               # 0x4
.LCPI2_2:
	.long	1374389535                      # 0x51eb851f
	.long	1374389535                      # 0x51eb851f
	.long	1374389535                      # 0x51eb851f
	.long	1374389535                      # 0x51eb851f
.LCPI2_3:
	.long	100                             # 0x64
	.long	100                             # 0x64
	.long	100                             # 0x64
	.long	100                             # 0x64
.LCPI2_4:
	.long	8                               # 0x8
	.long	8                               # 0x8
	.long	8                               # 0x8
	.long	8                               # 0x8
	.text
	.globl	main
	.p2align	4
	.type	main,@function
main:                                   # @main
.Lfunc_begin0:
	.cfi_startproc
	.cfi_personality 3, __gxx_personality_v0
	.cfi_lsda 3, .Lexception0
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$136, %rsp
	.cfi_def_cfa_offset 192
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movl	$_ZSt4cout, %edi
	movl	$.L.str, %esi
	movl	$44, %edx
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	movq	_ZSt4cout(%rip), %rax
	movq	-24(%rax), %rax
	movq	_ZSt4cout+240(%rax), %rbx
	testq	%rbx, %rbx
	je	.LBB2_94
# %bb.1:
	cmpb	$0, 56(%rbx)
	je	.LBB2_3
# %bb.2:
	movzbl	67(%rbx), %eax
	jmp	.LBB2_4
.LBB2_3:
	movq	%rbx, %rdi
	callq	_ZNKSt5ctypeIcE13_M_widen_initEv
	movq	(%rbx), %rax
	movq	%rbx, %rdi
	movl	$10, %esi
	callq	*48(%rax)
.LBB2_4:
	movsbl	%al, %esi
	movl	$_ZSt4cout, %edi
	callq	_ZNSo3putEc
	movq	%rax, %rdi
	callq	_ZNSo5flushEv
	movl	$_ZSt4cout, %edi
	movl	$.L.str.1, %esi
	movl	$12, %edx
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	movl	$_ZSt4cout, %edi
	movl	$100000000, %esi                # imm = 0x5F5E100
	callq	_ZNSolsEi
	movq	%rax, %rbx
	movl	$.L.str.2, %esi
	movl	$10, %edx
	movq	%rax, %rdi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	movq	(%rbx), %rax
	movq	-24(%rax), %rax
	movq	240(%rbx,%rax), %r14
	testq	%r14, %r14
	je	.LBB2_94
# %bb.5:
	cmpb	$0, 56(%r14)
	je	.LBB2_7
# %bb.6:
	movzbl	67(%r14), %eax
	jmp	.LBB2_8
.LBB2_7:
	movq	%r14, %rdi
	callq	_ZNKSt5ctypeIcE13_M_widen_initEv
	movq	(%r14), %rax
	movq	%r14, %rdi
	movl	$10, %esi
	callq	*48(%rax)
.LBB2_8:
	movsbl	%al, %esi
	movq	%rbx, %rdi
	callq	_ZNSo3putEc
	movq	%rax, %rdi
	callq	_ZNSo5flushEv
	movl	$400000000, %edi                # imm = 0x17D78400
	callq	_Znwm
	movq	%rax, %rbx
	movl	$400000000, %edx                # imm = 0x17D78400
	movq	%rax, %rdi
	xorl	%esi, %esi
	callq	memset@PLT
	movdqa	.LCPI2_0(%rip), %xmm0           # xmm0 = [0,1,2,3]
	movl	$4, %eax
	movdqa	.LCPI2_1(%rip), %xmm1           # xmm1 = [4,4,4,4]
	movdqa	.LCPI2_2(%rip), %xmm2           # xmm2 = [1374389535,1374389535,1374389535,1374389535]
	movdqa	.LCPI2_3(%rip), %xmm3           # xmm3 = [100,100,100,100]
	pcmpeqd	%xmm4, %xmm4
	movdqa	.LCPI2_4(%rip), %xmm5           # xmm5 = [8,8,8,8]
	.p2align	4
.LBB2_9:                                # =>This Inner Loop Header: Depth=1
	movdqa	%xmm0, %xmm6
	paddd	%xmm1, %xmm6
	movdqa	%xmm0, %xmm7
	pmuludq	%xmm2, %xmm7
	pshufd	$237, %xmm7, %xmm7              # xmm7 = xmm7[1,3,2,3]
	pshufd	$245, %xmm0, %xmm8              # xmm8 = xmm0[1,1,3,3]
	pmuludq	%xmm2, %xmm8
	pshufd	$237, %xmm8, %xmm8              # xmm8 = xmm8[1,3,2,3]
	punpckldq	%xmm8, %xmm7            # xmm7 = xmm7[0],xmm8[0],xmm7[1],xmm8[1]
	psrld	$5, %xmm7
	pshufd	$245, %xmm7, %xmm8              # xmm8 = xmm7[1,1,3,3]
	pmuludq	%xmm3, %xmm7
	pshufd	$232, %xmm7, %xmm7              # xmm7 = xmm7[0,2,2,3]
	pmuludq	%xmm3, %xmm8
	pshufd	$232, %xmm8, %xmm8              # xmm8 = xmm8[0,2,2,3]
	punpckldq	%xmm8, %xmm7            # xmm7 = xmm7[0],xmm8[0],xmm7[1],xmm8[1]
	movdqa	%xmm0, %xmm8
	psubd	%xmm7, %xmm8
	movdqa	%xmm6, %xmm7
	pmuludq	%xmm2, %xmm7
	pshufd	$237, %xmm7, %xmm7              # xmm7 = xmm7[1,3,2,3]
	pshufd	$245, %xmm6, %xmm9              # xmm9 = xmm6[1,1,3,3]
	pmuludq	%xmm2, %xmm9
	pshufd	$237, %xmm9, %xmm9              # xmm9 = xmm9[1,3,2,3]
	punpckldq	%xmm9, %xmm7            # xmm7 = xmm7[0],xmm9[0],xmm7[1],xmm9[1]
	psrld	$5, %xmm7
	pshufd	$245, %xmm7, %xmm9              # xmm9 = xmm7[1,1,3,3]
	pmuludq	%xmm3, %xmm7
	pshufd	$232, %xmm7, %xmm7              # xmm7 = xmm7[0,2,2,3]
	pmuludq	%xmm3, %xmm9
	pshufd	$232, %xmm9, %xmm9              # xmm9 = xmm9[0,2,2,3]
	punpckldq	%xmm9, %xmm7            # xmm7 = xmm7[0],xmm9[0],xmm7[1],xmm9[1]
	psubd	%xmm7, %xmm6
	psubd	%xmm4, %xmm8
	psubd	%xmm4, %xmm6
	movdqu	%xmm8, -16(%rbx,%rax,4)
	movdqu	%xmm6, (%rbx,%rax,4)
	paddd	%xmm5, %xmm0
	addq	$8, %rax
	cmpq	$100000004, %rax                # imm = 0x5F5E104
	jne	.LBB2_9
# %bb.10:
	#APP
	#NO_APP
	movl	$1, %ecx
	movq	$-4, %rax
	.p2align	4
.LBB2_11:                               # =>This Inner Loop Header: Depth=1
	movslq	16(%rbx,%rax,4), %rdx
	orq	$1, %rdx
	imulq	%rcx, %rdx
	movslq	20(%rbx,%rax,4), %rcx
	orq	$1, %rcx
	movslq	24(%rbx,%rax,4), %rsi
	orq	$1, %rsi
	imulq	%rcx, %rsi
	imulq	%rdx, %rsi
	movslq	28(%rbx,%rax,4), %rcx
	orq	$1, %rcx
	imulq	%rsi, %rcx
	addq	$4, %rax
	cmpq	$99999996, %rax                 # imm = 0x5F5E0FC
	jb	.LBB2_11
# %bb.12:
	movq	%rcx, 88(%rsp)
	movl	$1, %eax
	movq	$-4, %rsi
	movl	$1, %ecx
	movl	$1, %edx
	movl	$1, %edi
	.p2align	4
.LBB2_13:                               # =>This Inner Loop Header: Depth=1
	movslq	16(%rbx,%rsi,4), %r8
	orq	$1, %r8
	imulq	%r8, %rax
	movslq	20(%rbx,%rsi,4), %r8
	orq	$1, %r8
	imulq	%r8, %rcx
	movslq	24(%rbx,%rsi,4), %r8
	orq	$1, %r8
	imulq	%r8, %rdx
	movslq	28(%rbx,%rsi,4), %r8
	orq	$1, %r8
	imulq	%r8, %rdi
	addq	$4, %rsi
	cmpq	$99999996, %rsi                 # imm = 0x5F5E0FC
	jb	.LBB2_13
# %bb.14:
	imulq	%rax, %rcx
	imulq	%rdi, %rdx
	imulq	%rcx, %rdx
	addq	%rdx, 88(%rsp)
	movq	88(%rsp), %rax
	#APP
	#NO_APP
	callq	_ZNSt6chrono3_V212system_clock3nowEv
	movq	%rax, %r14
	#APP
	#NO_APP
	movl	$1, %r15d
	movq	$-4, %rax
	.p2align	4
.LBB2_15:                               # =>This Inner Loop Header: Depth=1
	movslq	16(%rbx,%rax,4), %rcx
	orq	$1, %rcx
	imulq	%r15, %rcx
	movslq	20(%rbx,%rax,4), %rdx
	orq	$1, %rdx
	movslq	24(%rbx,%rax,4), %rsi
	orq	$1, %rsi
	imulq	%rdx, %rsi
	imulq	%rcx, %rsi
	movslq	28(%rbx,%rax,4), %r15
	orq	$1, %r15
	imulq	%rsi, %r15
	addq	$4, %rax
	cmpq	$99999996, %rax                 # imm = 0x5F5E0FC
	jb	.LBB2_15
# %bb.16:
	#APP
	#NO_APP
	callq	_ZNSt6chrono3_V212system_clock3nowEv
	movq	%rax, %r12
	#APP
	#NO_APP
	#APP
	#NO_APP
	callq	_ZNSt6chrono3_V212system_clock3nowEv
	movq	%rax, 8(%rsp)                   # 8-byte Spill
	#APP
	#NO_APP
	movl	$1, %ebp
	movq	$-4, %rax
	.p2align	4
.LBB2_17:                               # =>This Inner Loop Header: Depth=1
	movslq	16(%rbx,%rax,4), %rcx
	orq	$1, %rcx
	imulq	%rbp, %rcx
	movslq	20(%rbx,%rax,4), %rdx
	orq	$1, %rdx
	movslq	24(%rbx,%rax,4), %rsi
	orq	$1, %rsi
	imulq	%rdx, %rsi
	imulq	%rcx, %rsi
	movslq	28(%rbx,%rax,4), %rbp
	orq	$1, %rbp
	imulq	%rsi, %rbp
	addq	$4, %rax
	cmpq	$99999996, %rax                 # imm = 0x5F5E0FC
	jb	.LBB2_17
# %bb.18:
	subq	%r14, %r12
	movabsq	$4835703278458516699, %rcx      # imm = 0x431BDE82D7B634DB
	movq	%r12, %rax
	imulq	%rcx
	movq	%rdx, %r13
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$18, %r13
	addq	%rax, %r13
	#APP
	#NO_APP
	callq	_ZNSt6chrono3_V212system_clock3nowEv
	movq	%rax, %r12
	#APP
	#NO_APP
	#APP
	#NO_APP
	callq	_ZNSt6chrono3_V212system_clock3nowEv
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	#APP
	#NO_APP
	movl	$1, %r14d
	movq	$-4, %rax
	.p2align	4
.LBB2_19:                               # =>This Inner Loop Header: Depth=1
	movslq	16(%rbx,%rax,4), %rcx
	orq	$1, %rcx
	imulq	%r14, %rcx
	movslq	20(%rbx,%rax,4), %rdx
	orq	$1, %rdx
	movslq	24(%rbx,%rax,4), %rsi
	orq	$1, %rsi
	imulq	%rdx, %rsi
	imulq	%rcx, %rsi
	movslq	28(%rbx,%rax,4), %r14
	orq	$1, %r14
	imulq	%rsi, %r14
	addq	$4, %rax
	cmpq	$99999996, %rax                 # imm = 0x5F5E0FC
	jb	.LBB2_19
# %bb.20:
	addq	%r15, %rbp
	subq	8(%rsp), %r12                   # 8-byte Folded Reload
	movq	%r12, %rax
	movabsq	$4835703278458516699, %rcx      # imm = 0x431BDE82D7B634DB
	imulq	%rcx
	movq	%rdx, %r12
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$18, %r12
	addq	%rax, %r12
	cmpq	%r13, %r12
	cmovgeq	%r13, %r12
	#APP
	#NO_APP
	callq	_ZNSt6chrono3_V212system_clock3nowEv
	movq	%rax, %r13
	#APP
	#NO_APP
	#APP
	#NO_APP
	callq	_ZNSt6chrono3_V212system_clock3nowEv
	movq	%rax, 128(%rsp)                 # 8-byte Spill
	#APP
	#NO_APP
	movq	%rbx, %r15
	movl	$1, %ebx
	movq	$-4, %rax
	.p2align	4
.LBB2_21:                               # =>This Inner Loop Header: Depth=1
	movslq	16(%r15,%rax,4), %rcx
	orq	$1, %rcx
	imulq	%rbx, %rcx
	movslq	20(%r15,%rax,4), %rdx
	orq	$1, %rdx
	movslq	24(%r15,%rax,4), %rsi
	orq	$1, %rsi
	imulq	%rdx, %rsi
	imulq	%rcx, %rsi
	movslq	28(%r15,%rax,4), %rbx
	orq	$1, %rbx
	imulq	%rsi, %rbx
	addq	$4, %rax
	cmpq	$99999996, %rax                 # imm = 0x5F5E0FC
	jb	.LBB2_21
# %bb.22:
	addq	%rbp, %r14
	subq	16(%rsp), %r13                  # 8-byte Folded Reload
	movq	%r13, %rax
	movabsq	$4835703278458516699, %rcx      # imm = 0x431BDE82D7B634DB
	imulq	%rcx
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$18, %rdx
	addq	%rax, %rdx
	cmpq	%r12, %rdx
	cmovgeq	%r12, %rdx
	movq	%rdx, 120(%rsp)                 # 8-byte Spill
	#APP
	#NO_APP
	callq	_ZNSt6chrono3_V212system_clock3nowEv
	movq	%rax, 104(%rsp)                 # 8-byte Spill
	#APP
	#NO_APP
	#APP
	#NO_APP
	callq	_ZNSt6chrono3_V212system_clock3nowEv
	movq	%rax, 112(%rsp)                 # 8-byte Spill
	#APP
	#NO_APP
	movl	$1, %r12d
	movq	$-4, %rax
	.p2align	4
.LBB2_23:                               # =>This Inner Loop Header: Depth=1
	movslq	16(%r15,%rax,4), %rcx
	orq	$1, %rcx
	imulq	%r12, %rcx
	movslq	20(%r15,%rax,4), %rdx
	orq	$1, %rdx
	movslq	24(%r15,%rax,4), %rsi
	orq	$1, %rsi
	imulq	%rdx, %rsi
	imulq	%rcx, %rsi
	movslq	28(%r15,%rax,4), %r12
	orq	$1, %r12
	imulq	%rsi, %r12
	addq	$4, %rax
	cmpq	$99999996, %rax                 # imm = 0x5F5E0FC
	jb	.LBB2_23
# %bb.24:
	addq	%r14, %rbx
	addq	%rbx, %r12
	#APP
	#NO_APP
	callq	_ZNSt6chrono3_V212system_clock3nowEv
	movq	%rax, 96(%rsp)                  # 8-byte Spill
	#APP
	#NO_APP
	movq	%r12, 80(%rsp)                  # 8-byte Spill
	movq	%r12, 40(%rsp)
	movq	40(%rsp), %rax
	#APP
	#NO_APP
	callq	_ZNSt6chrono3_V212system_clock3nowEv
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	#APP
	#NO_APP
	movl	$1, %ebx
	movq	$-4, %rax
	movl	$1, %edx
	movl	$1, %r12d
	movl	$1, %r14d
	.p2align	4
.LBB2_25:                               # =>This Inner Loop Header: Depth=1
	movslq	16(%r15,%rax,4), %rcx
	orq	$1, %rcx
	imulq	%rcx, %rbx
	movslq	20(%r15,%rax,4), %rcx
	orq	$1, %rcx
	imulq	%rcx, %rdx
	movslq	24(%r15,%rax,4), %rcx
	orq	$1, %rcx
	imulq	%rcx, %r12
	movslq	28(%r15,%rax,4), %rcx
	orq	$1, %rcx
	imulq	%rcx, %r14
	addq	$4, %rax
	cmpq	$99999996, %rax                 # imm = 0x5F5E0FC
	jb	.LBB2_25
# %bb.26:
	movq	%rdx, 32(%rsp)                  # 8-byte Spill
	#APP
	#NO_APP
	callq	_ZNSt6chrono3_V212system_clock3nowEv
	movq	%rax, 24(%rsp)                  # 8-byte Spill
	#APP
	#NO_APP
	#APP
	#NO_APP
	callq	_ZNSt6chrono3_V212system_clock3nowEv
	movq	%rax, 72(%rsp)                  # 8-byte Spill
	#APP
	#NO_APP
	movl	$1, %esi
	movq	$-4, %rax
	movl	$1, %edx
	movl	$1, %r13d
	movl	$1, %ebp
	.p2align	4
.LBB2_27:                               # =>This Inner Loop Header: Depth=1
	movslq	16(%r15,%rax,4), %rcx
	orq	$1, %rcx
	imulq	%rcx, %rsi
	movslq	20(%r15,%rax,4), %rcx
	orq	$1, %rcx
	imulq	%rcx, %rdx
	movslq	24(%r15,%rax,4), %rcx
	orq	$1, %rcx
	imulq	%rcx, %r13
	movslq	28(%r15,%rax,4), %rcx
	orq	$1, %rcx
	imulq	%rcx, %rbp
	addq	$4, %rax
	cmpq	$99999996, %rax                 # imm = 0x5F5E0FC
	jb	.LBB2_27
# %bb.28:
	movq	%rsi, 56(%rsp)                  # 8-byte Spill
	movq	%rdx, 8(%rsp)                   # 8-byte Spill
	movq	32(%rsp), %rax                  # 8-byte Reload
	imulq	%rbx, %rax
	imulq	%r12, %rax
	imulq	%r14, %rax
	movq	%rax, 32(%rsp)                  # 8-byte Spill
	movq	24(%rsp), %rax                  # 8-byte Reload
	subq	16(%rsp), %rax                  # 8-byte Folded Reload
	movabsq	$4835703278458516699, %rcx      # imm = 0x431BDE82D7B634DB
	imulq	%rcx
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$18, %rdx
	addq	%rax, %rdx
	movq	%rdx, 48(%rsp)                  # 8-byte Spill
	#APP
	#NO_APP
	callq	_ZNSt6chrono3_V212system_clock3nowEv
	movq	%rax, %r14
	#APP
	#NO_APP
	#APP
	#NO_APP
	callq	_ZNSt6chrono3_V212system_clock3nowEv
	movq	%rax, 24(%rsp)                  # 8-byte Spill
	#APP
	#NO_APP
	movl	$1, %esi
	movq	$-4, %rax
	movl	$1, %edx
	movl	$1, %ebx
	movl	$1, %r12d
	.p2align	4
.LBB2_29:                               # =>This Inner Loop Header: Depth=1
	movslq	16(%r15,%rax,4), %rcx
	orq	$1, %rcx
	imulq	%rcx, %rsi
	movslq	20(%r15,%rax,4), %rcx
	orq	$1, %rcx
	imulq	%rcx, %rdx
	movslq	24(%r15,%rax,4), %rcx
	orq	$1, %rcx
	imulq	%rcx, %rbx
	movslq	28(%r15,%rax,4), %rcx
	orq	$1, %rcx
	imulq	%rcx, %r12
	addq	$4, %rax
	cmpq	$99999996, %rax                 # imm = 0x5F5E0FC
	jb	.LBB2_29
# %bb.30:
	movq	%rsi, 64(%rsp)                  # 8-byte Spill
	movq	%rdx, 16(%rsp)                  # 8-byte Spill
	movq	8(%rsp), %rax                   # 8-byte Reload
	imulq	56(%rsp), %rax                  # 8-byte Folded Reload
	imulq	%r13, %rax
	imulq	%rbp, %rax
	addq	32(%rsp), %rax                  # 8-byte Folded Reload
	movq	%rax, 8(%rsp)                   # 8-byte Spill
	subq	72(%rsp), %r14                  # 8-byte Folded Reload
	movq	%r14, %rax
	movabsq	$4835703278458516699, %rcx      # imm = 0x431BDE82D7B634DB
	imulq	%rcx
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$18, %rdx
	addq	%rax, %rdx
	movq	48(%rsp), %rax                  # 8-byte Reload
	cmpq	%rax, %rdx
	cmovgeq	%rax, %rdx
	movq	%rdx, 56(%rsp)                  # 8-byte Spill
	#APP
	#NO_APP
	callq	_ZNSt6chrono3_V212system_clock3nowEv
	movq	%rax, 48(%rsp)                  # 8-byte Spill
	#APP
	#NO_APP
	#APP
	#NO_APP
	callq	_ZNSt6chrono3_V212system_clock3nowEv
	movq	%rax, 72(%rsp)                  # 8-byte Spill
	#APP
	#NO_APP
	movl	$1, %ebp
	movq	$-4, %rax
	movl	$1, %edx
	movl	$1, %r13d
	movl	$1, %r14d
	.p2align	4
.LBB2_31:                               # =>This Inner Loop Header: Depth=1
	movslq	16(%r15,%rax,4), %rcx
	orq	$1, %rcx
	imulq	%rcx, %rbp
	movslq	20(%r15,%rax,4), %rcx
	orq	$1, %rcx
	imulq	%rcx, %rdx
	movslq	24(%r15,%rax,4), %rcx
	orq	$1, %rcx
	imulq	%rcx, %r13
	movslq	28(%r15,%rax,4), %rcx
	orq	$1, %rcx
	imulq	%rcx, %r14
	addq	$4, %rax
	cmpq	$99999996, %rax                 # imm = 0x5F5E0FC
	jb	.LBB2_31
# %bb.32:
	movq	%rdx, 32(%rsp)                  # 8-byte Spill
	movq	16(%rsp), %rax                  # 8-byte Reload
	imulq	64(%rsp), %rax                  # 8-byte Folded Reload
	imulq	%rbx, %rax
	imulq	%r12, %rax
	addq	8(%rsp), %rax                   # 8-byte Folded Reload
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	movq	48(%rsp), %rax                  # 8-byte Reload
	subq	24(%rsp), %rax                  # 8-byte Folded Reload
	movabsq	$4835703278458516699, %rcx      # imm = 0x431BDE82D7B634DB
	imulq	%rcx
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$18, %rdx
	addq	%rax, %rdx
	movq	56(%rsp), %rax                  # 8-byte Reload
	cmpq	%rax, %rdx
	cmovgeq	%rax, %rdx
	movq	%rdx, 8(%rsp)                   # 8-byte Spill
	#APP
	#NO_APP
	callq	_ZNSt6chrono3_V212system_clock3nowEv
	movq	%rax, 64(%rsp)                  # 8-byte Spill
	#APP
	#NO_APP
	#APP
	#NO_APP
	callq	_ZNSt6chrono3_V212system_clock3nowEv
	movq	%rax, 24(%rsp)                  # 8-byte Spill
	#APP
	#NO_APP
	movl	$1, %ecx
	movq	$-4, %rax
	movl	$1, %esi
	movl	$1, %r12d
	movl	$1, %edi
	movq	%r15, %rbx
	.p2align	4
.LBB2_33:                               # =>This Inner Loop Header: Depth=1
	movslq	16(%rbx,%rax,4), %rdx
	orq	$1, %rdx
	imulq	%rdx, %rcx
	movslq	20(%rbx,%rax,4), %rdx
	orq	$1, %rdx
	imulq	%rdx, %rsi
	movslq	24(%rbx,%rax,4), %rdx
	orq	$1, %rdx
	imulq	%rdx, %r12
	movslq	28(%rbx,%rax,4), %rdx
	orq	$1, %rdx
	imulq	%rdx, %rdi
	addq	$4, %rax
	cmpq	$99999996, %rax                 # imm = 0x5F5E0FC
	jb	.LBB2_33
# %bb.34:
	movq	32(%rsp), %r8                   # 8-byte Reload
	imulq	%rbp, %r8
	imulq	%r13, %r8
	imulq	%r14, %r8
	addq	16(%rsp), %r8                   # 8-byte Folded Reload
	movq	64(%rsp), %rax                  # 8-byte Reload
	subq	72(%rsp), %rax                  # 8-byte Folded Reload
	movabsq	$4835703278458516699, %r15      # imm = 0x431BDE82D7B634DB
	imulq	%r15
	movq	%rdx, %r14
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$18, %r14
	addq	%rax, %r14
	movq	8(%rsp), %rax                   # 8-byte Reload
	cmpq	%rax, %r14
	cmovgeq	%rax, %r14
	imulq	%rcx, %rsi
	imulq	%rdi, %r12
	imulq	%rsi, %r12
	addq	%r8, %r12
	#APP
	#NO_APP
	callq	_ZNSt6chrono3_V212system_clock3nowEv
	#APP
	#NO_APP
	subq	24(%rsp), %rax                  # 8-byte Folded Reload
	imulq	%r15
	movq	%rdx, %rbp
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$18, %rbp
	addq	%rax, %rbp
	cmpq	%r14, %rbp
	cmovgeq	%r14, %rbp
	movq	104(%rsp), %rax                 # 8-byte Reload
	subq	128(%rsp), %rax                 # 8-byte Folded Reload
	imulq	%r15
	movq	%rdx, %rcx
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$18, %rcx
	addq	%rax, %rcx
	movq	120(%rsp), %rax                 # 8-byte Reload
	cmpq	%rax, %rcx
	cmovgeq	%rax, %rcx
	movq	96(%rsp), %rax                  # 8-byte Reload
	subq	112(%rsp), %rax                 # 8-byte Folded Reload
	imulq	%r15
	movq	%rdx, %r15
	movq	%rdx, %rax
	shrq	$63, %rax
	sarq	$18, %r15
	addq	%rax, %r15
	cmpq	%rcx, %r15
	cmovgeq	%rcx, %r15
	movq	%r12, 40(%rsp)
	movq	40(%rsp), %rax
.Ltmp0:
	movl	$_ZSt4cout, %edi
	movl	$.L.str.3, %esi
	movl	$28, %edx
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp1:
# %bb.35:
	movq	_ZSt4cout(%rip), %rax
	movq	-24(%rax), %rax
	movq	$5, _ZSt4cout+16(%rax)
.Ltmp2:
	movl	$_ZSt4cout, %edi
	movq	%r15, %rsi
	callq	_ZNSo9_M_insertIxEERSoT_
.Ltmp3:
# %bb.36:
.Ltmp4:
	movq	%rax, %r14
	movl	$.L.str.4, %esi
	movl	$3, %edx
	movq	%rax, %rdi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp5:
# %bb.37:
	movq	(%r14), %rax
	movq	-24(%rax), %rax
	movq	240(%r14,%rax), %r13
	testq	%r13, %r13
	je	.LBB2_69
# %bb.38:
	cmpb	$0, 56(%r13)
	je	.LBB2_40
# %bb.39:
	movzbl	67(%r13), %eax
	jmp	.LBB2_42
.LBB2_40:
.Ltmp6:
	movq	%r13, %rdi
	callq	_ZNKSt5ctypeIcE13_M_widen_initEv
.Ltmp7:
# %bb.41:
	movq	(%r13), %rax
.Ltmp8:
	movq	%r13, %rdi
	movl	$10, %esi
	callq	*48(%rax)
.Ltmp9:
.LBB2_42:
.Ltmp10:
	movsbl	%al, %esi
	movq	%r14, %rdi
	callq	_ZNSo3putEc
.Ltmp11:
# %bb.43:
.Ltmp12:
	movq	%rax, %rdi
	callq	_ZNSo5flushEv
.Ltmp13:
# %bb.44:
.Ltmp14:
	movl	$_ZSt4cout, %edi
	movl	$.L.str.5, %esi
	movl	$28, %edx
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp15:
# %bb.45:
	movq	_ZSt4cout(%rip), %rax
	movq	-24(%rax), %rax
	movq	$5, _ZSt4cout+16(%rax)
.Ltmp16:
	movl	$_ZSt4cout, %edi
	movq	%rbp, %rsi
	callq	_ZNSo9_M_insertIxEERSoT_
.Ltmp17:
# %bb.46:
.Ltmp18:
	movq	%rax, %r14
	movl	$.L.str.4, %esi
	movl	$3, %edx
	movq	%rax, %rdi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp19:
# %bb.47:
	movq	(%r14), %rax
	movq	-24(%rax), %rax
	movq	240(%r14,%rax), %r13
	testq	%r13, %r13
	je	.LBB2_69
# %bb.48:
	cmpb	$0, 56(%r13)
	je	.LBB2_50
# %bb.49:
	movzbl	67(%r13), %eax
	jmp	.LBB2_52
.LBB2_50:
.Ltmp20:
	movq	%r13, %rdi
	callq	_ZNKSt5ctypeIcE13_M_widen_initEv
.Ltmp21:
# %bb.51:
	movq	(%r13), %rax
.Ltmp22:
	movq	%r13, %rdi
	movl	$10, %esi
	callq	*48(%rax)
.Ltmp23:
.LBB2_52:
.Ltmp24:
	movsbl	%al, %esi
	movq	%r14, %rdi
	callq	_ZNSo3putEc
.Ltmp25:
# %bb.53:
.Ltmp26:
	movq	%rax, %rdi
	callq	_ZNSo5flushEv
.Ltmp27:
# %bb.54:
.Ltmp28:
	movl	$_ZSt4cout, %edi
	movl	$.L.str.6, %esi
	movl	$9, %edx
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp29:
# %bb.55:
	movq	_ZSt4cout(%rip), %rax
	movq	-24(%rax), %rcx
	movl	$-261, %edx                     # imm = 0xFEFB
	andl	_ZSt4cout+24(%rcx), %edx
	orl	$4, %edx
	movl	%edx, _ZSt4cout+24(%rcx)
	movq	-24(%rax), %rax
	cvtsi2sd	%r15, %xmm0
	cmpq	$2, %rbp
	movl	$1, %ecx
	cmovgeq	%rbp, %rcx
	movq	$2, _ZSt4cout+8(%rax)
	cvtsi2sd	%rcx, %xmm1
	divsd	%xmm1, %xmm0
.Ltmp30:
	movl	$_ZSt4cout, %edi
	callq	_ZNSo9_M_insertIdEERSoT_
.Ltmp31:
# %bb.56:
.Ltmp32:
	movq	%rax, %r14
	movl	$.L.str.7, %esi
	movl	$1, %edx
	movq	%rax, %rdi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp33:
# %bb.57:
	movq	(%r14), %rax
	movq	-24(%rax), %rax
	movq	240(%r14,%rax), %r15
	testq	%r15, %r15
	je	.LBB2_58
# %bb.60:
	cmpb	$0, 56(%r15)
	je	.LBB2_62
# %bb.61:
	movzbl	67(%r15), %eax
	jmp	.LBB2_64
.LBB2_62:
.Ltmp34:
	movq	%r15, %rdi
	callq	_ZNKSt5ctypeIcE13_M_widen_initEv
.Ltmp35:
# %bb.63:
	movq	(%r15), %rax
.Ltmp36:
	movq	%r15, %rdi
	movl	$10, %esi
	callq	*48(%rax)
.Ltmp37:
.LBB2_64:
.Ltmp38:
	movsbl	%al, %esi
	movq	%r14, %rdi
	callq	_ZNSo3putEc
.Ltmp39:
# %bb.65:
.Ltmp40:
	movq	%rax, %rdi
	callq	_ZNSo5flushEv
.Ltmp41:
# %bb.66:
.Ltmp42:
	movl	$_ZSt4cout, %edi
	movl	$.L.str.8, %esi
	movl	$13, %edx
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp43:
# %bb.67:
	xorl	%edx, %edx
	cmpq	%r12, 80(%rsp)                  # 8-byte Folded Reload
	sete	%dl
	movl	$.L.str.9, %eax
	movl	$.L.str.10, %esi
	cmoveq	%rax, %rsi
	orq	$2, %rdx
.Ltmp44:
	movl	$_ZSt4cout, %edi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp45:
# %bb.68:
	movq	_ZSt4cout(%rip), %rax
	movq	-24(%rax), %rax
	movq	_ZSt4cout+240(%rax), %r15
	testq	%r15, %r15
	je	.LBB2_69
# %bb.71:
	cmpb	$0, 56(%r15)
	je	.LBB2_73
# %bb.72:
	movzbl	67(%r15), %eax
	jmp	.LBB2_75
.LBB2_73:
.Ltmp46:
	movq	%r15, %rdi
	callq	_ZNKSt5ctypeIcE13_M_widen_initEv
.Ltmp47:
# %bb.74:
	movq	(%r15), %rax
.Ltmp48:
	movq	%r15, %rdi
	movl	$10, %esi
	callq	*48(%rax)
.Ltmp49:
.LBB2_75:
.Ltmp50:
	movsbl	%al, %esi
	movl	$_ZSt4cout, %edi
	callq	_ZNSo3putEc
.Ltmp51:
# %bb.76:
.Ltmp52:
	movq	%rax, %rdi
	callq	_ZNSo5flushEv
.Ltmp53:
# %bb.77:
	addq	80(%rsp), %r12                  # 8-byte Folded Reload
	movq	%r12, 40(%rsp)
.Ltmp54:
	movl	$_ZSt4cout, %edi
	movl	$.L.str.11, %esi
	movl	$11, %edx
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp55:
# %bb.78:
	movq	40(%rsp), %rsi
.Ltmp56:
	movl	$_ZSt4cout, %edi
	callq	_ZNSo9_M_insertIyEERSoT_
.Ltmp57:
# %bb.79:
.Ltmp58:
	movq	%rax, %r14
	movl	$.L.str.12, %esi
	movl	$1, %edx
	movq	%rax, %rdi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp59:
# %bb.80:
	movq	(%r14), %rax
	movq	-24(%rax), %rax
	movq	240(%r14,%rax), %r15
	testq	%r15, %r15
	je	.LBB2_81
# %bb.83:
	cmpb	$0, 56(%r15)
	je	.LBB2_85
# %bb.84:
	movzbl	67(%r15), %eax
	jmp	.LBB2_87
.LBB2_85:
.Ltmp60:
	movq	%r15, %rdi
	callq	_ZNKSt5ctypeIcE13_M_widen_initEv
.Ltmp61:
# %bb.86:
	movq	(%r15), %rax
.Ltmp62:
	movq	%r15, %rdi
	movl	$10, %esi
	callq	*48(%rax)
.Ltmp63:
.LBB2_87:
.Ltmp64:
	movsbl	%al, %esi
	movq	%r14, %rdi
	callq	_ZNSo3putEc
.Ltmp65:
# %bb.88:
.Ltmp66:
	movq	%rax, %rdi
	callq	_ZNSo5flushEv
.Ltmp67:
# %bb.89:
	movl	$400000000, %esi                # imm = 0x17D78400
	movq	%rbx, %rdi
	callq	_ZdlPvm
	xorl	%eax, %eax
	addq	$136, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.LBB2_69:
	.cfi_def_cfa_offset 192
.Ltmp74:
	callq	_ZSt16__throw_bad_castv
.Ltmp75:
# %bb.70:
.LBB2_94:
	callq	_ZSt16__throw_bad_castv
.LBB2_58:
.Ltmp71:
	callq	_ZSt16__throw_bad_castv
.Ltmp72:
# %bb.59:
.LBB2_81:
.Ltmp68:
	callq	_ZSt16__throw_bad_castv
.Ltmp69:
# %bb.82:
.LBB2_91:
.Ltmp73:
	jmp	.LBB2_93
.LBB2_92:
.Ltmp70:
	jmp	.LBB2_93
.LBB2_90:
.Ltmp76:
.LBB2_93:
	movq	%rax, %r14
	movl	$400000000, %esi                # imm = 0x17D78400
	movq	%rbx, %rdi
	callq	_ZdlPvm
	movq	%r14, %rdi
	callq	_Unwind_Resume@PLT
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
	.cfi_endproc
	.section	.gcc_except_table,"a",@progbits
	.p2align	2, 0x0
GCC_except_table2:
.Lexception0:
	.byte	255                             # @LPStart Encoding = omit
	.byte	255                             # @TType Encoding = omit
	.byte	1                               # Call site Encoding = uleb128
	.uleb128 .Lcst_end0-.Lcst_begin0
.Lcst_begin0:
	.uleb128 .Lfunc_begin0-.Lfunc_begin0    # >> Call Site 1 <<
	.uleb128 .Ltmp0-.Lfunc_begin0           #   Call between .Lfunc_begin0 and .Ltmp0
	.byte	0                               #     has no landing pad
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp0-.Lfunc_begin0           # >> Call Site 2 <<
	.uleb128 .Ltmp29-.Ltmp0                 #   Call between .Ltmp0 and .Ltmp29
	.uleb128 .Ltmp76-.Lfunc_begin0          #     jumps to .Ltmp76
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp30-.Lfunc_begin0          # >> Call Site 3 <<
	.uleb128 .Ltmp41-.Ltmp30                #   Call between .Ltmp30 and .Ltmp41
	.uleb128 .Ltmp73-.Lfunc_begin0          #     jumps to .Ltmp73
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp42-.Lfunc_begin0          # >> Call Site 4 <<
	.uleb128 .Ltmp53-.Ltmp42                #   Call between .Ltmp42 and .Ltmp53
	.uleb128 .Ltmp76-.Lfunc_begin0          #     jumps to .Ltmp76
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp54-.Lfunc_begin0          # >> Call Site 5 <<
	.uleb128 .Ltmp67-.Ltmp54                #   Call between .Ltmp54 and .Ltmp67
	.uleb128 .Ltmp70-.Lfunc_begin0          #     jumps to .Ltmp70
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp74-.Lfunc_begin0          # >> Call Site 6 <<
	.uleb128 .Ltmp75-.Ltmp74                #   Call between .Ltmp74 and .Ltmp75
	.uleb128 .Ltmp76-.Lfunc_begin0          #     jumps to .Ltmp76
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp75-.Lfunc_begin0          # >> Call Site 7 <<
	.uleb128 .Ltmp71-.Ltmp75                #   Call between .Ltmp75 and .Ltmp71
	.byte	0                               #     has no landing pad
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp71-.Lfunc_begin0          # >> Call Site 8 <<
	.uleb128 .Ltmp72-.Ltmp71                #   Call between .Ltmp71 and .Ltmp72
	.uleb128 .Ltmp73-.Lfunc_begin0          #     jumps to .Ltmp73
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp68-.Lfunc_begin0          # >> Call Site 9 <<
	.uleb128 .Ltmp69-.Ltmp68                #   Call between .Ltmp68 and .Ltmp69
	.uleb128 .Ltmp70-.Lfunc_begin0          #     jumps to .Ltmp70
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp69-.Lfunc_begin0          # >> Call Site 10 <<
	.uleb128 .Lfunc_end2-.Ltmp69            #   Call between .Ltmp69 and .Lfunc_end2
	.byte	0                               #     has no landing pad
	.byte	0                               #   On action: cleanup
.Lcst_end0:
	.p2align	2, 0x0
                                        # -- End function
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"=== Activity 1: Independent Accumulators ==="
	.size	.L.str, 45

	.type	.L.str.1,@object                # @.str.1
.L.str.1:
	.asciz	"Array size: "
	.size	.L.str.1, 13

	.type	.L.str.2,@object                # @.str.2
.L.str.2:
	.asciz	" elements\n"
	.size	.L.str.2, 11

	.type	.L.str.3,@object                # @.str.3
.L.str.3:
	.asciz	"One chain (stalled):        "
	.size	.L.str.3, 29

	.type	.L.str.4,@object                # @.str.4
.L.str.4:
	.asciz	" ms"
	.size	.L.str.4, 4

	.type	.L.str.5,@object                # @.str.5
.L.str.5:
	.asciz	"Four chains (pipelined):    "
	.size	.L.str.5, 29

	.type	.L.str.6,@object                # @.str.6
.L.str.6:
	.asciz	"Speedup: "
	.size	.L.str.6, 10

	.type	.L.str.7,@object                # @.str.7
.L.str.7:
	.asciz	"x"
	.size	.L.str.7, 2

	.type	.L.str.8,@object                # @.str.8
.L.str.8:
	.asciz	"Same answer? "
	.size	.L.str.8, 14

	.type	.L.str.9,@object                # @.str.9
.L.str.9:
	.asciz	"YES"
	.size	.L.str.9, 4

	.type	.L.str.10,@object               # @.str.10
.L.str.10:
	.asciz	"NO"
	.size	.L.str.10, 3

	.type	.L.str.11,@object               # @.str.11
.L.str.11:
	.asciz	"(Checksum: "
	.size	.L.str.11, 12

	.type	.L.str.12,@object               # @.str.12
.L.str.12:
	.asciz	")"
	.size	.L.str.12, 2

	.ident	"clang version 21.1.8 (Red Hat, Inc. 21.1.8-2.el9)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym __gxx_personality_v0
	.addrsig_sym _Unwind_Resume
	.addrsig_sym _ZSt4cout
