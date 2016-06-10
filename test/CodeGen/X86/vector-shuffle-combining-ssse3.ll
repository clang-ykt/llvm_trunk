; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+ssse3 | FileCheck %s --check-prefix=ALL --check-prefix=SSE --check-prefix=SSSE3
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=ALL --check-prefix=SSE --check-prefix=SSE41
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx2 | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX2
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx512f | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX512F
;
; Combine tests involving SSE3/SSSE3 target shuffles (MOVDDUP, MOVSHDUP, MOVSLDUP, PSHUFB)

declare <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8>, <16 x i8>)

define <16 x i8> @combine_vpshufb_zero(<16 x i8> %a0) {
; SSE-LABEL: combine_vpshufb_zero:
; SSE:       # BB#0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vpshufb_zero:
; AVX:       # BB#0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %res0 = call <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8> %a0, <16 x i8> <i8 128, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0>)
  %res1 = call <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8> %res0, <16 x i8> <i8 0, i8 128, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0>)
  %res2 = call <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8> %res1, <16 x i8> <i8 0, i8 1, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128>)
  ret <16 x i8> %res2
}

define <16 x i8> @combine_vpshufb_movq(<16 x i8> %a0) {
; SSE-LABEL: combine_vpshufb_movq:
; SSE:       # BB#0:
; SSE-NEXT:    movq {{.*#+}} xmm0 = xmm0[0],zero
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vpshufb_movq:
; AVX:       # BB#0:
; AVX-NEXT:    vmovq {{.*#+}} xmm0 = xmm0[0],zero
; AVX-NEXT:    retq
  %res0 = call <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8> %a0, <16 x i8> <i8 0, i8 128, i8 1, i8 128, i8 2, i8 128, i8 3, i8 128, i8 4, i8 128, i8 5, i8 128, i8 6, i8 128, i8 7, i8 128>)
  %res1 = call <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8> %res0, <16 x i8> <i8 0, i8 2, i8 4, i8 6, i8 8, i8 10, i8 12, i8 14, i8 1, i8 3, i8 5, i8 7, i8 9, i8 11, i8 13, i8 15>)
  ret <16 x i8> %res1
}

define <4 x float> @combine_pshufb_movddup(<4 x float> %a0) {
; SSE-LABEL: combine_pshufb_movddup:
; SSE:       # BB#0:
; SSE-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[5,5,5,5,7,7,7,7,5,5,5,5,7,7,7,7]
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_pshufb_movddup:
; AVX:       # BB#0:
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[5,5,5,5,7,7,7,7,5,5,5,5,7,7,7,7]
; AVX-NEXT:    retq
  %1 = bitcast <4 x float> %a0 to <16 x i8>
  %2 = tail call <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8> %1, <16 x i8> <i8 5, i8 5, i8 5, i8 5, i8 7, i8 7, i8 7, i8 7, i8 1, i8 1, i8 1, i8 1, i8 3, i8 3, i8 3, i8 3>)
  %3 = bitcast <16 x i8> %2 to <4 x float>
  %4 = shufflevector <4 x float> %3, <4 x float> undef, <4 x i32> <i32 0, i32 1, i32 0, i32 1>
  ret <4 x float> %4
}

define <4 x float> @combine_pshufb_movshdup(<4 x float> %a0) {
; SSE-LABEL: combine_pshufb_movshdup:
; SSE:       # BB#0:
; SSE-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[7,7,7,7,7,7,7,7,3,3,3,3,3,3,3,3]
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_pshufb_movshdup:
; AVX:       # BB#0:
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[7,7,7,7,7,7,7,7,3,3,3,3,3,3,3,3]
; AVX-NEXT:    retq
  %1 = bitcast <4 x float> %a0 to <16 x i8>
  %2 = tail call <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8> %1, <16 x i8> <i8 5, i8 5, i8 5, i8 5, i8 7, i8 7, i8 7, i8 7, i8 1, i8 1, i8 1, i8 1, i8 3, i8 3, i8 3, i8 3>)
  %3 = bitcast <16 x i8> %2 to <4 x float>
  %4 = shufflevector <4 x float> %3, <4 x float> undef, <4 x i32> <i32 1, i32 1, i32 3, i32 3>
  ret <4 x float> %4
}

define <4 x float> @combine_pshufb_movsldup(<4 x float> %a0) {
; SSE-LABEL: combine_pshufb_movsldup:
; SSE:       # BB#0:
; SSE-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[5,5,5,5,5,5,5,5,1,1,1,1,1,1,1,1]
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_pshufb_movsldup:
; AVX:       # BB#0:
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[5,5,5,5,5,5,5,5,1,1,1,1,1,1,1,1]
; AVX-NEXT:    retq
  %1 = bitcast <4 x float> %a0 to <16 x i8>
  %2 = tail call <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8> %1, <16 x i8> <i8 5, i8 5, i8 5, i8 5, i8 7, i8 7, i8 7, i8 7, i8 1, i8 1, i8 1, i8 1, i8 3, i8 3, i8 3, i8 3>)
  %3 = bitcast <16 x i8> %2 to <4 x float>
  %4 = shufflevector <4 x float> %3, <4 x float> undef, <4 x i32> <i32 0, i32 0, i32 2, i32 2>
  ret <4 x float> %4
}

