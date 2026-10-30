_Z6to_hexPKhmPc:                        # @_Z6to_hexPKhmPc
	.cfi_startproc
# %bb.0:
	test	rsi, rsi
	je	.LBB0_18
# %bb.1:
	push	rbp
	.cfi_def_cfa_offset 16
	push	r15
	.cfi_def_cfa_offset 24
	push	r14
	.cfi_def_cfa_offset 32
	push	r13
	.cfi_def_cfa_offset 40
	push	r12
	.cfi_def_cfa_offset 48
	push	rbx
	.cfi_def_cfa_offset 56
	sub	rsp, 64
	.cfi_def_cfa_offset 120
	.cfi_offset rbx, -56
	.cfi_offset r12, -48
	.cfi_offset r13, -40
	.cfi_offset r14, -32
	.cfi_offset r15, -24
	.cfi_offset rbp, -16
	mov	r12, rdx
	cmp	rsi, 7
	jbe	.LBB0_2
# %bb.7:
	lea	rax, [r12 + 2*rsi]
	lea	rcx, [rdi + rsi]
	cmp	r12, rcx
	setb	cl
	cmp	rdi, rax
	setb	al
	test	cl, al
	je	.LBB0_8
.LBB0_2:
	xor	eax, eax
.LBB0_3:
	mov	rcx, rax
	or	rcx, 1
	test	sil, 1
	je	.LBB0_5
# %bb.4:
	movzx	edx, byte ptr [rdi + rax]
	shr	edx, 4
	movzx	edx, byte ptr [rdx + _ZL3HEX]
	mov	byte ptr [r12 + 2*rax], dl
	movzx	edx, byte ptr [rdi + rax]
	and	edx, 15
	movzx	edx, byte ptr [rdx + _ZL3HEX]
	mov	byte ptr [r12 + 2*rax + 1], dl
	mov	rax, rcx
.LBB0_5:
	cmp	rsi, rcx
	je	.LBB0_17
	.p2align	4
.LBB0_6:                                # =>This Inner Loop Header: Depth=1
	movzx	ecx, byte ptr [rdi + rax]
	shr	ecx, 4
	movzx	ecx, byte ptr [rcx + _ZL3HEX]
	mov	byte ptr [r12 + 2*rax], cl
	movzx	ecx, byte ptr [rdi + rax]
	and	ecx, 15
	movzx	ecx, byte ptr [rcx + _ZL3HEX]
	mov	byte ptr [r12 + 2*rax + 1], cl
	movzx	ecx, byte ptr [rdi + rax + 1]
	shr	ecx, 4
	movzx	ecx, byte ptr [rcx + _ZL3HEX]
	mov	byte ptr [r12 + 2*rax + 2], cl
	movzx	ecx, byte ptr [rdi + rax + 1]
	and	ecx, 15
	movzx	ecx, byte ptr [rcx + _ZL3HEX]
	mov	byte ptr [r12 + 2*rax + 3], cl
	add	rax, 2
	cmp	rsi, rax
	jne	.LBB0_6
.LBB0_17:
	add	rsp, 64
	.cfi_def_cfa_offset 56
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	r12
	.cfi_def_cfa_offset 40
	pop	r13
	.cfi_def_cfa_offset 32
	pop	r14
	.cfi_def_cfa_offset 24
	pop	r15
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	.cfi_restore rbx
	.cfi_restore r12
	.cfi_restore r13
	.cfi_restore r14
	.cfi_restore r15
	.cfi_restore rbp
.LBB0_18:
	vzeroupper
	ret
.LBB0_8:
	.cfi_def_cfa_offset 120
	.cfi_offset rbx, -56
	.cfi_offset rbp, -16
	.cfi_offset r12, -48
	.cfi_offset r13, -40
	.cfi_offset r14, -32
	.cfi_offset r15, -24
	cmp	rsi, 32
	jae	.LBB0_10
# %bb.9:
	xor	eax, eax
	jmp	.LBB0_14
.LBB0_10:
	mov	qword ptr [rsp - 88], rsi       # 8-byte Spill
	mov	rax, rsi
	and	rax, -32
	lea	rcx, [rdi + 31]
	xor	r8d, r8d
	.p2align	4