define <16 x i8> @combine_pshufb_palignr(<16 x i8> %a0, <16 x i8> %a1) {
; SSE-LABEL: combine_pshufb_palignr:
; SSE:       # BB#0:
; SSE-NEXT:    pshufb {{.*#+}} xmm1 = xmm1[8,9,10,11,12,13,14,15,8,9,10,11,12,13,14,15]
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_pshufb_palignr:
; AVX:       # BB#0:
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm1[8,9,10,11,12,13,14,15,8,9,10,11,12,13,14,15]
; AVX-NEXT:    retq
  %1 = shufflevector <16 x i8> %a0, <16 x i8> %a1, <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23>
  %2 = tail call <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8> %1, <16 x i8> <i8 0, i8 1, i8 2, i8 3, i8 4, i8 5, i8 6, i8 7, i8 0, i8 1, i8 2, i8 3, i8 4, i8 5, i8 6, i8 7>)
  ret <16 x i8> %2
}

define <16 x i8> @combine_pshufb_pslldq(<16 x i8> %a0) {
; SSE-LABEL: combine_pshufb_pslldq:
; SSE:       # BB#0:
; SSE-NEXT:    pshufb {{.*#+}} xmm0 = zero,zero,zero,zero,zero,zero,zero,zero,xmm0[0,1,2,3,4,5,6,7]
; SSE-NEXT:    pslldq {{.*#+}} xmm0 = zero,zero,zero,zero,zero,zero,zero,zero,xmm0[0,1,2,3,4,5,6,7]
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_pshufb_pslldq:
; AVX:       # BB#0:
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = zero,zero,zero,zero,zero,zero,zero,zero,xmm0[0,1,2,3,4,5,6,7]
; AVX-NEXT:    vpslldq {{.*#+}} xmm0 = zero,zero,zero,zero,zero,zero,zero,zero,xmm0[0,1,2,3,4,5,6,7]
; AVX-NEXT:    retq
  %1 = tail call <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8> %a0, <16 x i8> <i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 0, i8 1, i8 2, i8 3, i8 4, i8 5, i8 6, i8 7>)
  %2 = shufflevector <16 x i8> %1, <16 x i8> zeroinitializer, <16 x i32> <i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  ret <16 x i8> %2
}

define <16 x i8> @combine_pshufb_psrldq(<16 x i8> %a0) {
; SSE-LABEL: combine_pshufb_psrldq:
; SSE:       # BB#0:
; SSE-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[8,9,10,11,12,13,14,15],zero,zero,zero,zero,zero,zero,zero,zero
; SSE-NEXT:    psrldq {{.*#+}} xmm0 = xmm0[8,9,10,11,12,13,14,15],zero,zero,zero,zero,zero,zero,zero,zero
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_pshufb_psrldq:
; AVX:       # BB#0:
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[8,9,10,11,12,13,14,15],zero,zero,zero,zero,zero,zero,zero,zero
; AVX-NEXT:    vpsrldq {{.*#+}} xmm0 = xmm0[8,9,10,11,12,13,14,15],zero,zero,zero,zero,zero,zero,zero,zero
; AVX-NEXT:    retq
  %1 = tail call <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8> %a0, <16 x i8> <i8 8, i8 9, i8 10, i8 11, i8 12, i8 13, i8 14, i8 15, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128>)
  %2 = shufflevector <16 x i8> %1, <16 x i8> zeroinitializer, <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16>
  ret <16 x i8> %2
}

define <16 x i8> @combine_unpckl_arg0_pshufb(<16 x i8> %a0, <16 x i8> %a1) {
; SSE-LABEL: combine_unpckl_arg0_pshufb:
; SSE:       # BB#0:
; SSE-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[0],zero,zero,zero,xmm0[0],zero,zero,zero,xmm0[0],zero,zero,zero
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_unpckl_arg0_pshufb:
; AVX:       # BB#0:
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[0],zero,zero,zero,xmm0[0],zero,zero,zero,xmm0[0],zero,zero,zero
; AVX-NEXT:    retq
  %1 = shufflevector <16 x i8> %a0, <16 x i8> %a1, <16 x i32> <i32 0, i32 16, i32 1, i32 17, i32 2, i32 18, i32 3, i32 19, i32 4, i32 20, i32 5, i32 21, i32 6, i32 22, i32 7, i32 23>
  %2 = tail call <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8> %1, <16 x i8> <i8 0, i8 -1, i8 -1, i8 -1, i8 0, i8 -1, i8 -1, i8 -1, i8 0, i8 -1, i8 -1, i8 -1, i8 0, i8 -1, i8 -1, i8 -1>)
  ret <16 x i8> %2
}

define <16 x i8> @combine_unpckl_arg1_pshufb(<16 x i8> %a0, <16 x i8> %a1) {
; SSE-LABEL: combine_unpckl_arg1_pshufb:
; SSE:       # BB#0:
; SSE-NEXT:    pshufb {{.*#+}} xmm1 = xmm1[0],zero,zero,zero,xmm1[0],zero,zero,zero,xmm1[0],zero,zero,zero,xmm1[0],zero,zero,zero
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_unpckl_arg1_pshufb:
; AVX:       # BB#0:
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm1[0],zero,zero,zero,xmm1[0],zero,zero,zero,xmm1[0],zero,zero,zero,xmm1[0],zero,zero,zero
; AVX-NEXT:    retq
  %1 = shufflevector <16 x i8> %a0, <16 x i8> %a1, <16 x i32> <i32 0, i32 16, i32 1, i32 17, i32 2, i32 18, i32 3, i32 19, i32 4, i32 20, i32 5, i32 21, i32 6, i32 22, i32 7, i32 23>
  %2 = tail call <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8> %1, <16 x i8> <i8 1, i8 -1, i8 -1, i8 -1, i8 1, i8 -1, i8 -1, i8 -1, i8 1, i8 -1, i8 -1, i8 -1, i8 1, i8 -1, i8 -1, i8 -1>)
  ret <16 x i8> %2
}