.LBB0_11:                               # =>This Inner Loop Header: Depth=1
	movzx	esi, byte ptr [rcx + r8 - 15]
	mov	qword ptr [rsp + 56], rsi       # 8-byte Spill
	movzx	r9d, byte ptr [rcx + r8 - 14]
	mov	qword ptr [rsp + 48], r9        # 8-byte Spill
	movzx	r10d, byte ptr [rcx + r8 - 13]
	mov	qword ptr [rsp + 40], r10       # 8-byte Spill
	movzx	r11d, byte ptr [rcx + r8 - 12]
	mov	qword ptr [rsp + 32], r11       # 8-byte Spill
	movzx	ebx, byte ptr [rcx + r8 - 11]
	mov	qword ptr [rsp + 24], rbx       # 8-byte Spill
	movzx	ebp, byte ptr [rcx + r8 - 10]
	mov	qword ptr [rsp + 16], rbp       # 8-byte Spill
	movzx	r13d, byte ptr [rcx + r8 - 9]
	mov	qword ptr [rsp + 8], r13        # 8-byte Spill
	movzx	r15d, byte ptr [rcx + r8 - 8]
	mov	qword ptr [rsp], r15            # 8-byte Spill
	movzx	r14d, byte ptr [rcx + r8 - 7]
	mov	qword ptr [rsp - 8], r14        # 8-byte Spill
	movzx	edx, byte ptr [rcx + r8 - 6]
	mov	qword ptr [rsp - 128], rdx      # 8-byte Spill
	movzx	edx, byte ptr [rcx + r8 - 5]
	mov	qword ptr [rsp - 120], rdx      # 8-byte Spill
	movzx	edx, byte ptr [rcx + r8 - 4]
	mov	qword ptr [rsp - 112], rdx      # 8-byte Spill
	movzx	edx, byte ptr [rcx + r8 - 3]
	mov	qword ptr [rsp - 104], rdx      # 8-byte Spill
	movzx	edx, byte ptr [rcx + r8 - 2]
	mov	qword ptr [rsp - 96], rdx       # 8-byte Spill
	mov	edx, esi
	shr	edx, 4
	movzx	edx, byte ptr [rdx + _ZL3HEX]
	vmovd	xmm0, edx
	mov	edx, r9d
	shr	edx, 4
	vpinsrb	xmm0, xmm0, byte ptr [rdx + _ZL3HEX], 1
	mov	edx, r10d
	shr	edx, 4
	vpinsrb	xmm0, xmm0, byte ptr [rdx + _ZL3HEX], 2
	mov	edx, r11d
	shr	edx, 4
	vpinsrb	xmm0, xmm0, byte ptr [rdx + _ZL3HEX], 3
	mov	edx, ebx
	shr	edx, 4
	vpinsrb	xmm0, xmm0, byte ptr [rdx + _ZL3HEX], 4
	mov	edx, ebp
	shr	edx, 4
	vpinsrb	xmm0, xmm0, byte ptr [rdx + _ZL3HEX], 5
	mov	edx, r13d
	shr	edx, 4
	vpinsrb	xmm0, xmm0, byte ptr [rdx + _ZL3HEX], 6
	mov	edx, r15d
	shr	edx, 4
	vpinsrb	xmm0, xmm0, byte ptr [rdx + _ZL3HEX], 7
	mov	edx, r14d
	shr	edx, 4
	vpinsrb	xmm0, xmm0, byte ptr [rdx + _ZL3HEX], 8
	mov	rdx, qword ptr [rsp - 128]      # 8-byte Reload
                                        # kill: def $edx killed $edx killed $rdx def $rdx
	shr	edx, 4
	vpinsrb	xmm0, xmm0, byte ptr [rdx + _ZL3HEX], 9
	mov	rdx, qword ptr [rsp - 120]      # 8-byte Reload
                                        # kill: def $edx killed $edx killed $rdx def $rdx
	shr	edx, 4
	vpinsrb	xmm0, xmm0, byte ptr [rdx + _ZL3HEX], 10
	mov	rdx, qword ptr [rsp - 112]      # 8-byte Reload
                                        # kill: def $edx killed $edx killed $rdx def $rdx
	shr	edx, 4
	vpinsrb	xmm0, xmm0, byte ptr [rdx + _ZL3HEX], 11
	mov	rdx, qword ptr [rsp - 104]      # 8-byte Reload
                                        # kill: def $edx killed $edx killed $rdx def $rdx
	shr	edx, 4
	vpinsrb	xmm0, xmm0, byte ptr [rdx + _ZL3HEX], 12
	mov	rdx, qword ptr [rsp - 96]       # 8-byte Reload
                                        # kill: def $edx killed $edx killed $rdx def $rdx
	shr	edx, 4
	vpinsrb	xmm0, xmm0, byte ptr [rdx + _ZL3HEX], 13
	movzx	edx, byte ptr [rcx + r8 - 1]
	mov	qword ptr [rsp - 16], rdx       # 8-byte Spill
                                        # kill: def $edx killed $edx killed $rdx def $rdx
	shr	edx, 4
	vpinsrb	xmm0, xmm0, byte ptr [rdx + _ZL3HEX], 14
	movzx	edx, byte ptr [rcx + r8]
	mov	qword ptr [rsp - 24], rdx       # 8-byte Spill
                                        # kill: def $edx killed $edx killed $rdx def $rdx
	shr	edx, 4
	vpinsrb	xmm0, xmm0, byte ptr [rdx + _ZL3HEX], 15
	movzx	edx, byte ptr [rcx + r8 - 31]
	mov	qword ptr [rsp - 32], rdx       # 8-byte Spill
                                        # kill: def $edx killed $edx killed $rdx def $rdx
	shr	edx, 4
	movzx	edx, byte ptr [rdx + _ZL3HEX]
	vmovd	xmm1, edx
	movzx	edx, byte ptr [rcx + r8 - 30]
	mov	qword ptr [rsp - 40], rdx       # 8-byte Spill
                                        # kill: def $edx killed $edx killed $rdx def $rdx
	shr	edx, 4
	vpinsrb	xmm1, xmm1, byte ptr [rdx + _ZL3HEX], 1
	movzx	edx, byte ptr [rcx + r8 - 29]
	mov	qword ptr [rsp - 48], rdx       # 8-byte Spill
                                        # kill: def $edx killed $edx killed $rdx def $rdx
	shr	edx, 4
	vpinsrb	xmm1, xmm1, byte ptr [rdx + _ZL3HEX], 2
	movzx	edx, byte ptr [rcx + r8 - 28]
	mov	qword ptr [rsp - 56], rdx       # 8-byte Spill
                                        # kill: def $edx killed $edx killed $rdx def $rdx
	shr	edx, 4
	vpinsrb	xmm1, xmm1, byte ptr [rdx + _ZL3HEX], 3
	movzx	edx, byte ptr [rcx + r8 - 27]
	mov	qword ptr [rsp - 64], rdx       # 8-byte Spill
                                        # kill: def $edx killed $edx killed $rdx def $rdx
	shr	edx, 4
	vpinsrb	xmm1, xmm1, byte ptr [rdx + _ZL3HEX], 4
	movzx	edx, byte ptr [rcx + r8 - 26]
	mov	qword ptr [rsp - 72], rdx       # 8-byte Spill
                                        # kill: def $edx killed $edx killed $rdx def $rdx
	shr	edx, 4
	vpinsrb	xmm1, xmm1, byte ptr [rdx + _ZL3HEX], 5
	movzx	edx, byte ptr [rcx + r8 - 25]
	mov	qword ptr [rsp - 80], rdx       # 8-byte Spill
                                        # kill: def $edx killed $edx killed $rdx def $rdx
	shr	edx, 4
	vpinsrb	xmm1, xmm1, byte ptr [rdx + _ZL3HEX], 6
	movzx	r15d, byte ptr [rcx + r8 - 24]
	mov	edx, r15d
	shr	edx, 4
	vpinsrb	xmm1, xmm1, byte ptr [rdx + _ZL3HEX], 7
	movzx	r14d, byte ptr [rcx + r8 - 23]
	mov	edx, r14d
	shr	edx, 4
	vpinsrb	xmm1, xmm1, byte ptr [rdx + _ZL3HEX], 8
	movzx	ebx, byte ptr [rcx + r8 - 22]
	mov	edx, ebx
	shr	edx, 4
	vpinsrb	xmm1, xmm1, byte ptr [rdx + _ZL3HEX], 9
	movzx	r11d, byte ptr [rcx + r8 - 21]
	mov	edx, r11d
	shr	edx, 4
	vpinsrb	xmm1, xmm1, byte ptr [rdx + _ZL3HEX], 10
	movzx	r10d, byte ptr [rcx + r8 - 20]
	mov	edx, r10d
	shr	edx, 4
	vpinsrb	xmm1, xmm1, byte ptr [rdx + _ZL3HEX], 11
	movzx	r9d, byte ptr [rcx + r8 - 19]
	mov	edx, r9d
	shr	edx, 4
	vpinsrb	xmm1, xmm1, byte ptr [rdx + _ZL3HEX], 12
	movzx	esi, byte ptr [rcx + r8 - 18]
	mov	edx, esi
	shr	edx, 4
	vpinsrb	xmm1, xmm1, byte ptr [rdx + _ZL3HEX], 13
	movzx	edx, byte ptr [rcx + r8 - 17]
	mov	ebp, edx
	shr	ebp, 4
	vpinsrb	xmm1, xmm1, byte ptr [rbp + _ZL3HEX], 14
	movzx	r13d, byte ptr [rcx + r8 - 16]
	mov	ebp, r13d
	shr	ebp, 4
	vpinsrb	xmm1, xmm1, byte ptr [rbp + _ZL3HEX], 15
	mov	rbp, qword ptr [rsp + 56]       # 8-byte Reload
	and	ebp, 15
	movzx	ebp, byte ptr [rbp + _ZL3HEX]
	vmovd	xmm2, ebp
	mov	rbp, qword ptr [rsp + 48]       # 8-byte Reload
	and	ebp, 15
	vpinsrb	xmm2, xmm2, byte ptr [rbp + _ZL3HEX], 1
	mov	rbp, qword ptr [rsp + 40]       # 8-byte Reload
	and	ebp, 15
	vpinsrb	xmm2, xmm2, byte ptr [rbp + _ZL3HEX], 2
	mov	rbp, qword ptr [rsp + 32]       # 8-byte Reload
	and	ebp, 15
	vpinsrb	xmm2, xmm2, byte ptr [rbp + _ZL3HEX], 3
	mov	rbp, qword ptr [rsp + 24]       # 8-byte Reload
	and	ebp, 15
	vpinsrb	xmm2, xmm2, byte ptr [rbp + _ZL3HEX], 4
	mov	rbp, qword ptr [rsp + 16]       # 8-byte Reload
	and	ebp, 15
	vpinsrb	xmm2, xmm2, byte ptr [rbp + _ZL3HEX], 5
	mov	rbp, qword ptr [rsp + 8]        # 8-byte Reload
	and	ebp, 15
	vpinsrb	xmm2, xmm2, byte ptr [rbp + _ZL3HEX], 6
	mov	rbp, qword ptr [rsp]            # 8-byte Reload
	and	ebp, 15
	vpinsrb	xmm2, xmm2, byte ptr [rbp + _ZL3HEX], 7
	mov	rbp, qword ptr [rsp - 8]        # 8-byte Reload
	and	ebp, 15
	vpinsrb	xmm2, xmm2, byte ptr [rbp + _ZL3HEX], 8
	mov	rbp, qword ptr [rsp - 128]      # 8-byte Reload
	and	ebp, 15
	vpinsrb	xmm2, xmm2, byte ptr [rbp + _ZL3HEX], 9
	mov	rbp, qword ptr [rsp - 120]      # 8-byte Reload
	and	ebp, 15
	vpinsrb	xmm2, xmm2, byte ptr [rbp + _ZL3HEX], 10
	mov	rbp, qword ptr [rsp - 112]      # 8-byte Reload
	and	ebp, 15
	vpinsrb	xmm2, xmm2, byte ptr [rbp + _ZL3HEX], 11
	mov	rbp, qword ptr [rsp - 104]      # 8-byte Reload
	and	ebp, 15
	vpinsrb	xmm2, xmm2, byte ptr [rbp + _ZL3HEX], 12
	mov	rbp, qword ptr [rsp - 96]       # 8-byte Reload
	and	ebp, 15
	vpinsrb	xmm2, xmm2, byte ptr [rbp + _ZL3HEX], 13
	mov	rbp, qword ptr [rsp - 16]       # 8-byte Reload
	and	ebp, 15
	vpinsrb	xmm2, xmm2, byte ptr [rbp + _ZL3HEX], 14
	mov	rbp, qword ptr [rsp - 24]       # 8-byte Reload
	and	ebp, 15
	vpinsrb	xmm2, xmm2, byte ptr [rbp + _ZL3HEX], 15
	mov	rbp, qword ptr [rsp - 32]       # 8-byte Reload
	and	ebp, 15
	movzx	ebp, byte ptr [rbp + _ZL3HEX]
	vmovd	xmm3, ebp
	mov	rbp, qword ptr [rsp - 40]       # 8-byte Reload
	and	ebp, 15
	vpinsrb	xmm3, xmm3, byte ptr [rbp + _ZL3HEX], 1
	mov	rbp, qword ptr [rsp - 48]       # 8-byte Reload
	and	ebp, 15
	vpinsrb	xmm3, xmm3, byte ptr [rbp + _ZL3HEX], 2
	mov	rbp, qword ptr [rsp - 56]       # 8-byte Reload
	and	ebp, 15
	vpinsrb	xmm3, xmm3, byte ptr [rbp + _ZL3HEX], 3
	mov	rbp, qword ptr [rsp - 64]       # 8-byte Reload
	and	ebp, 15
	vpinsrb	xmm3, xmm3, byte ptr [rbp + _ZL3HEX], 4
	mov	rbp, qword ptr [rsp - 72]       # 8-byte Reload
	and	ebp, 15
	vpinsrb	xmm3, xmm3, byte ptr [rbp + _ZL3HEX], 5
	mov	rbp, qword ptr [rsp - 80]       # 8-byte Reload
	and	ebp, 15
	vpinsrb	xmm3, xmm3, byte ptr [rbp + _ZL3HEX], 6
	and	r15d, 15
	vpinsrb	xmm3, xmm3, byte ptr [r15 + _ZL3HEX], 7
	and	r14d, 15
	vpinsrb	xmm3, xmm3, byte ptr [r14 + _ZL3HEX], 8
	and	ebx, 15
	vpinsrb	xmm3, xmm3, byte ptr [rbx + _ZL3HEX], 9
	and	r11d, 15
	vpinsrb	xmm3, xmm3, byte ptr [r11 + _ZL3HEX], 10
	and	r10d, 15
	vpinsrb	xmm3, xmm3, byte ptr [r10 + _ZL3HEX], 11
	and	r9d, 15
	vpinsrb	xmm3, xmm3, byte ptr [r9 + _ZL3HEX], 12
	and	esi, 15
	vpinsrb	xmm3, xmm3, byte ptr [rsi + _ZL3HEX], 13
	and	edx, 15
	vpinsrb	xmm3, xmm3, byte ptr [rdx + _ZL3HEX], 14
	and	r13d, 15
	vpinsrb	xmm3, xmm3, byte ptr [r13 + _ZL3HEX], 15
	vinserti128	ymm0, ymm1, xmm0, 1
	vinserti128	ymm1, ymm3, xmm2, 1
	vpunpckhbw	ymm2, ymm0, ymm1        # ymm2 = ymm0[8],ymm1[8],ymm0[9],ymm1[9],ymm0[10],ymm1[10],ymm0[11],ymm1[11],ymm0[12],ymm1[12],ymm0[13],ymm1[13],ymm0[14],ymm1[14],ymm0[15],ymm1[15],ymm0[24],ymm1[24],ymm0[25],ymm1[25],ymm0[26],ymm1[26],ymm0[27],ymm1[27],ymm0[28],ymm1[28],ymm0[29],ymm1[29],ymm0[30],ymm1[30],ymm0[31],ymm1[31]
	vpunpcklbw	ymm0, ymm0, ymm1        # ymm0 = ymm0[0],ymm1[0],ymm0[1],ymm1[1],ymm0[2],ymm1[2],ymm0[3],ymm1[3],ymm0[4],ymm1[4],ymm0[5],ymm1[5],ymm0[6],ymm1[6],ymm0[7],ymm1[7],ymm0[16],ymm1[16],ymm0[17],ymm1[17],ymm0[18],ymm1[18],ymm0[19],ymm1[19],ymm0[20],ymm1[20],ymm0[21],ymm1[21],ymm0[22],ymm1[22],ymm0[23],ymm1[23]
	vperm2i128	ymm1, ymm0, ymm2, 32    # ymm1 = ymm0[0,1],ymm2[0,1]
	vperm2i128	ymm0, ymm0, ymm2, 49    # ymm0 = ymm0[2,3],ymm2[2,3]
	vmovdqu	ymmword ptr [r12 + 2*r8 + 32], ymm0
	vmovdqu	ymmword ptr [r12 + 2*r8], ymm1
	add	r8, 32
	cmp	rax, r8
	jne	.LBB0_11
# %bb.12:
	mov	rsi, qword ptr [rsp - 88]       # 8-byte Reload
	cmp	rsi, rax
	je	.LBB0_17
# %bb.13:
	test	sil, 24
	je	.LBB0_3
.LBB0_14:
	mov	rcx, rax
	mov	rax, rsi
	and	rax, -8
	.p2align	4
.LBB0_15:                               # =>This Inner Loop Header: Depth=1
	movzx	edx, byte ptr [rdi + rcx]
	mov	r8d, edx
	shr	r8d, 4
	movzx	r8d, byte ptr [r8 + _ZL3HEX]
	vmovd	xmm0, r8d
	movzx	r8d, byte ptr [rdi + rcx + 1]
	and	edx, 15
	vpinsrb	xmm0, xmm0, byte ptr [rdx + _ZL3HEX], 1
	mov	edx, r8d
	shr	edx, 4
	vpinsrb	xmm0, xmm0, byte ptr [rdx + _ZL3HEX], 2
	movzx	edx, byte ptr [rdi + rcx + 2]
	and	r8d, 15
	vpinsrb	xmm0, xmm0, byte ptr [r8 + _ZL3HEX], 3
	mov	r8d, edx
	shr	r8d, 4
	vpinsrb	xmm0, xmm0, byte ptr [r8 + _ZL3HEX], 4
	movzx	r8d, byte ptr [rdi + rcx + 3]
	and	edx, 15
	vpinsrb	xmm0, xmm0, byte ptr [rdx + _ZL3HEX], 5
	mov	edx, r8d
	shr	edx, 4
	vpinsrb	xmm0, xmm0, byte ptr [rdx + _ZL3HEX], 6
	movzx	edx, byte ptr [rdi + rcx + 4]
	and	r8d, 15
	vpinsrb	xmm0, xmm0, byte ptr [r8 + _ZL3HEX], 7
	mov	r8d, edx
	shr	r8d, 4
	vpinsrb	xmm0, xmm0, byte ptr [r8 + _ZL3HEX], 8
	movzx	r8d, byte ptr [rdi + rcx + 5]
	and	edx, 15
	vpinsrb	xmm0, xmm0, byte ptr [rdx + _ZL3HEX], 9
	mov	edx, r8d
	shr	edx, 4
	vpinsrb	xmm0, xmm0, byte ptr [rdx + _ZL3HEX], 10
	movzx	edx, byte ptr [rdi + rcx + 6]
	and	r8d, 15
	vpinsrb	xmm0, xmm0, byte ptr [r8 + _ZL3HEX], 11
	mov	r8d, edx
	shr	r8d, 4
	vpinsrb	xmm0, xmm0, byte ptr [r8 + _ZL3HEX], 12
	movzx	r8d, byte ptr [rdi + rcx + 7]
	and	edx, 15
	vpinsrb	xmm0, xmm0, byte ptr [rdx + _ZL3HEX], 13
	mov	edx, r8d
	shr	edx, 4
	vpinsrb	xmm0, xmm0, byte ptr [rdx + _ZL3HEX], 14
	and	r8d, 15
	vpinsrb	xmm0, xmm0, byte ptr [r8 + _ZL3HEX], 15
	vmovdqu	xmmword ptr [r12 + 2*rcx], xmm0
	add	rcx, 8
	cmp	rax, rcx
	jne	.LBB0_15
# %bb.16:
	cmp	rsi, rax
	jne	.LBB0_3
	jmp	.LBB0_17
.Lfunc_end0:
	.size	_Z6to_hexPKhmPc, .Lfunc_end0-_Z6to_hexPKhmPc
	.cfi_endproc
