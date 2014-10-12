; ModuleID = 'hata_kernel.cl'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-f80:32:32-v16:16:16-v24:32:32-v32:32:32-v48:64:64-v64:64:64-v96:128:128-v128:128:128-v192:256:256-v256:256:256-v512:512:512-v1024:1024:1024-a0:0:64"
target triple = "amdil-pc-amdopencl"

%0 = type { i8*, i8*, i8*, i8*, i32 }
%1 = type <{ i64, i64, i64 }>

@sgv = internal addrspace(2) constant [1 x i8] zeroinitializer ; <[1 x i8] addrspace(2)*> [#uses=1]
@fgv = internal addrspace(2) constant [1 x i8] zeroinitializer ; <[1 x i8] addrspace(2)*> [#uses=1]
@lvgv = internal constant [0 x i8*] zeroinitializer ; <[0 x i8*]*> [#uses=1]
@sgv1 = internal addrspace(2) constant [1 x i8] zeroinitializer ; <[1 x i8] addrspace(2)*> [#uses=1]
@fgv2 = internal addrspace(2) constant [1 x i8] zeroinitializer ; <[1 x i8] addrspace(2)*> [#uses=1]
@lvgv3 = internal constant [0 x i8*] zeroinitializer ; <[0 x i8*]*> [#uses=1]
@sgv4 = internal addrspace(2) constant [1 x i8] zeroinitializer ; <[1 x i8] addrspace(2)*> [#uses=1]
@fgv5 = internal addrspace(2) constant [1 x i8] zeroinitializer ; <[1 x i8] addrspace(2)*> [#uses=1]
@lvgv6 = internal constant [0 x i8*] zeroinitializer ; <[0 x i8*]*> [#uses=1]
@sgv7 = internal addrspace(2) constant [1 x i8] zeroinitializer ; <[1 x i8] addrspace(2)*> [#uses=1]
@fgv8 = internal addrspace(2) constant [1 x i8] zeroinitializer ; <[1 x i8] addrspace(2)*> [#uses=1]
@lvgv9 = internal constant [0 x i8*] zeroinitializer ; <[0 x i8*]*> [#uses=1]
@llvm.global.annotations = appending global [4 x %0] [%0 { i8* bitcast (void (i32, i32, <4 x i32>, i32, i32, i64, i8 addrspace(1)*, <4 x i32> addrspace(1)*, float addrspace(1)*, float addrspace(1)*, i16 addrspace(1)*, i32 addrspace(1)*, i16 addrspace(3)*)* @__OpenCL_agent_kern_kernel to i8*), i8* bitcast ([1 x i8] addrspace(2)* @sgv to i8*), i8* bitcast ([1 x i8] addrspace(2)* @fgv to i8*), i8* bitcast ([0 x i8*]* @lvgv to i8*), i32 0 }, %0 { i8* bitcast (void (i32, i32, i8 addrspace(1)*, <4 x i32> addrspace(1)*, float addrspace(1)*, i32 addrspace(1)*, float addrspace(1)*, i16 addrspace(1)*, i16 addrspace(1)*, i32, i32, float addrspace(3)*)* @__OpenCL_coverage_kern_kernel to i8*), i8* bitcast ([1 x i8] addrspace(2)* @sgv1 to i8*), i8* bitcast ([1 x i8] addrspace(2)* @fgv2 to i8*), i8* bitcast ([0 x i8*]* @lvgv3 to i8*), i32 0 }, %0 { i8* bitcast (void (i32, i32, <4 x i32>, <2 x i32>, float, float, float, float addrspace(1)*, float addrspace(1)*, <2 x float> addrspace(3)*)* @__OpenCL_hata_urban_interference_kernel to i8*), i8* bitcast ([1 x i8] addrspace(2)* @sgv4 to i8*), i8* bitcast ([1 x i8] addrspace(2)* @fgv5 to i8*), i8* bitcast ([0 x i8*]* @lvgv6 to i8*), i32 0 }, %0 { i8* bitcast (void (i32, i32, <4 x i32>, <2 x i32>, float, float, float, float addrspace(1)*, float addrspace(1)*, <2 x float> addrspace(3)*)* @__OpenCL_hata_urban_kern_per_tx_kernel to i8*), i8* bitcast ([1 x i8] addrspace(2)* @sgv7 to i8*), i8* bitcast ([1 x i8] addrspace(2)* @fgv8 to i8*), i8* bitcast ([0 x i8*]* @lvgv9 to i8*), i32 0 }], section "llvm.metadata" ; <[4 x %0]*> [#uses=0]

define i64 @random(%1* %r) nounwind {
entry:
  %retval = alloca i64, align 8                   ; <i64*> [#uses=2]
  %r.addr = alloca %1*, align 4                   ; <%1**> [#uses=8]
  %old = alloca i64, align 8                      ; <i64*> [#uses=2]
  store %1* %r, %1** %r.addr
  %tmp = load %1** %r.addr                        ; <%1*> [#uses=1]
  %structele = getelementptr inbounds %1* %tmp, i32 0, i32 1 ; <i64*> [#uses=1]
  %tmp1 = load i64* %structele                    ; <i64> [#uses=1]
  store i64 %tmp1, i64* %old
  %tmp2 = load %1** %r.addr                       ; <%1*> [#uses=1]
  %structele3 = getelementptr inbounds %1* %tmp2, i32 0, i32 1 ; <i64*> [#uses=1]
  %tmp4 = load %1** %r.addr                       ; <%1*> [#uses=1]
  %structele5 = getelementptr inbounds %1* %tmp4, i32 0, i32 0 ; <i64*> [#uses=1]
  %tmp6 = load i64* %structele5                   ; <i64> [#uses=1]
  %tmp7 = mul i64 %tmp6, 1103515245               ; <i64> [#uses=1]
  %tmp8 = add i64 %tmp7, 12345                    ; <i64> [#uses=1]
  store i64 %tmp8, i64* %structele3
  %tmp9 = load %1** %r.addr                       ; <%1*> [#uses=1]
  %structele10 = getelementptr inbounds %1* %tmp9, i32 0, i32 0 ; <i64*> [#uses=1]
  %tmp11 = load i64* %old                         ; <i64> [#uses=1]
  %tmp12 = xor i64 %tmp11, -1                     ; <i64> [#uses=1]
  %tmp13 = load %1** %r.addr                      ; <%1*> [#uses=1]
  %structele14 = getelementptr inbounds %1* %tmp13, i32 0, i32 1 ; <i64*> [#uses=1]
  %tmp15 = load i64* %structele14                 ; <i64> [#uses=1]
  %tmp16 = lshr i64 %tmp15, 3                     ; <i64> [#uses=1]
  %tmp17 = xor i64 %tmp12, %tmp16                 ; <i64> [#uses=1]
  %tmp18 = load %1** %r.addr                      ; <%1*> [#uses=1]
  %structele19 = getelementptr inbounds %1* %tmp18, i32 0, i32 2 ; <i64*> [#uses=2]
  %tmp20 = load i64* %structele19                 ; <i64> [#uses=2]
  %tmp21 = add i64 %tmp20, 1                      ; <i64> [#uses=1]
  store i64 %tmp21, i64* %structele19
  %tmp22 = sub i64 %tmp17, %tmp20                 ; <i64> [#uses=1]
  store i64 %tmp22, i64* %structele10
  %tmp23 = load %1** %r.addr                      ; <%1*> [#uses=1]
  %structele24 = getelementptr inbounds %1* %tmp23, i32 0, i32 1 ; <i64*> [#uses=1]
  %tmp25 = load i64* %structele24                 ; <i64> [#uses=1]
  store i64 %tmp25, i64* %retval
  br label %return

return:                                           ; preds = %entry
  %tmp26 = load i64* %retval                      ; <i64> [#uses=1]
  ret i64 %tmp26
}

define float @random_01(%1* %r) nounwind {
entry:
  %retval = alloca float, align 4                 ; <float*> [#uses=2]
  %r.addr = alloca %1*, align 4                   ; <%1**> [#uses=2]
  store %1* %r, %1** %r.addr
  %tmp = load %1** %r.addr                        ; <%1*> [#uses=1]
  %call = call i64 @random(%1* %tmp) nounwind     ; <i64> [#uses=1]
  %tmp1 = and i64 %call, 4294967295               ; <i64> [#uses=1]
  %conv = uitofp i64 %tmp1 to float               ; <float> [#uses=1]
  %tmp2 = fdiv float %conv, 0x41F0000000000000    ; <float> [#uses=1]
  store float %tmp2, float* %retval
  br label %return

return:                                           ; preds = %entry
  %tmp3 = load float* %retval                     ; <float> [#uses=1]
  ret float %tmp3
}

define void @seed_random(%1* %r, i64 %seed) nounwind {
entry:
  %r.addr = alloca %1*, align 4                   ; <%1**> [#uses=4]
  %seed.addr = alloca i64, align 8                ; <i64*> [#uses=2]
  store %1* %r, %1** %r.addr
  store i64 %seed, i64* %seed.addr
  %tmp = load %1** %r.addr                        ; <%1*> [#uses=1]
  %structele = getelementptr inbounds %1* %tmp, i32 0, i32 0 ; <i64*> [#uses=1]
  %tmp1 = load i64* %seed.addr                    ; <i64> [#uses=1]
  store i64 %tmp1, i64* %structele
  %tmp2 = load %1** %r.addr                       ; <%1*> [#uses=1]
  %structele3 = getelementptr inbounds %1* %tmp2, i32 0, i32 1 ; <i64*> [#uses=1]
  store i64 0, i64* %structele3
  %tmp4 = load %1** %r.addr                       ; <%1*> [#uses=1]
  %structele5 = getelementptr inbounds %1* %tmp4, i32 0, i32 2 ; <i64*> [#uses=1]
  store i64 362436, i64* %structele5
  br label %return

return:                                           ; preds = %entry
  ret void
}

define void @__OpenCL_agent_kern_kernel(i32 %ntx, i32 %ncols, <4 x i32> %mdim, i32 %uncovered_count, i32 %uncov_coord_length, i64 %random_seed, i8 addrspace(1)* %pl_in, <4 x i32> addrspace(1)* %offsets_in, float addrspace(1)* %qrm_in, float addrspace(1)* %cov_in, i16 addrspace(1)* %uncov_coord_in, i32 addrspace(1)* %tx_pwr, i16 addrspace(3)* %pblock) nounwind {
entry:
  %ntx.addr = alloca i32, align 4                 ; <i32*> [#uses=3]
  %ncols.addr = alloca i32, align 4               ; <i32*> [#uses=2]
  %mdim.addr = alloca <4 x i32>, align 16         ; <<4 x i32>*> [#uses=7]
  %uncovered_count.addr = alloca i32, align 4     ; <i32*> [#uses=2]
  %uncov_coord_length.addr = alloca i32, align 4  ; <i32*> [#uses=2]
  %random_seed.addr = alloca i64, align 8         ; <i64*> [#uses=2]
  %pl_in.addr = alloca i8 addrspace(1)*, align 4  ; <i8 addrspace(1)**> [#uses=1]
  %offsets_in.addr = alloca <4 x i32> addrspace(1)*, align 4 ; <<4 x i32> addrspace(1)**> [#uses=1]
  %qrm_in.addr = alloca float addrspace(1)*, align 4 ; <float addrspace(1)**> [#uses=1]
  %cov_in.addr = alloca float addrspace(1)*, align 4 ; <float addrspace(1)**> [#uses=2]
  %uncov_coord_in.addr = alloca i16 addrspace(1)*, align 4 ; <i16 addrspace(1)**> [#uses=3]
  %tx_pwr.addr = alloca i32 addrspace(1)*, align 4 ; <i32 addrspace(1)**> [#uses=3]
  %pblock.addr = alloca i16 addrspace(3)*, align 4 ; <i16 addrspace(3)**> [#uses=7]
  %tx = alloca i32, align 4                       ; <i32*> [#uses=7]
  %randstate = alloca %1, align 8                 ; <%1*> [#uses=6]
  %tx_id = alloca i32, align 4                    ; <i32*> [#uses=7]
  %tx_new_pwr = alloca float, align 4             ; <float*> [#uses=7]
  %idx_thread = alloca i32, align 4               ; <i32*> [#uses=5]
  %tmp = alloca <2 x i32>, align 8                ; <<2 x i32>*> [#uses=2]
  %ccoord = alloca <2 x i32>, align 8             ; <<2 x i32>*> [#uses=19]
  %idx_coord = alloca i32, align 4                ; <i32*> [#uses=5]
  %idx_2d = alloca i32, align 4                   ; <i32*> [#uses=2]
  %tmp89 = alloca <2 x float>, align 8            ; <<2 x float>*> [#uses=2]
  %max_signal = alloca <2 x float>, align 8       ; <<2 x float>*> [#uses=4]
  %tmp103 = alloca <2 x float>, align 8           ; <<2 x float>*> [#uses=2]
  %min_signal = alloca <2 x float>, align 8       ; <<2 x float>*> [#uses=4]
  %ty = alloca i32, align 4                       ; <i32*> [#uses=7]
  %new_pwr = alloca i32, align 4                  ; <i32*> [#uses=5]
  store i32 %ntx, i32* %ntx.addr
  store i32 %ncols, i32* %ncols.addr
  store <4 x i32> %mdim, <4 x i32>* %mdim.addr
  store i32 %uncovered_count, i32* %uncovered_count.addr
  store i32 %uncov_coord_length, i32* %uncov_coord_length.addr
  store i64 %random_seed, i64* %random_seed.addr
  store i8 addrspace(1)* %pl_in, i8 addrspace(1)** %pl_in.addr
  store <4 x i32> addrspace(1)* %offsets_in, <4 x i32> addrspace(1)** %offsets_in.addr
  store float addrspace(1)* %qrm_in, float addrspace(1)** %qrm_in.addr
  store float addrspace(1)* %cov_in, float addrspace(1)** %cov_in.addr
  store i16 addrspace(1)* %uncov_coord_in, i16 addrspace(1)** %uncov_coord_in.addr
  store i32 addrspace(1)* %tx_pwr, i32 addrspace(1)** %tx_pwr.addr
  store i16 addrspace(3)* %pblock, i16 addrspace(3)** %pblock.addr
  %call = call i32 @get_local_id(i32 0) nounwind  ; <i32> [#uses=1]
  store i32 %call, i32* %idx_thread
  store <2 x i32> <i32 -1, i32 -1>, <2 x i32>* %tmp
  %tmp1 = load <2 x i32>* %tmp                    ; <<2 x i32>> [#uses=1]
  store <2 x i32> %tmp1, <2 x i32>* %ccoord
  %tmp2 = load i64* %random_seed.addr             ; <i64> [#uses=1]
  call void @seed_random(%1* %randstate, i64 %tmp2) nounwind
  %tmp3 = load i32* %idx_thread                   ; <i32> [#uses=1]
  %tmp4 = srem i32 %tmp3, 2                       ; <i32> [#uses=1]
  %cmp = icmp eq i32 %tmp4, 0                     ; <i1> [#uses=1]
  br i1 %cmp, label %if.then, label %if.end

return:                                           ; preds = %if.end138
  ret void

if.end:                                           ; preds = %if.end7, %entry
  %tmp34 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp35 = extractelement <2 x i32> %tmp34, i32 0 ; <i32> [#uses=1]
  %cmp36 = icmp slt i32 %tmp35, 0                 ; <i1> [#uses=1]
  br i1 %cmp36, label %if.then38, label %if.end37

if.then:                                          ; preds = %entry
  %tmp5 = load i32* %uncovered_count.addr         ; <i32> [#uses=1]
  %cmp6 = icmp sgt i32 %tmp5, 0                   ; <i1> [#uses=1]
  br i1 %cmp6, label %if.then8, label %if.end7

if.end7:                                          ; preds = %do.exit, %if.then
  br label %if.end

if.then8:                                         ; preds = %if.then
  br label %do.body

do.exit:                                          ; preds = %do.cond
  br label %if.end7

do.body:                                          ; preds = %do.cond, %if.then8
  %call9 = call i64 @random(%1* %randstate) nounwind ; <i64> [#uses=1]
  %tmp10 = load i32* %uncov_coord_length.addr     ; <i32> [#uses=1]
  %conv = sext i32 %tmp10 to i64                  ; <i64> [#uses=1]
  %tmp11 = urem i64 %call9, %conv                 ; <i64> [#uses=1]
  %conv12 = trunc i64 %tmp11 to i32               ; <i32> [#uses=1]
  store i32 %conv12, i32* %idx_coord
  %tmp13 = load i32* %idx_coord                   ; <i32> [#uses=1]
  %tmp14 = sub nsw i32 %tmp13, 1                  ; <i32> [#uses=1]
  store i32 %tmp14, i32* %idx_coord
  %tmp15 = load i16 addrspace(1)** %uncov_coord_in.addr ; <i16 addrspace(1)*> [#uses=1]
  %tmp16 = load i32* %idx_coord                   ; <i32> [#uses=1]
  %tmp17 = mul i32 2, %tmp16                      ; <i32> [#uses=1]
  %arrayidx = getelementptr i16 addrspace(1)* %tmp15, i32 %tmp17 ; <i16 addrspace(1)*> [#uses=1]
  %tmp18 = load i16 addrspace(1)* %arrayidx       ; <i16> [#uses=1]
  %conv19 = zext i16 %tmp18 to i32                ; <i32> [#uses=1]
  %tmp20 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp21 = insertelement <2 x i32> %tmp20, i32 %conv19, i32 0 ; <<2 x i32>> [#uses=1]
  store <2 x i32> %tmp21, <2 x i32>* %ccoord
  %tmp22 = load i16 addrspace(1)** %uncov_coord_in.addr ; <i16 addrspace(1)*> [#uses=1]
  %tmp23 = load i32* %idx_coord                   ; <i32> [#uses=1]
  %tmp24 = mul i32 2, %tmp23                      ; <i32> [#uses=1]
  %tmp25 = add nsw i32 %tmp24, 1                  ; <i32> [#uses=1]
  %arrayidx26 = getelementptr i16 addrspace(1)* %tmp22, i32 %tmp25 ; <i16 addrspace(1)*> [#uses=1]
  %tmp27 = load i16 addrspace(1)* %arrayidx26     ; <i16> [#uses=1]
  %conv28 = zext i16 %tmp27 to i32                ; <i32> [#uses=1]
  %tmp29 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp30 = insertelement <2 x i32> %tmp29, i32 %conv28, i32 1 ; <<2 x i32>> [#uses=1]
  store <2 x i32> %tmp30, <2 x i32>* %ccoord
  br label %do.cond

do.cond:                                          ; preds = %do.body
  %tmp31 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp32 = extractelement <2 x i32> %tmp31, i32 0 ; <i32> [#uses=1]
  %cmp33 = icmp eq i32 %tmp32, 0                  ; <i1> [#uses=1]
  br i1 %cmp33, label %do.body, label %do.exit

if.end37:                                         ; preds = %if.then38, %if.end
  %tmp75 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp76 = extractelement <2 x i32> %tmp75, i32 1 ; <i32> [#uses=1]
  %tmp77 = load i32* %ncols.addr                  ; <i32> [#uses=1]
  %tmp78 = mul i32 %tmp76, %tmp77                 ; <i32> [#uses=1]
  %tmp79 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp80 = extractelement <2 x i32> %tmp79, i32 0 ; <i32> [#uses=1]
  %tmp81 = add nsw i32 %tmp78, %tmp80             ; <i32> [#uses=1]
  store i32 %tmp81, i32* %idx_2d
  %tmp82 = load float addrspace(1)** %cov_in.addr ; <float addrspace(1)*> [#uses=1]
  %tmp83 = load i32* %idx_2d                      ; <i32> [#uses=1]
  %arrayidx84 = getelementptr float addrspace(1)* %tmp82, i32 %tmp83 ; <float addrspace(1)*> [#uses=1]
  %tmp85 = load float addrspace(1)* %arrayidx84   ; <float> [#uses=1]
  %cmp86 = fcmp olt float %tmp85, 0x3F847AE140000000 ; <i1> [#uses=1]
  br i1 %cmp86, label %if.then88, label %if.else

if.then38:                                        ; preds = %if.end
  %call39 = call i64 @random(%1* %randstate) nounwind ; <i64> [#uses=1]
  %tmp40 = load <4 x i32>* %mdim.addr             ; <<4 x i32>> [#uses=1]
  %tmp41 = extractelement <4 x i32> %tmp40, i32 2 ; <i32> [#uses=1]
  %tmp42 = load <4 x i32>* %mdim.addr             ; <<4 x i32>> [#uses=1]
  %tmp43 = extractelement <4 x i32> %tmp42, i32 0 ; <i32> [#uses=1]
  %tmp44 = sub nsw i32 %tmp41, %tmp43             ; <i32> [#uses=1]
  %conv45 = sext i32 %tmp44 to i64                ; <i64> [#uses=1]
  %tmp46 = urem i64 %call39, %conv45              ; <i64> [#uses=1]
  %conv47 = trunc i64 %tmp46 to i32               ; <i32> [#uses=1]
  %tmp48 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp49 = insertelement <2 x i32> %tmp48, i32 %conv47, i32 0 ; <<2 x i32>> [#uses=1]
  store <2 x i32> %tmp49, <2 x i32>* %ccoord
  %tmp50 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp51 = extractelement <2 x i32> %tmp50, i32 0 ; <i32> [#uses=1]
  %tmp52 = load <4 x i32>* %mdim.addr             ; <<4 x i32>> [#uses=1]
  %tmp53 = extractelement <4 x i32> %tmp52, i32 0 ; <i32> [#uses=1]
  %tmp54 = add nsw i32 %tmp51, %tmp53             ; <i32> [#uses=1]
  %tmp55 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp56 = insertelement <2 x i32> %tmp55, i32 %tmp54, i32 0 ; <<2 x i32>> [#uses=1]
  store <2 x i32> %tmp56, <2 x i32>* %ccoord
  %call57 = call i64 @random(%1* %randstate) nounwind ; <i64> [#uses=1]
  %tmp58 = load <4 x i32>* %mdim.addr             ; <<4 x i32>> [#uses=1]
  %tmp59 = extractelement <4 x i32> %tmp58, i32 3 ; <i32> [#uses=1]
  %tmp60 = load <4 x i32>* %mdim.addr             ; <<4 x i32>> [#uses=1]
  %tmp61 = extractelement <4 x i32> %tmp60, i32 1 ; <i32> [#uses=1]
  %tmp62 = sub nsw i32 %tmp59, %tmp61             ; <i32> [#uses=1]
  %conv63 = sext i32 %tmp62 to i64                ; <i64> [#uses=1]
  %tmp64 = urem i64 %call57, %conv63              ; <i64> [#uses=1]
  %conv65 = trunc i64 %tmp64 to i32               ; <i32> [#uses=1]
  %tmp66 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp67 = insertelement <2 x i32> %tmp66, i32 %conv65, i32 1 ; <<2 x i32>> [#uses=1]
  store <2 x i32> %tmp67, <2 x i32>* %ccoord
  %tmp68 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp69 = extractelement <2 x i32> %tmp68, i32 1 ; <i32> [#uses=1]
  %tmp70 = load <4 x i32>* %mdim.addr             ; <<4 x i32>> [#uses=1]
  %tmp71 = extractelement <4 x i32> %tmp70, i32 1 ; <i32> [#uses=1]
  %tmp72 = add nsw i32 %tmp69, %tmp71             ; <i32> [#uses=1]
  %tmp73 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp74 = insertelement <2 x i32> %tmp73, i32 %tmp72, i32 1 ; <<2 x i32>> [#uses=1]
  store <2 x i32> %tmp74, <2 x i32>* %ccoord
  br label %if.end37

if.end87:                                         ; preds = %if.else, %if.then88
  %tmp117 = load i16 addrspace(3)** %pblock.addr  ; <i16 addrspace(3)*> [#uses=1]
  %tmp118 = load i32* %idx_thread                 ; <i32> [#uses=1]
  %tmp119 = mul i32 2, %tmp118                    ; <i32> [#uses=1]
  %arrayidx120 = getelementptr i16 addrspace(3)* %tmp117, i32 %tmp119 ; <i16 addrspace(3)*> [#uses=1]
  %tmp121 = load i32* %tx_id                      ; <i32> [#uses=1]
  %conv122 = trunc i32 %tmp121 to i16             ; <i16> [#uses=1]
  store i16 %conv122, i16 addrspace(3)* %arrayidx120
  %tmp123 = load i16 addrspace(3)** %pblock.addr  ; <i16 addrspace(3)*> [#uses=1]
  %tmp124 = load i32* %idx_thread                 ; <i32> [#uses=1]
  %tmp125 = mul i32 2, %tmp124                    ; <i32> [#uses=1]
  %tmp126 = add nsw i32 %tmp125, 1                ; <i32> [#uses=1]
  %arrayidx127 = getelementptr i16 addrspace(3)* %tmp123, i32 %tmp126 ; <i16 addrspace(3)*> [#uses=1]
  %tmp128 = load float* %tx_new_pwr               ; <float> [#uses=1]
  %tmp129 = load i32 addrspace(1)** %tx_pwr.addr  ; <i32 addrspace(1)*> [#uses=1]
  %tmp130 = load i32* %tx_id                      ; <i32> [#uses=1]
  %arrayidx131 = getelementptr i32 addrspace(1)* %tmp129, i32 %tmp130 ; <i32 addrspace(1)*> [#uses=1]
  %tmp132 = load i32 addrspace(1)* %arrayidx131   ; <i32> [#uses=1]
  %conv133 = sitofp i32 %tmp132 to float          ; <float> [#uses=1]
  %tmp134 = fmul float %tmp128, %conv133          ; <float> [#uses=1]
  %conv135 = fptoui float %tmp134 to i16          ; <i16> [#uses=1]
  store i16 %conv135, i16 addrspace(3)* %arrayidx127
  call void @barrier(i32 0, i32 1) nounwind
  %tmp136 = load i32* %idx_thread                 ; <i32> [#uses=1]
  %cmp137 = icmp eq i32 %tmp136, 0                ; <i1> [#uses=1]
  br i1 %cmp137, label %if.then139, label %if.end138

if.then88:                                        ; preds = %if.end37
  store <2 x float> <float -1.000000e+00, float 0xC0C387F340000000>, <2 x float>* %tmp89
  %tmp90 = load <2 x float>* %tmp89               ; <<2 x float>> [#uses=1]
  store <2 x float> %tmp90, <2 x float>* %max_signal
  %call91 = call i64 @random(%1* %randstate) nounwind ; <i64> [#uses=1]
  %tmp92 = load i32* %ntx.addr                    ; <i32> [#uses=1]
  %conv93 = sext i32 %tmp92 to i64                ; <i64> [#uses=1]
  %tmp94 = urem i64 %call91, %conv93              ; <i64> [#uses=1]
  %conv95 = uitofp i64 %tmp94 to float            ; <float> [#uses=1]
  %tmp96 = load <2 x float>* %max_signal          ; <<2 x float>> [#uses=1]
  %tmp97 = insertelement <2 x float> %tmp96, float %conv95, i32 0 ; <<2 x float>> [#uses=1]
  store <2 x float> %tmp97, <2 x float>* %max_signal
  %tmp98 = load <2 x float>* %max_signal          ; <<2 x float>> [#uses=1]
  %tmp99 = extractelement <2 x float> %tmp98, i32 0 ; <float> [#uses=1]
  %conv100 = fptosi float %tmp99 to i32           ; <i32> [#uses=1]
  store i32 %conv100, i32* %tx_id
  store float 0x3FA99999A0000000, float* %tx_new_pwr
  %tmp101 = load float* %tx_new_pwr               ; <float> [#uses=1]
  %call102 = call float @__pow_f32(float 1.000000e+01, float %tmp101) nounwind ; <float> [#uses=1]
  store float %call102, float* %tx_new_pwr
  br label %if.end87

if.else:                                          ; preds = %if.end37
  store <2 x float> <float -1.000000e+00, float 0x40C387F340000000>, <2 x float>* %tmp103
  %tmp104 = load <2 x float>* %tmp103             ; <<2 x float>> [#uses=1]
  store <2 x float> %tmp104, <2 x float>* %min_signal
  %call105 = call i64 @random(%1* %randstate) nounwind ; <i64> [#uses=1]
  %tmp106 = load i32* %ntx.addr                   ; <i32> [#uses=1]
  %conv107 = sext i32 %tmp106 to i64              ; <i64> [#uses=1]
  %tmp108 = urem i64 %call105, %conv107           ; <i64> [#uses=1]
  %conv109 = uitofp i64 %tmp108 to float          ; <float> [#uses=1]
  %tmp110 = load <2 x float>* %min_signal         ; <<2 x float>> [#uses=1]
  %tmp111 = insertelement <2 x float> %tmp110, float %conv109, i32 0 ; <<2 x float>> [#uses=1]
  store <2 x float> %tmp111, <2 x float>* %min_signal
  %tmp112 = load <2 x float>* %min_signal         ; <<2 x float>> [#uses=1]
  %tmp113 = extractelement <2 x float> %tmp112, i32 0 ; <float> [#uses=1]
  %conv114 = fptosi float %tmp113 to i32          ; <i32> [#uses=1]
  store i32 %conv114, i32* %tx_id
  store float 0xBF847AE140000000, float* %tx_new_pwr
  %tmp115 = load float* %tx_new_pwr               ; <float> [#uses=1]
  %call116 = call float @__pow_f32(float 1.000000e+01, float %tmp115) nounwind ; <float> [#uses=1]
  store float %call116, float* %tx_new_pwr
  br label %if.end87

if.end138:                                        ; preds = %for.exit, %if.end87
  br label %return

if.then139:                                       ; preds = %if.end87
  store i32 0, i32* %tx
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.then139
  %tmp140 = load i32* %tx                         ; <i32> [#uses=1]
  %call141 = call i32 @get_local_size(i32 0) nounwind ; <i32> [#uses=1]
  %cmp142 = icmp ult i32 %tmp140, %call141        ; <i1> [#uses=1]
  br i1 %cmp142, label %for.body, label %for.exit

for.exit:                                         ; preds = %for.cond
  br label %if.end138

for.body:                                         ; preds = %for.cond
  %tmp143 = load i16 addrspace(3)** %pblock.addr  ; <i16 addrspace(3)*> [#uses=1]
  %tmp144 = load i32* %tx                         ; <i32> [#uses=1]
  %tmp145 = mul i32 2, %tmp144                    ; <i32> [#uses=1]
  %arrayidx146 = getelementptr i16 addrspace(3)* %tmp143, i32 %tmp145 ; <i16 addrspace(3)*> [#uses=1]
  %tmp147 = load i16 addrspace(3)* %arrayidx146   ; <i16> [#uses=1]
  %conv148 = zext i16 %tmp147 to i32              ; <i32> [#uses=1]
  store i32 %conv148, i32* %tx_id
  %tmp149 = load i16 addrspace(3)** %pblock.addr  ; <i16 addrspace(3)*> [#uses=1]
  %tmp150 = load i32* %tx                         ; <i32> [#uses=1]
  %tmp151 = mul i32 2, %tmp150                    ; <i32> [#uses=1]
  %tmp152 = add nsw i32 %tmp151, 1                ; <i32> [#uses=1]
  %arrayidx153 = getelementptr i16 addrspace(3)* %tmp149, i32 %tmp152 ; <i16 addrspace(3)*> [#uses=1]
  %tmp154 = load i16 addrspace(3)* %arrayidx153   ; <i16> [#uses=1]
  %conv155 = zext i16 %tmp154 to i32              ; <i32> [#uses=1]
  store i32 %conv155, i32* %new_pwr
  store i32 0, i32* %ty
  br label %for.cond156

for.inc:                                          ; preds = %if.end191
  %tmp197 = load i32* %tx                         ; <i32> [#uses=1]
  %tmp198 = add nsw i32 %tmp197, 1                ; <i32> [#uses=1]
  store i32 %tmp198, i32* %tx
  br label %for.cond

for.cond156:                                      ; preds = %for.inc162, %for.body
  %tmp158 = load i32* %ty                         ; <i32> [#uses=1]
  %call159 = call i32 @get_local_size(i32 0) nounwind ; <i32> [#uses=1]
  %cmp160 = icmp ult i32 %tmp158, %call159        ; <i1> [#uses=1]
  br i1 %cmp160, label %for.body161, label %for.exit157

for.exit157:                                      ; preds = %for.cond156
  br label %__T46401280

for.body161:                                      ; preds = %for.cond156
  %tmp163 = load i32* %tx                         ; <i32> [#uses=1]
  %tmp164 = load i32* %ty                         ; <i32> [#uses=1]
  %cmp165 = icmp ne i32 %tmp163, %tmp164          ; <i1> [#uses=1]
  br i1 %cmp165, label %land.rhs, label %land.end

for.inc162:                                       ; preds = %if.end174
  %tmp187 = load i32* %ty                         ; <i32> [#uses=1]
  %tmp188 = add nsw i32 %tmp187, 1                ; <i32> [#uses=1]
  store i32 %tmp188, i32* %ty
  br label %for.cond156

land.end:                                         ; preds = %land.rhs, %for.body161
  %land.cond = phi i1 [ false, %for.body161 ], [ %cmp173, %land.rhs ] ; <i1> [#uses=1]
  br i1 %land.cond, label %if.then175, label %if.end174

land.rhs:                                         ; preds = %for.body161
  %tmp166 = load i16 addrspace(3)** %pblock.addr  ; <i16 addrspace(3)*> [#uses=1]
  %tmp167 = load i32* %ty                         ; <i32> [#uses=1]
  %tmp168 = mul i32 2, %tmp167                    ; <i32> [#uses=1]
  %arrayidx169 = getelementptr i16 addrspace(3)* %tmp166, i32 %tmp168 ; <i16 addrspace(3)*> [#uses=1]
  %tmp170 = load i16 addrspace(3)* %arrayidx169   ; <i16> [#uses=1]
  %conv171 = zext i16 %tmp170 to i32              ; <i32> [#uses=1]
  %tmp172 = load i32* %tx_id                      ; <i32> [#uses=1]
  %cmp173 = icmp eq i32 %conv171, %tmp172         ; <i1> [#uses=1]
  br label %land.end

if.end174:                                        ; preds = %if.end185, %land.end
  br label %for.inc162

if.then175:                                       ; preds = %land.end
  %tmp176 = load i16 addrspace(3)** %pblock.addr  ; <i16 addrspace(3)*> [#uses=1]
  %tmp177 = load i32* %ty                         ; <i32> [#uses=1]
  %tmp178 = mul i32 2, %tmp177                    ; <i32> [#uses=1]
  %tmp179 = add nsw i32 %tmp178, 1                ; <i32> [#uses=1]
  %arrayidx180 = getelementptr i16 addrspace(3)* %tmp176, i32 %tmp179 ; <i16 addrspace(3)*> [#uses=1]
  %tmp181 = load i16 addrspace(3)* %arrayidx180   ; <i16> [#uses=1]
  %conv182 = zext i16 %tmp181 to i32              ; <i32> [#uses=1]
  %tmp183 = load i32* %new_pwr                    ; <i32> [#uses=1]
  %cmp184 = icmp sgt i32 %conv182, %tmp183        ; <i1> [#uses=1]
  br i1 %cmp184, label %if.then186, label %if.end185

if.end185:                                        ; preds = %if.then175
  br label %if.end174

if.then186:                                       ; preds = %if.then175
  store i32 -1, i32* %new_pwr
  br label %__T46401280

__T46401280:                                      ; preds = %for.exit157, %if.then186
  %tmp189 = load i32* %new_pwr                    ; <i32> [#uses=1]
  %cmp190 = icmp ne i32 %tmp189, -1               ; <i1> [#uses=1]
  br i1 %cmp190, label %if.then192, label %if.end191

if.end191:                                        ; preds = %if.then192, %__T46401280
  br label %for.inc

if.then192:                                       ; preds = %__T46401280
  %tmp193 = load i32 addrspace(1)** %tx_pwr.addr  ; <i32 addrspace(1)*> [#uses=1]
  %tmp194 = load i32* %tx_id                      ; <i32> [#uses=1]
  %arrayidx195 = getelementptr i32 addrspace(1)* %tmp193, i32 %tmp194 ; <i32 addrspace(1)*> [#uses=1]
  %tmp196 = load i32* %new_pwr                    ; <i32> [#uses=1]
  store i32 %tmp196, i32 addrspace(1)* %arrayidx195
  br label %if.end191
}

declare i32 @get_local_id(i32) nounwind

declare float @__pow_f32(float, float) nounwind

declare void @barrier(i32, i32) nounwind

declare i32 @get_local_size(i32) nounwind

define void @__OpenCL_coverage_kern_kernel(i32 %ntx, i32 %ncols, i8 addrspace(1)* %pl_in, <4 x i32> addrspace(1)* %offsets_in, float addrspace(1)* %qrm_in, i32 addrspace(1)* %tx_pwr, float addrspace(1)* %cov_out, i16 addrspace(1)* %cov_ctr_out, i16 addrspace(1)* %cov_coord_out, i32 %lmem_ctr_offset, i32 %lmem_coord_offset, float addrspace(3)* %pblock) nounwind {
entry:
  %ntx.addr = alloca i32, align 4                 ; <i32*> [#uses=2]
  %ncols.addr = alloca i32, align 4               ; <i32*> [#uses=2]
  %pl_in.addr = alloca i8 addrspace(1)*, align 4  ; <i8 addrspace(1)**> [#uses=3]
  %offsets_in.addr = alloca <4 x i32> addrspace(1)*, align 4 ; <<4 x i32> addrspace(1)**> [#uses=21]
  %qrm_in.addr = alloca float addrspace(1)*, align 4 ; <float addrspace(1)**> [#uses=3]
  %tx_pwr.addr = alloca i32 addrspace(1)*, align 4 ; <i32 addrspace(1)**> [#uses=3]
  %cov_out.addr = alloca float addrspace(1)*, align 4 ; <float addrspace(1)**> [#uses=2]
  %cov_ctr_out.addr = alloca i16 addrspace(1)*, align 4 ; <i16 addrspace(1)**> [#uses=2]
  %cov_coord_out.addr = alloca i16 addrspace(1)*, align 4 ; <i16 addrspace(1)**> [#uses=3]
  %lmem_ctr_offset.addr = alloca i32, align 4     ; <i32*> [#uses=5]
  %lmem_coord_offset.addr = alloca i32, align 4   ; <i32*> [#uses=3]
  %pblock.addr = alloca float addrspace(3)*, align 4 ; <float addrspace(3)**> [#uses=13]
  %tmp = alloca <2 x i32>, align 8                ; <<2 x i32>*> [#uses=5]
  %tx = alloca i32, align 4                       ; <i32*> [#uses=24]
  %ccoord = alloca <2 x i32>, align 8             ; <<2 x i32>*> [#uses=17]
  %idx_2d = alloca i32, align 4                   ; <i32*> [#uses=4]
  %idx_local = alloca i32, align 4                ; <i32*> [#uses=11]
  %idx_pl = alloca i32, align 4                   ; <i32*> [#uses=4]
  %pl_value = alloca float, align 4               ; <float*> [#uses=6]
  %idx_pl172 = alloca i32, align 4                ; <i32*> [#uses=6]
  %pl_value212 = alloca float, align 4            ; <float*> [#uses=9]
  %cov_ctr = alloca i32, align 4                  ; <i32*> [#uses=4]
  %tmp286 = alloca <2 x i32>, align 8             ; <<2 x i32>*> [#uses=2]
  %cov_coord = alloca <2 x i32>, align 8          ; <<2 x i32>*> [#uses=4]
  %idx_reduced = alloca i32, align 4              ; <i32*> [#uses=8]
  %local_size = alloca i32, align 4               ; <i32*> [#uses=2]
  %tmp317 = alloca <2 x i32>, align 8             ; <<2 x i32>*> [#uses=5]
  store i32 %ntx, i32* %ntx.addr
  store i32 %ncols, i32* %ncols.addr
  store i8 addrspace(1)* %pl_in, i8 addrspace(1)** %pl_in.addr
  store <4 x i32> addrspace(1)* %offsets_in, <4 x i32> addrspace(1)** %offsets_in.addr
  store float addrspace(1)* %qrm_in, float addrspace(1)** %qrm_in.addr
  store i32 addrspace(1)* %tx_pwr, i32 addrspace(1)** %tx_pwr.addr
  store float addrspace(1)* %cov_out, float addrspace(1)** %cov_out.addr
  store i16 addrspace(1)* %cov_ctr_out, i16 addrspace(1)** %cov_ctr_out.addr
  store i16 addrspace(1)* %cov_coord_out, i16 addrspace(1)** %cov_coord_out.addr
  store i32 %lmem_ctr_offset, i32* %lmem_ctr_offset.addr
  store i32 %lmem_coord_offset, i32* %lmem_coord_offset.addr
  store float addrspace(3)* %pblock, float addrspace(3)** %pblock.addr
  %call = call i32 @get_global_id(i32 0) nounwind ; <i32> [#uses=1]
  %tmp1 = load <2 x i32>* %tmp                    ; <<2 x i32>> [#uses=1]
  %tmp2 = insertelement <2 x i32> %tmp1, i32 %call, i32 0 ; <<2 x i32>> [#uses=1]
  store <2 x i32> %tmp2, <2 x i32>* %tmp
  %call3 = call i32 @get_global_id(i32 1) nounwind ; <i32> [#uses=1]
  %tmp4 = load <2 x i32>* %tmp                    ; <<2 x i32>> [#uses=1]
  %tmp5 = insertelement <2 x i32> %tmp4, i32 %call3, i32 1 ; <<2 x i32>> [#uses=1]
  store <2 x i32> %tmp5, <2 x i32>* %tmp
  %tmp6 = load <2 x i32>* %tmp                    ; <<2 x i32>> [#uses=1]
  store <2 x i32> %tmp6, <2 x i32>* %ccoord
  %tmp7 = load <2 x i32>* %ccoord                 ; <<2 x i32>> [#uses=1]
  %tmp8 = extractelement <2 x i32> %tmp7, i32 1   ; <i32> [#uses=1]
  %tmp9 = load i32* %ncols.addr                   ; <i32> [#uses=1]
  %tmp10 = mul i32 %tmp8, %tmp9                   ; <i32> [#uses=1]
  %tmp11 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp12 = extractelement <2 x i32> %tmp11, i32 0 ; <i32> [#uses=1]
  %tmp13 = add nsw i32 %tmp10, %tmp12             ; <i32> [#uses=1]
  store i32 %tmp13, i32* %idx_2d
  %call14 = call i32 @get_local_id(i32 1) nounwind ; <i32> [#uses=1]
  %call15 = call i32 @get_local_size(i32 0) nounwind ; <i32> [#uses=1]
  %tmp16 = mul i32 %call14, %call15               ; <i32> [#uses=1]
  %call17 = call i32 @get_local_id(i32 0) nounwind ; <i32> [#uses=1]
  %tmp18 = add i32 %tmp16, %call17                ; <i32> [#uses=1]
  store i32 %tmp18, i32* %idx_local
  %tmp19 = load float addrspace(3)** %pblock.addr ; <float addrspace(3)*> [#uses=1]
  %tmp20 = load i32* %idx_local                   ; <i32> [#uses=1]
  %arrayidx = getelementptr float addrspace(3)* %tmp19, i32 %tmp20 ; <float addrspace(3)*> [#uses=1]
  store float 0x7FF8000000000000, float addrspace(3)* %arrayidx
  %tmp21 = load float addrspace(3)** %pblock.addr ; <float addrspace(3)*> [#uses=1]
  %tmp22 = load i32* %lmem_ctr_offset.addr        ; <i32> [#uses=1]
  %tmp23 = load i32* %idx_local                   ; <i32> [#uses=1]
  %tmp24 = add i32 %tmp22, %tmp23                 ; <i32> [#uses=1]
  %arrayidx25 = getelementptr float addrspace(3)* %tmp21, i32 %tmp24 ; <float addrspace(3)*> [#uses=1]
  store float 0.000000e+00, float addrspace(3)* %arrayidx25
  %tmp26 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp27 = extractelement <2 x i32> %tmp26, i32 0 ; <i32> [#uses=1]
  %tmp28 = load <4 x i32> addrspace(1)** %offsets_in.addr ; <<4 x i32> addrspace(1)*> [#uses=1]
  %arrayidx29 = getelementptr <4 x i32> addrspace(1)* %tmp28, i32 0 ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp30 = load <4 x i32> addrspace(1)* %arrayidx29 ; <<4 x i32>> [#uses=1]
  %tmp31 = extractelement <4 x i32> %tmp30, i32 0 ; <i32> [#uses=1]
  %cmp = icmp sge i32 %tmp27, %tmp31              ; <i1> [#uses=1]
  br i1 %cmp, label %land.rhs, label %land.end

return:                                           ; preds = %if.end284
  ret void

land.end:                                         ; preds = %land.rhs, %entry
  %land.cond = phi i1 [ false, %entry ], [ %cmp43, %land.rhs ] ; <i1> [#uses=1]
  br i1 %land.cond, label %if.then, label %if.end

land.rhs:                                         ; preds = %entry
  %tmp32 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp33 = extractelement <2 x i32> %tmp32, i32 0 ; <i32> [#uses=1]
  %tmp34 = load <4 x i32> addrspace(1)** %offsets_in.addr ; <<4 x i32> addrspace(1)*> [#uses=1]
  %arrayidx35 = getelementptr <4 x i32> addrspace(1)* %tmp34, i32 0 ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp36 = load <4 x i32> addrspace(1)* %arrayidx35 ; <<4 x i32>> [#uses=1]
  %tmp37 = extractelement <4 x i32> %tmp36, i32 0 ; <i32> [#uses=1]
  %tmp38 = sub nsw i32 %tmp33, %tmp37             ; <i32> [#uses=1]
  %tmp39 = load <4 x i32> addrspace(1)** %offsets_in.addr ; <<4 x i32> addrspace(1)*> [#uses=1]
  %arrayidx40 = getelementptr <4 x i32> addrspace(1)* %tmp39, i32 0 ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp41 = load <4 x i32> addrspace(1)* %arrayidx40 ; <<4 x i32>> [#uses=1]
  %tmp42 = extractelement <4 x i32> %tmp41, i32 2 ; <i32> [#uses=1]
  %cmp43 = icmp slt i32 %tmp38, %tmp42            ; <i1> [#uses=1]
  br label %land.end

if.end:                                           ; preds = %if.end66, %land.end
  store i32 1, i32* %tx
  br label %for.cond

if.then:                                          ; preds = %land.end
  %tmp44 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp45 = extractelement <2 x i32> %tmp44, i32 1 ; <i32> [#uses=1]
  %tmp46 = load <4 x i32> addrspace(1)** %offsets_in.addr ; <<4 x i32> addrspace(1)*> [#uses=1]
  %arrayidx47 = getelementptr <4 x i32> addrspace(1)* %tmp46, i32 0 ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp48 = load <4 x i32> addrspace(1)* %arrayidx47 ; <<4 x i32>> [#uses=1]
  %tmp49 = extractelement <4 x i32> %tmp48, i32 1 ; <i32> [#uses=1]
  %cmp50 = icmp sge i32 %tmp45, %tmp49            ; <i1> [#uses=1]
  br i1 %cmp50, label %land.rhs52, label %land.end51

land.end51:                                       ; preds = %land.rhs52, %if.then
  %land.cond65 = phi i1 [ false, %if.then ], [ %cmp64, %land.rhs52 ] ; <i1> [#uses=1]
  br i1 %land.cond65, label %if.then67, label %if.end66

land.rhs52:                                       ; preds = %if.then
  %tmp53 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp54 = extractelement <2 x i32> %tmp53, i32 1 ; <i32> [#uses=1]
  %tmp55 = load <4 x i32> addrspace(1)** %offsets_in.addr ; <<4 x i32> addrspace(1)*> [#uses=1]
  %arrayidx56 = getelementptr <4 x i32> addrspace(1)* %tmp55, i32 0 ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp57 = load <4 x i32> addrspace(1)* %arrayidx56 ; <<4 x i32>> [#uses=1]
  %tmp58 = extractelement <4 x i32> %tmp57, i32 1 ; <i32> [#uses=1]
  %tmp59 = sub nsw i32 %tmp54, %tmp58             ; <i32> [#uses=1]
  %tmp60 = load <4 x i32> addrspace(1)** %offsets_in.addr ; <<4 x i32> addrspace(1)*> [#uses=1]
  %arrayidx61 = getelementptr <4 x i32> addrspace(1)* %tmp60, i32 0 ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp62 = load <4 x i32> addrspace(1)* %arrayidx61 ; <<4 x i32>> [#uses=1]
  %tmp63 = extractelement <4 x i32> %tmp62, i32 3 ; <i32> [#uses=1]
  %cmp64 = icmp slt i32 %tmp59, %tmp63            ; <i1> [#uses=1]
  br label %land.end51

if.end66:                                         ; preds = %if.end95, %land.end51
  br label %if.end

if.then67:                                        ; preds = %land.end51
  %tmp68 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp69 = extractelement <2 x i32> %tmp68, i32 1 ; <i32> [#uses=1]
  %tmp70 = load <4 x i32> addrspace(1)** %offsets_in.addr ; <<4 x i32> addrspace(1)*> [#uses=1]
  %arrayidx71 = getelementptr <4 x i32> addrspace(1)* %tmp70, i32 0 ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp72 = load <4 x i32> addrspace(1)* %arrayidx71 ; <<4 x i32>> [#uses=1]
  %tmp73 = extractelement <4 x i32> %tmp72, i32 1 ; <i32> [#uses=1]
  %tmp74 = sub nsw i32 %tmp69, %tmp73             ; <i32> [#uses=1]
  %tmp75 = load <4 x i32> addrspace(1)** %offsets_in.addr ; <<4 x i32> addrspace(1)*> [#uses=1]
  %arrayidx76 = getelementptr <4 x i32> addrspace(1)* %tmp75, i32 0 ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp77 = load <4 x i32> addrspace(1)* %arrayidx76 ; <<4 x i32>> [#uses=1]
  %tmp78 = extractelement <4 x i32> %tmp77, i32 2 ; <i32> [#uses=1]
  %tmp79 = mul i32 %tmp74, %tmp78                 ; <i32> [#uses=1]
  store i32 %tmp79, i32* %idx_pl
  %tmp80 = load i32* %idx_pl                      ; <i32> [#uses=1]
  %tmp81 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp82 = extractelement <2 x i32> %tmp81, i32 0 ; <i32> [#uses=1]
  %tmp83 = load <4 x i32> addrspace(1)** %offsets_in.addr ; <<4 x i32> addrspace(1)*> [#uses=1]
  %arrayidx84 = getelementptr <4 x i32> addrspace(1)* %tmp83, i32 0 ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp85 = load <4 x i32> addrspace(1)* %arrayidx84 ; <<4 x i32>> [#uses=1]
  %tmp86 = extractelement <4 x i32> %tmp85, i32 0 ; <i32> [#uses=1]
  %tmp87 = sub nsw i32 %tmp82, %tmp86             ; <i32> [#uses=1]
  %tmp88 = add nsw i32 %tmp80, %tmp87             ; <i32> [#uses=1]
  store i32 %tmp88, i32* %idx_pl
  %tmp89 = load i8 addrspace(1)** %pl_in.addr     ; <i8 addrspace(1)*> [#uses=1]
  %tmp90 = load i32* %idx_pl                      ; <i32> [#uses=1]
  %arrayidx91 = getelementptr i8 addrspace(1)* %tmp89, i32 %tmp90 ; <i8 addrspace(1)*> [#uses=1]
  %tmp92 = load i8 addrspace(1)* %arrayidx91      ; <i8> [#uses=1]
  %conv = uitofp i8 %tmp92 to float               ; <float> [#uses=1]
  store float %conv, float* %pl_value
  %tmp93 = load float* %pl_value                  ; <float> [#uses=1]
  %cmp94 = fcmp ogt float %tmp93, 2.550000e+02    ; <i1> [#uses=1]
  br i1 %cmp94, label %if.then96, label %if.end95

if.end95:                                         ; preds = %if.then96, %if.then67
  %tmp97 = load float* %pl_value                  ; <float> [#uses=1]
  %tmp98 = fdiv float %tmp97, 2.550000e+02        ; <float> [#uses=1]
  %tmp99 = fsub float 1.000000e+00, %tmp98        ; <float> [#uses=1]
  store float %tmp99, float* %pl_value
  %tmp100 = load float addrspace(3)** %pblock.addr ; <float addrspace(3)*> [#uses=1]
  %tmp101 = load i32* %idx_local                  ; <i32> [#uses=1]
  %arrayidx102 = getelementptr float addrspace(3)* %tmp100, i32 %tmp101 ; <float addrspace(3)*> [#uses=1]
  %tmp103 = load i32 addrspace(1)** %tx_pwr.addr  ; <i32 addrspace(1)*> [#uses=1]
  %arrayidx104 = getelementptr i32 addrspace(1)* %tmp103, i32 0 ; <i32 addrspace(1)*> [#uses=1]
  %tmp105 = load i32 addrspace(1)* %arrayidx104   ; <i32> [#uses=1]
  %conv106 = sitofp i32 %tmp105 to float          ; <float> [#uses=1]
  %tmp107 = fdiv float %conv106, 1.000000e+03     ; <float> [#uses=1]
  %tmp108 = load float* %pl_value                 ; <float> [#uses=1]
  %tmp109 = fmul float %tmp107, %tmp108           ; <float> [#uses=1]
  %tmp110 = load float addrspace(1)** %qrm_in.addr ; <float addrspace(1)*> [#uses=1]
  %tmp111 = load i32* %idx_2d                     ; <i32> [#uses=1]
  %arrayidx112 = getelementptr float addrspace(1)* %tmp110, i32 %tmp111 ; <float addrspace(1)*> [#uses=1]
  %tmp113 = load float addrspace(1)* %arrayidx112 ; <float> [#uses=1]
  %tmp114 = fdiv float %tmp109, %tmp113           ; <float> [#uses=1]
  store float %tmp114, float addrspace(3)* %arrayidx102
  br label %if.end66

if.then96:                                        ; preds = %if.then67
  store float 2.550000e+02, float* %pl_value
  br label %if.end95

for.cond:                                         ; preds = %for.inc, %if.end
  %tmp115 = load i32* %tx                         ; <i32> [#uses=1]
  %tmp116 = load i32* %ntx.addr                   ; <i32> [#uses=1]
  %cmp117 = icmp slt i32 %tmp115, %tmp116         ; <i1> [#uses=1]
  br i1 %cmp117, label %for.body, label %for.exit

for.exit:                                         ; preds = %for.cond
  %tmp252 = load float addrspace(3)** %pblock.addr ; <float addrspace(3)*> [#uses=1]
  %tmp253 = load i32* %idx_local                  ; <i32> [#uses=1]
  %arrayidx254 = getelementptr float addrspace(3)* %tmp252, i32 %tmp253 ; <float addrspace(3)*> [#uses=1]
  %tmp255 = load float addrspace(3)* %arrayidx254 ; <float> [#uses=1]
  %cmp256 = fcmp olt float %tmp255, 0x3F847AE140000000 ; <i1> [#uses=1]
  br i1 %cmp256, label %if.then258, label %if.end257

for.body:                                         ; preds = %for.cond
  %tmp118 = load <2 x i32>* %ccoord               ; <<2 x i32>> [#uses=1]
  %tmp119 = extractelement <2 x i32> %tmp118, i32 0 ; <i32> [#uses=1]
  %tmp120 = load <4 x i32> addrspace(1)** %offsets_in.addr ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp121 = load i32* %tx                         ; <i32> [#uses=1]
  %arrayidx122 = getelementptr <4 x i32> addrspace(1)* %tmp120, i32 %tmp121 ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp123 = load <4 x i32> addrspace(1)* %arrayidx122 ; <<4 x i32>> [#uses=1]
  %tmp124 = extractelement <4 x i32> %tmp123, i32 0 ; <i32> [#uses=1]
  %cmp125 = icmp sge i32 %tmp119, %tmp124         ; <i1> [#uses=1]
  br i1 %cmp125, label %land.rhs127, label %land.end126

for.inc:                                          ; preds = %if.end143
  %tmp250 = load i32* %tx                         ; <i32> [#uses=1]
  %tmp251 = add nsw i32 %tmp250, 1                ; <i32> [#uses=1]
  store i32 %tmp251, i32* %tx
  br label %for.cond

land.end126:                                      ; preds = %land.rhs127, %for.body
  %land.cond142 = phi i1 [ false, %for.body ], [ %cmp141, %land.rhs127 ] ; <i1> [#uses=1]
  br i1 %land.cond142, label %if.then144, label %if.end143

land.rhs127:                                      ; preds = %for.body
  %tmp128 = load <2 x i32>* %ccoord               ; <<2 x i32>> [#uses=1]
  %tmp129 = extractelement <2 x i32> %tmp128, i32 0 ; <i32> [#uses=1]
  %tmp130 = load <4 x i32> addrspace(1)** %offsets_in.addr ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp131 = load i32* %tx                         ; <i32> [#uses=1]
  %arrayidx132 = getelementptr <4 x i32> addrspace(1)* %tmp130, i32 %tmp131 ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp133 = load <4 x i32> addrspace(1)* %arrayidx132 ; <<4 x i32>> [#uses=1]
  %tmp134 = extractelement <4 x i32> %tmp133, i32 0 ; <i32> [#uses=1]
  %tmp135 = sub nsw i32 %tmp129, %tmp134          ; <i32> [#uses=1]
  %tmp136 = load <4 x i32> addrspace(1)** %offsets_in.addr ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp137 = load i32* %tx                         ; <i32> [#uses=1]
  %arrayidx138 = getelementptr <4 x i32> addrspace(1)* %tmp136, i32 %tmp137 ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp139 = load <4 x i32> addrspace(1)* %arrayidx138 ; <<4 x i32>> [#uses=1]
  %tmp140 = extractelement <4 x i32> %tmp139, i32 2 ; <i32> [#uses=1]
  %cmp141 = icmp slt i32 %tmp135, %tmp140         ; <i1> [#uses=1]
  br label %land.end126

if.end143:                                        ; preds = %if.end170, %land.end126
  br label %for.inc

if.then144:                                       ; preds = %land.end126
  %tmp145 = load <2 x i32>* %ccoord               ; <<2 x i32>> [#uses=1]
  %tmp146 = extractelement <2 x i32> %tmp145, i32 1 ; <i32> [#uses=1]
  %tmp147 = load <4 x i32> addrspace(1)** %offsets_in.addr ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp148 = load i32* %tx                         ; <i32> [#uses=1]
  %arrayidx149 = getelementptr <4 x i32> addrspace(1)* %tmp147, i32 %tmp148 ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp150 = load <4 x i32> addrspace(1)* %arrayidx149 ; <<4 x i32>> [#uses=1]
  %tmp151 = extractelement <4 x i32> %tmp150, i32 1 ; <i32> [#uses=1]
  %cmp152 = icmp sge i32 %tmp146, %tmp151         ; <i1> [#uses=1]
  br i1 %cmp152, label %land.rhs154, label %land.end153

land.end153:                                      ; preds = %land.rhs154, %if.then144
  %land.cond169 = phi i1 [ false, %if.then144 ], [ %cmp168, %land.rhs154 ] ; <i1> [#uses=1]
  br i1 %land.cond169, label %if.then171, label %if.end170

land.rhs154:                                      ; preds = %if.then144
  %tmp155 = load <2 x i32>* %ccoord               ; <<2 x i32>> [#uses=1]
  %tmp156 = extractelement <2 x i32> %tmp155, i32 1 ; <i32> [#uses=1]
  %tmp157 = load <4 x i32> addrspace(1)** %offsets_in.addr ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp158 = load i32* %tx                         ; <i32> [#uses=1]
  %arrayidx159 = getelementptr <4 x i32> addrspace(1)* %tmp157, i32 %tmp158 ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp160 = load <4 x i32> addrspace(1)* %arrayidx159 ; <<4 x i32>> [#uses=1]
  %tmp161 = extractelement <4 x i32> %tmp160, i32 1 ; <i32> [#uses=1]
  %tmp162 = sub nsw i32 %tmp156, %tmp161          ; <i32> [#uses=1]
  %tmp163 = load <4 x i32> addrspace(1)** %offsets_in.addr ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp164 = load i32* %tx                         ; <i32> [#uses=1]
  %arrayidx165 = getelementptr <4 x i32> addrspace(1)* %tmp163, i32 %tmp164 ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp166 = load <4 x i32> addrspace(1)* %arrayidx165 ; <<4 x i32>> [#uses=1]
  %tmp167 = extractelement <4 x i32> %tmp166, i32 3 ; <i32> [#uses=1]
  %cmp168 = icmp slt i32 %tmp162, %tmp167         ; <i1> [#uses=1]
  br label %land.end153

if.end170:                                        ; preds = %if.end244, %land.end153
  br label %if.end143

if.then171:                                       ; preds = %land.end153
  %tmp173 = load <4 x i32> addrspace(1)** %offsets_in.addr ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp174 = load i32* %tx                         ; <i32> [#uses=1]
  %arrayidx175 = getelementptr <4 x i32> addrspace(1)* %tmp173, i32 %tmp174 ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp176 = load <4 x i32> addrspace(1)* %arrayidx175 ; <<4 x i32>> [#uses=1]
  %tmp177 = extractelement <4 x i32> %tmp176, i32 2 ; <i32> [#uses=1]
  %tmp178 = load <4 x i32> addrspace(1)** %offsets_in.addr ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp179 = load i32* %tx                         ; <i32> [#uses=1]
  %arrayidx180 = getelementptr <4 x i32> addrspace(1)* %tmp178, i32 %tmp179 ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp181 = load <4 x i32> addrspace(1)* %arrayidx180 ; <<4 x i32>> [#uses=1]
  %tmp182 = extractelement <4 x i32> %tmp181, i32 3 ; <i32> [#uses=1]
  %tmp183 = mul i32 %tmp177, %tmp182              ; <i32> [#uses=1]
  %tmp184 = load i32* %tx                         ; <i32> [#uses=1]
  %tmp185 = mul i32 %tmp183, %tmp184              ; <i32> [#uses=1]
  store i32 %tmp185, i32* %idx_pl172
  %tmp186 = load i32* %idx_pl172                  ; <i32> [#uses=1]
  %tmp187 = load <2 x i32>* %ccoord               ; <<2 x i32>> [#uses=1]
  %tmp188 = extractelement <2 x i32> %tmp187, i32 1 ; <i32> [#uses=1]
  %tmp189 = load <4 x i32> addrspace(1)** %offsets_in.addr ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp190 = load i32* %tx                         ; <i32> [#uses=1]
  %arrayidx191 = getelementptr <4 x i32> addrspace(1)* %tmp189, i32 %tmp190 ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp192 = load <4 x i32> addrspace(1)* %arrayidx191 ; <<4 x i32>> [#uses=1]
  %tmp193 = extractelement <4 x i32> %tmp192, i32 1 ; <i32> [#uses=1]
  %tmp194 = sub nsw i32 %tmp188, %tmp193          ; <i32> [#uses=1]
  %tmp195 = load <4 x i32> addrspace(1)** %offsets_in.addr ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp196 = load i32* %tx                         ; <i32> [#uses=1]
  %arrayidx197 = getelementptr <4 x i32> addrspace(1)* %tmp195, i32 %tmp196 ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp198 = load <4 x i32> addrspace(1)* %arrayidx197 ; <<4 x i32>> [#uses=1]
  %tmp199 = extractelement <4 x i32> %tmp198, i32 3 ; <i32> [#uses=1]
  %tmp200 = mul i32 %tmp194, %tmp199              ; <i32> [#uses=1]
  %tmp201 = add nsw i32 %tmp186, %tmp200          ; <i32> [#uses=1]
  store i32 %tmp201, i32* %idx_pl172
  %tmp202 = load i32* %idx_pl172                  ; <i32> [#uses=1]
  %tmp203 = load <2 x i32>* %ccoord               ; <<2 x i32>> [#uses=1]
  %tmp204 = extractelement <2 x i32> %tmp203, i32 0 ; <i32> [#uses=1]
  %tmp205 = load <4 x i32> addrspace(1)** %offsets_in.addr ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp206 = load i32* %tx                         ; <i32> [#uses=1]
  %arrayidx207 = getelementptr <4 x i32> addrspace(1)* %tmp205, i32 %tmp206 ; <<4 x i32> addrspace(1)*> [#uses=1]
  %tmp208 = load <4 x i32> addrspace(1)* %arrayidx207 ; <<4 x i32>> [#uses=1]
  %tmp209 = extractelement <4 x i32> %tmp208, i32 0 ; <i32> [#uses=1]
  %tmp210 = sub nsw i32 %tmp204, %tmp209          ; <i32> [#uses=1]
  %tmp211 = add nsw i32 %tmp202, %tmp210          ; <i32> [#uses=1]
  store i32 %tmp211, i32* %idx_pl172
  %tmp213 = load i8 addrspace(1)** %pl_in.addr    ; <i8 addrspace(1)*> [#uses=1]
  %tmp214 = load i32* %idx_pl172                  ; <i32> [#uses=1]
  %arrayidx215 = getelementptr i8 addrspace(1)* %tmp213, i32 %tmp214 ; <i8 addrspace(1)*> [#uses=1]
  %tmp216 = load i8 addrspace(1)* %arrayidx215    ; <i8> [#uses=1]
  %conv217 = uitofp i8 %tmp216 to float           ; <float> [#uses=1]
  store float %conv217, float* %pl_value212
  %tmp218 = load float* %pl_value212              ; <float> [#uses=1]
  %cmp219 = fcmp ogt float %tmp218, 2.550000e+02  ; <i1> [#uses=1]
  br i1 %cmp219, label %if.then221, label %if.end220

if.end220:                                        ; preds = %if.then221, %if.then171
  %tmp222 = load float* %pl_value212              ; <float> [#uses=1]
  %tmp223 = fdiv float %tmp222, 2.550000e+02      ; <float> [#uses=1]
  %tmp224 = fsub float 1.000000e+00, %tmp223      ; <float> [#uses=1]
  store float %tmp224, float* %pl_value212
  %tmp225 = load i32 addrspace(1)** %tx_pwr.addr  ; <i32 addrspace(1)*> [#uses=1]
  %tmp226 = load i32* %tx                         ; <i32> [#uses=1]
  %arrayidx227 = getelementptr i32 addrspace(1)* %tmp225, i32 %tmp226 ; <i32 addrspace(1)*> [#uses=1]
  %tmp228 = load i32 addrspace(1)* %arrayidx227   ; <i32> [#uses=1]
  %conv229 = sitofp i32 %tmp228 to float          ; <float> [#uses=1]
  %tmp230 = fdiv float %conv229, 1.000000e+03     ; <float> [#uses=1]
  %tmp231 = load float* %pl_value212              ; <float> [#uses=1]
  %tmp232 = fmul float %tmp230, %tmp231           ; <float> [#uses=1]
  %tmp233 = load float addrspace(1)** %qrm_in.addr ; <float addrspace(1)*> [#uses=1]
  %tmp234 = load i32* %idx_2d                     ; <i32> [#uses=1]
  %arrayidx235 = getelementptr float addrspace(1)* %tmp233, i32 %tmp234 ; <float addrspace(1)*> [#uses=1]
  %tmp236 = load float addrspace(1)* %arrayidx235 ; <float> [#uses=1]
  %tmp237 = fdiv float %tmp232, %tmp236           ; <float> [#uses=1]
  store float %tmp237, float* %pl_value212
  %tmp238 = load float* %pl_value212              ; <float> [#uses=1]
  %tmp239 = load float addrspace(3)** %pblock.addr ; <float addrspace(3)*> [#uses=1]
  %tmp240 = load i32* %idx_local                  ; <i32> [#uses=1]
  %arrayidx241 = getelementptr float addrspace(3)* %tmp239, i32 %tmp240 ; <float addrspace(3)*> [#uses=1]
  %tmp242 = load float addrspace(3)* %arrayidx241 ; <float> [#uses=1]
  %cmp243 = fcmp ogt float %tmp238, %tmp242       ; <i1> [#uses=1]
  br i1 %cmp243, label %if.then245, label %if.end244

if.then221:                                       ; preds = %if.then171
  store float 2.550000e+02, float* %pl_value212
  br label %if.end220

if.end244:                                        ; preds = %if.then245, %if.end220
  br label %if.end170

if.then245:                                       ; preds = %if.end220
  %tmp246 = load float addrspace(3)** %pblock.addr ; <float addrspace(3)*> [#uses=1]
  %tmp247 = load i32* %idx_local                  ; <i32> [#uses=1]
  %arrayidx248 = getelementptr float addrspace(3)* %tmp246, i32 %tmp247 ; <float addrspace(3)*> [#uses=1]
  %tmp249 = load float* %pl_value212              ; <float> [#uses=1]
  store float %tmp249, float addrspace(3)* %arrayidx248
  br label %if.end244

if.end257:                                        ; preds = %if.then258, %for.exit
  call void @barrier(i32 1, i32 1) nounwind
  %tmp275 = load float addrspace(1)** %cov_out.addr ; <float addrspace(1)*> [#uses=1]
  %tmp276 = load i32* %idx_2d                     ; <i32> [#uses=1]
  %arrayidx277 = getelementptr float addrspace(1)* %tmp275, i32 %tmp276 ; <float addrspace(1)*> [#uses=1]
  %tmp278 = load float addrspace(3)** %pblock.addr ; <float addrspace(3)*> [#uses=1]
  %tmp279 = load i32* %idx_local                  ; <i32> [#uses=1]
  %arrayidx280 = getelementptr float addrspace(3)* %tmp278, i32 %tmp279 ; <float addrspace(3)*> [#uses=1]
  %tmp281 = load float addrspace(3)* %arrayidx280 ; <float> [#uses=1]
  store float %tmp281, float addrspace(1)* %arrayidx277
  %tmp282 = load i32* %idx_local                  ; <i32> [#uses=1]
  %cmp283 = icmp eq i32 %tmp282, 0                ; <i1> [#uses=1]
  br i1 %cmp283, label %if.then285, label %if.end284

if.then258:                                       ; preds = %for.exit
  %tmp259 = load float addrspace(3)** %pblock.addr ; <float addrspace(3)*> [#uses=1]
  %tmp260 = load i32* %lmem_ctr_offset.addr       ; <i32> [#uses=1]
  %tmp261 = load i32* %idx_local                  ; <i32> [#uses=1]
  %tmp262 = add i32 %tmp260, %tmp261              ; <i32> [#uses=1]
  %arrayidx263 = getelementptr float addrspace(3)* %tmp259, i32 %tmp262 ; <float addrspace(3)*> [#uses=1]
  %tmp264 = load <2 x i32>* %ccoord               ; <<2 x i32>> [#uses=1]
  %tmp265 = extractelement <2 x i32> %tmp264, i32 0 ; <i32> [#uses=1]
  %conv266 = sitofp i32 %tmp265 to float          ; <float> [#uses=1]
  store float %conv266, float addrspace(3)* %arrayidx263
  %tmp267 = load float addrspace(3)** %pblock.addr ; <float addrspace(3)*> [#uses=1]
  %tmp268 = load i32* %lmem_coord_offset.addr     ; <i32> [#uses=1]
  %tmp269 = load i32* %idx_local                  ; <i32> [#uses=1]
  %tmp270 = add i32 %tmp268, %tmp269              ; <i32> [#uses=1]
  %arrayidx271 = getelementptr float addrspace(3)* %tmp267, i32 %tmp270 ; <float addrspace(3)*> [#uses=1]
  %tmp272 = load <2 x i32>* %ccoord               ; <<2 x i32>> [#uses=1]
  %tmp273 = extractelement <2 x i32> %tmp272, i32 1 ; <i32> [#uses=1]
  %conv274 = sitofp i32 %tmp273 to float          ; <float> [#uses=1]
  store float %conv274, float addrspace(3)* %arrayidx271
  br label %if.end257

if.end284:                                        ; preds = %for.exit302, %if.end257
  br label %return

if.then285:                                       ; preds = %if.end257
  store i32 0, i32* %cov_ctr
  store <2 x i32> zeroinitializer, <2 x i32>* %tmp286
  %tmp287 = load <2 x i32>* %tmp286               ; <<2 x i32>> [#uses=1]
  store <2 x i32> %tmp287, <2 x i32>* %cov_coord
  %call288 = call i32 @get_global_id(i32 1) nounwind ; <i32> [#uses=1]
  %tmp289 = udiv i32 %call288, 16                 ; <i32> [#uses=1]
  store i32 %tmp289, i32* %idx_reduced
  %tmp290 = load i32* %idx_reduced                ; <i32> [#uses=1]
  %call291 = call i32 @get_global_size(i32 0) nounwind ; <i32> [#uses=1]
  %tmp292 = udiv i32 %call291, 16                 ; <i32> [#uses=1]
  %tmp293 = mul i32 %tmp290, %tmp292              ; <i32> [#uses=1]
  store i32 %tmp293, i32* %idx_reduced
  %tmp294 = load i32* %idx_reduced                ; <i32> [#uses=1]
  %call295 = call i32 @get_global_id(i32 0) nounwind ; <i32> [#uses=1]
  %tmp296 = udiv i32 %call295, 16                 ; <i32> [#uses=1]
  %tmp297 = add i32 %tmp294, %tmp296              ; <i32> [#uses=1]
  store i32 %tmp297, i32* %idx_reduced
  %call298 = call i32 @get_local_size(i32 0) nounwind ; <i32> [#uses=1]
  %call299 = call i32 @get_local_size(i32 1) nounwind ; <i32> [#uses=1]
  %tmp300 = mul i32 %call298, %call299            ; <i32> [#uses=1]
  store i32 %tmp300, i32* %local_size
  store i32 0, i32* %tx
  br label %for.cond301

for.cond301:                                      ; preds = %for.inc307, %if.then285
  %tmp303 = load i32* %tx                         ; <i32> [#uses=1]
  %tmp304 = load i32* %local_size                 ; <i32> [#uses=1]
  %cmp305 = icmp slt i32 %tmp303, %tmp304         ; <i1> [#uses=1]
  br i1 %cmp305, label %for.body306, label %for.exit302

for.exit302:                                      ; preds = %for.cond301
  %tmp341 = load i16 addrspace(1)** %cov_ctr_out.addr ; <i16 addrspace(1)*> [#uses=1]
  %tmp342 = load i32* %idx_reduced                ; <i32> [#uses=1]
  %arrayidx343 = getelementptr i16 addrspace(1)* %tmp341, i32 %tmp342 ; <i16 addrspace(1)*> [#uses=1]
  %tmp344 = load i32* %cov_ctr                    ; <i32> [#uses=1]
  %conv345 = trunc i32 %tmp344 to i16             ; <i16> [#uses=1]
  store i16 %conv345, i16 addrspace(1)* %arrayidx343
  %tmp346 = load i16 addrspace(1)** %cov_coord_out.addr ; <i16 addrspace(1)*> [#uses=1]
  %tmp347 = load i32* %idx_reduced                ; <i32> [#uses=1]
  %tmp348 = mul i32 2, %tmp347                    ; <i32> [#uses=1]
  %arrayidx349 = getelementptr i16 addrspace(1)* %tmp346, i32 %tmp348 ; <i16 addrspace(1)*> [#uses=1]
  %tmp350 = load <2 x i32>* %cov_coord            ; <<2 x i32>> [#uses=1]
  %tmp351 = extractelement <2 x i32> %tmp350, i32 0 ; <i32> [#uses=1]
  %conv352 = trunc i32 %tmp351 to i16             ; <i16> [#uses=1]
  store i16 %conv352, i16 addrspace(1)* %arrayidx349
  %tmp353 = load i16 addrspace(1)** %cov_coord_out.addr ; <i16 addrspace(1)*> [#uses=1]
  %tmp354 = load i32* %idx_reduced                ; <i32> [#uses=1]
  %tmp355 = mul i32 2, %tmp354                    ; <i32> [#uses=1]
  %tmp356 = add nsw i32 %tmp355, 1                ; <i32> [#uses=1]
  %arrayidx357 = getelementptr i16 addrspace(1)* %tmp353, i32 %tmp356 ; <i16 addrspace(1)*> [#uses=1]
  %tmp358 = load <2 x i32>* %cov_coord            ; <<2 x i32>> [#uses=1]
  %tmp359 = extractelement <2 x i32> %tmp358, i32 1 ; <i32> [#uses=1]
  %conv360 = trunc i32 %tmp359 to i16             ; <i16> [#uses=1]
  store i16 %conv360, i16 addrspace(1)* %arrayidx357
  br label %if.end284

for.body306:                                      ; preds = %for.cond301
  %tmp308 = load float addrspace(3)** %pblock.addr ; <float addrspace(3)*> [#uses=1]
  %tmp309 = load i32* %lmem_ctr_offset.addr       ; <i32> [#uses=1]
  %tmp310 = load i32* %tx                         ; <i32> [#uses=1]
  %tmp311 = add nsw i32 %tmp309, %tmp310          ; <i32> [#uses=1]
  %arrayidx312 = getelementptr float addrspace(3)* %tmp308, i32 %tmp311 ; <float addrspace(3)*> [#uses=1]
  %tmp313 = load float addrspace(3)* %arrayidx312 ; <float> [#uses=1]
  %cmp314 = fcmp une float %tmp313, 0.000000e+00  ; <i1> [#uses=1]
  br i1 %cmp314, label %if.then316, label %if.end315

for.inc307:                                       ; preds = %if.end315
  %tmp339 = load i32* %tx                         ; <i32> [#uses=1]
  %tmp340 = add nsw i32 %tmp339, 1                ; <i32> [#uses=1]
  store i32 %tmp340, i32* %tx
  br label %for.cond301

if.end315:                                        ; preds = %if.then316, %for.body306
  br label %for.inc307

if.then316:                                       ; preds = %for.body306
  %tmp318 = load i32* %cov_ctr                    ; <i32> [#uses=1]
  %tmp319 = add nsw i32 %tmp318, 1                ; <i32> [#uses=1]
  store i32 %tmp319, i32* %cov_ctr
  %tmp320 = load float addrspace(3)** %pblock.addr ; <float addrspace(3)*> [#uses=1]
  %tmp321 = load i32* %lmem_ctr_offset.addr       ; <i32> [#uses=1]
  %tmp322 = load i32* %tx                         ; <i32> [#uses=1]
  %tmp323 = add nsw i32 %tmp321, %tmp322          ; <i32> [#uses=1]
  %arrayidx324 = getelementptr float addrspace(3)* %tmp320, i32 %tmp323 ; <float addrspace(3)*> [#uses=1]
  %tmp325 = load float addrspace(3)* %arrayidx324 ; <float> [#uses=1]
  %conv326 = fptosi float %tmp325 to i32          ; <i32> [#uses=1]
  %tmp327 = load <2 x i32>* %tmp317               ; <<2 x i32>> [#uses=1]
  %tmp328 = insertelement <2 x i32> %tmp327, i32 %conv326, i32 0 ; <<2 x i32>> [#uses=1]
  store <2 x i32> %tmp328, <2 x i32>* %tmp317
  %tmp329 = load float addrspace(3)** %pblock.addr ; <float addrspace(3)*> [#uses=1]
  %tmp330 = load i32* %lmem_coord_offset.addr     ; <i32> [#uses=1]
  %tmp331 = load i32* %tx                         ; <i32> [#uses=1]
  %tmp332 = add nsw i32 %tmp330, %tmp331          ; <i32> [#uses=1]
  %arrayidx333 = getelementptr float addrspace(3)* %tmp329, i32 %tmp332 ; <float addrspace(3)*> [#uses=1]
  %tmp334 = load float addrspace(3)* %arrayidx333 ; <float> [#uses=1]
  %conv335 = fptosi float %tmp334 to i32          ; <i32> [#uses=1]
  %tmp336 = load <2 x i32>* %tmp317               ; <<2 x i32>> [#uses=1]
  %tmp337 = insertelement <2 x i32> %tmp336, i32 %conv335, i32 1 ; <<2 x i32>> [#uses=1]
  store <2 x i32> %tmp337, <2 x i32>* %tmp317
  %tmp338 = load <2 x i32>* %tmp317               ; <<2 x i32>> [#uses=1]
  store <2 x i32> %tmp338, <2 x i32>* %cov_coord
  br label %if.end315
}

declare i32 @get_global_id(i32) nounwind

declare i32 @get_global_size(i32) nounwind

define void @__OpenCL_hata_urban_interference_kernel(i32 %cell_res, i32 %ncols, <4 x i32> %tx_data, <2 x i32> %tx_offset, float %rx_height, float %frequency, float %ahr, float addrspace(1)* %dem_in, float addrspace(1)* %qrm_out, <2 x float> addrspace(3)* %pblock) nounwind {
entry:
  %cell_res.addr = alloca i32, align 4            ; <i32*> [#uses=3]
  %ncols.addr = alloca i32, align 4               ; <i32*> [#uses=2]
  %tx_data.addr = alloca <4 x i32>, align 16      ; <<4 x i32>*> [#uses=9]
  %tx_offset.addr = alloca <2 x i32>, align 8     ; <<2 x i32>*> [#uses=3]
  %rx_height.addr = alloca float, align 4         ; <float*> [#uses=2]
  %frequency.addr = alloca float, align 4         ; <float*> [#uses=2]
  %ahr.addr = alloca float, align 4               ; <float*> [#uses=2]
  %dem_in.addr = alloca float addrspace(1)*, align 4 ; <float addrspace(1)**> [#uses=3]
  %qrm_out.addr = alloca float addrspace(1)*, align 4 ; <float addrspace(1)**> [#uses=2]
  %pblock.addr = alloca <2 x float> addrspace(3)*, align 4 ; <<2 x float> addrspace(3)**> [#uses=5]
  %tmp = alloca <2 x i32>, align 8                ; <<2 x i32>*> [#uses=5]
  %tmp1 = alloca <2 x float>, align 8             ; <<2 x float>*> [#uses=5]
  %tmp2 = alloca float addrspace(1)*, align 4     ; <float addrspace(1)**> [#uses=2]
  %tmp3 = alloca float, align 4                   ; <float*> [#uses=2]
  %dist = alloca float, align 4                   ; <float*> [#uses=10]
  %height_diff = alloca float, align 4            ; <float*> [#uses=5]
  %ccoord = alloca <2 x i32>, align 8             ; <<2 x i32>*> [#uses=7]
  %element_idx = alloca i32, align 4              ; <i32*> [#uses=4]
  %local_idx = alloca i32, align 4                ; <i32*> [#uses=5]
  %pl_db = alloca float, align 4                  ; <float*> [#uses=6]
  store i32 %cell_res, i32* %cell_res.addr
  store i32 %ncols, i32* %ncols.addr
  store <4 x i32> %tx_data, <4 x i32>* %tx_data.addr
  store <2 x i32> %tx_offset, <2 x i32>* %tx_offset.addr
  store float %rx_height, float* %rx_height.addr
  store float %frequency, float* %frequency.addr
  store float %ahr, float* %ahr.addr
  store float addrspace(1)* %dem_in, float addrspace(1)** %dem_in.addr
  store float addrspace(1)* %qrm_out, float addrspace(1)** %qrm_out.addr
  store <2 x float> addrspace(3)* %pblock, <2 x float> addrspace(3)** %pblock.addr
  %tmp4 = load <2 x i32>* %tx_offset.addr         ; <<2 x i32>> [#uses=1]
  %tmp5 = extractelement <2 x i32> %tmp4, i32 0   ; <i32> [#uses=1]
  %call = call i32 @get_global_id(i32 0) nounwind ; <i32> [#uses=1]
  %tmp6 = add i32 %tmp5, %call                    ; <i32> [#uses=1]
  %tmp7 = load <2 x i32>* %tmp                    ; <<2 x i32>> [#uses=1]
  %tmp8 = insertelement <2 x i32> %tmp7, i32 %tmp6, i32 0 ; <<2 x i32>> [#uses=1]
  store <2 x i32> %tmp8, <2 x i32>* %tmp
  %tmp9 = load <2 x i32>* %tx_offset.addr         ; <<2 x i32>> [#uses=1]
  %tmp10 = extractelement <2 x i32> %tmp9, i32 1  ; <i32> [#uses=1]
  %call11 = call i32 @get_global_id(i32 1) nounwind ; <i32> [#uses=1]
  %tmp12 = add i32 %tmp10, %call11                ; <i32> [#uses=1]
  %tmp13 = load <2 x i32>* %tmp                   ; <<2 x i32>> [#uses=1]
  %tmp14 = insertelement <2 x i32> %tmp13, i32 %tmp12, i32 1 ; <<2 x i32>> [#uses=1]
  store <2 x i32> %tmp14, <2 x i32>* %tmp
  %tmp15 = load <2 x i32>* %tmp                   ; <<2 x i32>> [#uses=1]
  store <2 x i32> %tmp15, <2 x i32>* %ccoord
  %tmp16 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp17 = extractelement <2 x i32> %tmp16, i32 1 ; <i32> [#uses=1]
  %tmp18 = load i32* %ncols.addr                  ; <i32> [#uses=1]
  %tmp19 = mul i32 %tmp17, %tmp18                 ; <i32> [#uses=1]
  %tmp20 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp21 = extractelement <2 x i32> %tmp20, i32 0 ; <i32> [#uses=1]
  %tmp22 = add nsw i32 %tmp19, %tmp21             ; <i32> [#uses=1]
  store i32 %tmp22, i32* %element_idx
  %tmp23 = load <4 x i32>* %tx_data.addr          ; <<4 x i32>> [#uses=1]
  %tmp24 = extractelement <4 x i32> %tmp23, i32 0 ; <i32> [#uses=1]
  %tmp25 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp26 = extractelement <2 x i32> %tmp25, i32 0 ; <i32> [#uses=1]
  %tmp27 = sub nsw i32 %tmp24, %tmp26             ; <i32> [#uses=1]
  %tmp28 = load <4 x i32>* %tx_data.addr          ; <<4 x i32>> [#uses=1]
  %tmp29 = extractelement <4 x i32> %tmp28, i32 0 ; <i32> [#uses=1]
  %tmp30 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp31 = extractelement <2 x i32> %tmp30, i32 0 ; <i32> [#uses=1]
  %tmp32 = sub nsw i32 %tmp29, %tmp31             ; <i32> [#uses=1]
  %tmp33 = mul i32 %tmp27, %tmp32                 ; <i32> [#uses=1]
  %conv = sitofp i32 %tmp33 to float              ; <float> [#uses=1]
  store float %conv, float* %dist
  %tmp34 = load float* %dist                      ; <float> [#uses=1]
  %tmp35 = load <4 x i32>* %tx_data.addr          ; <<4 x i32>> [#uses=1]
  %tmp36 = extractelement <4 x i32> %tmp35, i32 1 ; <i32> [#uses=1]
  %tmp37 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp38 = extractelement <2 x i32> %tmp37, i32 1 ; <i32> [#uses=1]
  %tmp39 = sub nsw i32 %tmp36, %tmp38             ; <i32> [#uses=1]
  %tmp40 = load <4 x i32>* %tx_data.addr          ; <<4 x i32>> [#uses=1]
  %tmp41 = extractelement <4 x i32> %tmp40, i32 1 ; <i32> [#uses=1]
  %tmp42 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp43 = extractelement <2 x i32> %tmp42, i32 1 ; <i32> [#uses=1]
  %tmp44 = sub nsw i32 %tmp41, %tmp43             ; <i32> [#uses=1]
  %tmp45 = mul i32 %tmp39, %tmp44                 ; <i32> [#uses=1]
  %conv46 = sitofp i32 %tmp45 to float            ; <float> [#uses=1]
  %tmp47 = fadd float %tmp34, %conv46             ; <float> [#uses=1]
  store float %tmp47, float* %dist
  %tmp48 = load float* %dist                      ; <float> [#uses=1]
  %call49 = call float @__sqrt_f32(float %tmp48) nounwind ; <float> [#uses=1]
  %tmp50 = load i32* %cell_res.addr               ; <i32> [#uses=1]
  %conv51 = sitofp i32 %tmp50 to float            ; <float> [#uses=1]
  %tmp52 = fmul float %call49, %conv51            ; <float> [#uses=1]
  store float %tmp52, float* %dist
  %tmp53 = load float* %dist                      ; <float> [#uses=1]
  %cmp = fcmp olt float %tmp53, 1.000000e+01      ; <i1> [#uses=1]
  br i1 %cmp, label %if.then, label %if.end

return:                                           ; preds = %if.end132
  ret void

if.end:                                           ; preds = %if.then, %entry
  %tmp57 = load float* %dist                      ; <float> [#uses=1]
  %tmp58 = fdiv float %tmp57, 1.000000e+03        ; <float> [#uses=1]
  store float %tmp58, float* %dist
  %tmp59 = load <4 x i32>* %tx_data.addr          ; <<4 x i32>> [#uses=1]
  %tmp60 = extractelement <4 x i32> %tmp59, i32 2 ; <i32> [#uses=1]
  %conv61 = sitofp i32 %tmp60 to float            ; <float> [#uses=1]
  %tmp62 = load float addrspace(1)** %dem_in.addr ; <float addrspace(1)*> [#uses=1]
  %tmp63 = load i32* %element_idx                 ; <i32> [#uses=1]
  %arrayidx = getelementptr float addrspace(1)* %tmp62, i32 %tmp63 ; <float addrspace(1)*> [#uses=1]
  %tmp64 = load float addrspace(1)* %arrayidx     ; <float> [#uses=1]
  %cmp65 = fcmp ogt float %conv61, %tmp64         ; <i1> [#uses=1]
  br i1 %cmp65, label %if.then67, label %if.else

if.then:                                          ; preds = %entry
  %tmp54 = load i32* %cell_res.addr               ; <i32> [#uses=1]
  %conv55 = sitofp i32 %tmp54 to float            ; <float> [#uses=1]
  %tmp56 = fdiv float %conv55, 2.000000e+00       ; <float> [#uses=1]
  store float %tmp56, float* %dist
  br label %if.end

if.end66:                                         ; preds = %if.else, %if.then67
  %call85 = call i32 @get_local_id(i32 1) nounwind ; <i32> [#uses=1]
  %call86 = call i32 @get_local_size(i32 0) nounwind ; <i32> [#uses=1]
  %tmp87 = mul i32 %call85, %call86               ; <i32> [#uses=1]
  %call88 = call i32 @get_local_id(i32 0) nounwind ; <i32> [#uses=1]
  %tmp89 = add i32 %tmp87, %call88                ; <i32> [#uses=1]
  store i32 %tmp89, i32* %local_idx
  %tmp90 = load <2 x float> addrspace(3)** %pblock.addr ; <<2 x float> addrspace(3)*> [#uses=1]
  %tmp91 = load i32* %local_idx                   ; <i32> [#uses=1]
  %arrayidx92 = getelementptr <2 x float> addrspace(3)* %tmp90, i32 %tmp91 ; <<2 x float> addrspace(3)*> [#uses=1]
  %tmp93 = load float* %dist                      ; <float> [#uses=1]
  %tmp94 = load <2 x float>* %tmp1                ; <<2 x float>> [#uses=1]
  %tmp95 = insertelement <2 x float> %tmp94, float %tmp93, i32 0 ; <<2 x float>> [#uses=1]
  store <2 x float> %tmp95, <2 x float>* %tmp1
  %tmp96 = load float* %height_diff               ; <float> [#uses=1]
  %tmp97 = load <2 x float>* %tmp1                ; <<2 x float>> [#uses=1]
  %tmp98 = insertelement <2 x float> %tmp97, float %tmp96, i32 1 ; <<2 x float>> [#uses=1]
  store <2 x float> %tmp98, <2 x float>* %tmp1
  %tmp99 = load <2 x float>* %tmp1                ; <<2 x float>> [#uses=1]
  store <2 x float> %tmp99, <2 x float> addrspace(3)* %arrayidx92
  call void @barrier(i32 2, i32 1) nounwind
  %tmp100 = load float* %frequency.addr           ; <float> [#uses=1]
  %call101 = call float @__log10_f32(float %tmp100) nounwind ; <float> [#uses=1]
  %tmp102 = fmul float 0x403A28F5C0000000, %call101 ; <float> [#uses=1]
  %tmp103 = fadd float 0x4051633340000000, %tmp102 ; <float> [#uses=1]
  %tmp104 = load <2 x float> addrspace(3)** %pblock.addr ; <<2 x float> addrspace(3)*> [#uses=1]
  %tmp105 = load i32* %local_idx                  ; <i32> [#uses=1]
  %arrayidx106 = getelementptr <2 x float> addrspace(3)* %tmp104, i32 %tmp105 ; <<2 x float> addrspace(3)*> [#uses=1]
  %tmp107 = load <2 x float> addrspace(3)* %arrayidx106 ; <<2 x float>> [#uses=1]
  %tmp108 = extractelement <2 x float> %tmp107, i32 1 ; <float> [#uses=1]
  %call109 = call float @__log10_f32(float %tmp108) nounwind ; <float> [#uses=1]
  %tmp110 = fmul float 0x402BA3D700000000, %call109 ; <float> [#uses=1]
  %tmp111 = fsub float %tmp103, %tmp110           ; <float> [#uses=1]
  %tmp112 = load float* %ahr.addr                 ; <float> [#uses=1]
  %tmp113 = fsub float %tmp111, %tmp112           ; <float> [#uses=1]
  %tmp114 = load <2 x float> addrspace(3)** %pblock.addr ; <<2 x float> addrspace(3)*> [#uses=1]
  %tmp115 = load i32* %local_idx                  ; <i32> [#uses=1]
  %arrayidx116 = getelementptr <2 x float> addrspace(3)* %tmp114, i32 %tmp115 ; <<2 x float> addrspace(3)*> [#uses=1]
  %tmp117 = load <2 x float> addrspace(3)* %arrayidx116 ; <<2 x float>> [#uses=1]
  %tmp118 = extractelement <2 x float> %tmp117, i32 1 ; <float> [#uses=1]
  %call119 = call float @__log10_f32(float %tmp118) nounwind ; <float> [#uses=1]
  %tmp120 = fmul float 0x401A333340000000, %call119 ; <float> [#uses=1]
  %tmp121 = fsub float 0x4046733340000000, %tmp120 ; <float> [#uses=1]
  %tmp122 = load <2 x float> addrspace(3)** %pblock.addr ; <<2 x float> addrspace(3)*> [#uses=1]
  %tmp123 = load i32* %local_idx                  ; <i32> [#uses=1]
  %arrayidx124 = getelementptr <2 x float> addrspace(3)* %tmp122, i32 %tmp123 ; <<2 x float> addrspace(3)*> [#uses=1]
  %tmp125 = load <2 x float> addrspace(3)* %arrayidx124 ; <<2 x float>> [#uses=1]
  %tmp126 = extractelement <2 x float> %tmp125, i32 0 ; <float> [#uses=1]
  %call127 = call float @__log10_f32(float %tmp126) nounwind ; <float> [#uses=1]
  %tmp128 = fmul float %tmp121, %call127          ; <float> [#uses=1]
  %tmp129 = fadd float %tmp113, %tmp128           ; <float> [#uses=1]
  store float %tmp129, float* %pl_db
  %tmp130 = load float* %pl_db                    ; <float> [#uses=1]
  %cmp131 = fcmp ogt float %tmp130, 2.550000e+02  ; <i1> [#uses=1]
  br i1 %cmp131, label %if.then133, label %if.end132

if.then67:                                        ; preds = %if.end
  %tmp68 = load <4 x i32>* %tx_data.addr          ; <<4 x i32>> [#uses=1]
  %tmp69 = extractelement <4 x i32> %tmp68, i32 2 ; <i32> [#uses=1]
  %tmp70 = load <4 x i32>* %tx_data.addr          ; <<4 x i32>> [#uses=1]
  %tmp71 = extractelement <4 x i32> %tmp70, i32 3 ; <i32> [#uses=1]
  %tmp72 = add nsw i32 %tmp69, %tmp71             ; <i32> [#uses=1]
  %conv73 = sitofp i32 %tmp72 to float            ; <float> [#uses=1]
  store float %conv73, float* %height_diff
  %tmp74 = load float* %height_diff               ; <float> [#uses=1]
  %tmp75 = load float addrspace(1)** %dem_in.addr ; <float addrspace(1)*> [#uses=1]
  %tmp76 = load i32* %element_idx                 ; <i32> [#uses=1]
  %arrayidx77 = getelementptr float addrspace(1)* %tmp75, i32 %tmp76 ; <float addrspace(1)*> [#uses=1]
  %tmp78 = load float addrspace(1)* %arrayidx77   ; <float> [#uses=1]
  %tmp79 = load float* %rx_height.addr            ; <float> [#uses=1]
  %tmp80 = fadd float %tmp78, %tmp79              ; <float> [#uses=1]
  %tmp81 = fsub float %tmp74, %tmp80              ; <float> [#uses=1]
  store float %tmp81, float* %height_diff
  br label %if.end66

if.else:                                          ; preds = %if.end
  %tmp82 = load <4 x i32>* %tx_data.addr          ; <<4 x i32>> [#uses=1]
  %tmp83 = extractelement <4 x i32> %tmp82, i32 3 ; <i32> [#uses=1]
  %conv84 = sitofp i32 %tmp83 to float            ; <float> [#uses=1]
  store float %conv84, float* %height_diff
  br label %if.end66

if.end132:                                        ; preds = %if.then133, %if.end66
  %tmp134 = load float* %pl_db                    ; <float> [#uses=1]
  %tmp135 = fdiv float %tmp134, 2.550000e+02      ; <float> [#uses=1]
  %tmp136 = fsub float 1.000000e+00, %tmp135      ; <float> [#uses=1]
  store float %tmp136, float* %pl_db
  %tmp137 = load float addrspace(1)** %qrm_out.addr ; <float addrspace(1)*> [#uses=1]
  %tmp138 = load i32* %element_idx                ; <i32> [#uses=1]
  %tmp139 = getelementptr float addrspace(1)* %tmp137, i32 %tmp138 ; <float addrspace(1)*> [#uses=2]
  store float addrspace(1)* %tmp139, float addrspace(1)** %tmp2
  %tmp140 = load float addrspace(1)* %tmp139      ; <float> [#uses=1]
  %tmp141 = load float* %pl_db                    ; <float> [#uses=1]
  %tmp142 = fmul float %tmp141, 0x4033F33340000000 ; <float> [#uses=1]
  %tmp143 = fadd float %tmp140, %tmp142           ; <float> [#uses=1]
  store float %tmp143, float* %tmp3
  %tmp144 = load float addrspace(1)** %tmp2       ; <float addrspace(1)*> [#uses=1]
  %tmp145 = load float* %tmp3                     ; <float> [#uses=1]
  store float %tmp145, float addrspace(1)* %tmp144
  br label %return

if.then133:                                       ; preds = %if.end66
  store float 2.550000e+02, float* %pl_db
  br label %if.end132
}

declare float @__sqrt_f32(float) nounwind

declare float @__log10_f32(float) nounwind

define void @__OpenCL_hata_urban_kern_per_tx_kernel(i32 %cell_res, i32 %ncols, <4 x i32> %tx_data, <2 x i32> %tx_offset, float %rx_height, float %frequency, float %ahr, float addrspace(1)* %dem_in, float addrspace(1)* %pl_out, <2 x float> addrspace(3)* %pblock) nounwind {
entry:
  %cell_res.addr = alloca i32, align 4            ; <i32*> [#uses=3]
  %ncols.addr = alloca i32, align 4               ; <i32*> [#uses=2]
  %tx_data.addr = alloca <4 x i32>, align 16      ; <<4 x i32>*> [#uses=9]
  %tx_offset.addr = alloca <2 x i32>, align 8     ; <<2 x i32>*> [#uses=3]
  %rx_height.addr = alloca float, align 4         ; <float*> [#uses=2]
  %frequency.addr = alloca float, align 4         ; <float*> [#uses=2]
  %ahr.addr = alloca float, align 4               ; <float*> [#uses=2]
  %dem_in.addr = alloca float addrspace(1)*, align 4 ; <float addrspace(1)**> [#uses=3]
  %pl_out.addr = alloca float addrspace(1)*, align 4 ; <float addrspace(1)**> [#uses=2]
  %pblock.addr = alloca <2 x float> addrspace(3)*, align 4 ; <<2 x float> addrspace(3)**> [#uses=5]
  %tmp = alloca <2 x i32>, align 8                ; <<2 x i32>*> [#uses=5]
  %tmp1 = alloca <2 x float>, align 8             ; <<2 x float>*> [#uses=5]
  %dist = alloca float, align 4                   ; <float*> [#uses=10]
  %height_diff = alloca float, align 4            ; <float*> [#uses=5]
  %ccoord = alloca <2 x i32>, align 8             ; <<2 x i32>*> [#uses=7]
  %dem_idx = alloca i32, align 4                  ; <i32*> [#uses=3]
  %element_idx = alloca i32, align 4              ; <i32*> [#uses=2]
  %local_idx = alloca i32, align 4                ; <i32*> [#uses=5]
  store i32 %cell_res, i32* %cell_res.addr
  store i32 %ncols, i32* %ncols.addr
  store <4 x i32> %tx_data, <4 x i32>* %tx_data.addr
  store <2 x i32> %tx_offset, <2 x i32>* %tx_offset.addr
  store float %rx_height, float* %rx_height.addr
  store float %frequency, float* %frequency.addr
  store float %ahr, float* %ahr.addr
  store float addrspace(1)* %dem_in, float addrspace(1)** %dem_in.addr
  store float addrspace(1)* %pl_out, float addrspace(1)** %pl_out.addr
  store <2 x float> addrspace(3)* %pblock, <2 x float> addrspace(3)** %pblock.addr
  %tmp2 = load <2 x i32>* %tx_offset.addr         ; <<2 x i32>> [#uses=1]
  %tmp3 = extractelement <2 x i32> %tmp2, i32 0   ; <i32> [#uses=1]
  %call = call i32 @get_global_id(i32 0) nounwind ; <i32> [#uses=1]
  %tmp4 = add i32 %tmp3, %call                    ; <i32> [#uses=1]
  %tmp5 = load <2 x i32>* %tmp                    ; <<2 x i32>> [#uses=1]
  %tmp6 = insertelement <2 x i32> %tmp5, i32 %tmp4, i32 0 ; <<2 x i32>> [#uses=1]
  store <2 x i32> %tmp6, <2 x i32>* %tmp
  %tmp7 = load <2 x i32>* %tx_offset.addr         ; <<2 x i32>> [#uses=1]
  %tmp8 = extractelement <2 x i32> %tmp7, i32 1   ; <i32> [#uses=1]
  %call9 = call i32 @get_global_id(i32 1) nounwind ; <i32> [#uses=1]
  %tmp10 = add i32 %tmp8, %call9                  ; <i32> [#uses=1]
  %tmp11 = load <2 x i32>* %tmp                   ; <<2 x i32>> [#uses=1]
  %tmp12 = insertelement <2 x i32> %tmp11, i32 %tmp10, i32 1 ; <<2 x i32>> [#uses=1]
  store <2 x i32> %tmp12, <2 x i32>* %tmp
  %tmp13 = load <2 x i32>* %tmp                   ; <<2 x i32>> [#uses=1]
  store <2 x i32> %tmp13, <2 x i32>* %ccoord
  %tmp14 = load <4 x i32>* %tx_data.addr          ; <<4 x i32>> [#uses=1]
  %tmp15 = extractelement <4 x i32> %tmp14, i32 0 ; <i32> [#uses=1]
  %tmp16 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp17 = extractelement <2 x i32> %tmp16, i32 0 ; <i32> [#uses=1]
  %tmp18 = sub nsw i32 %tmp15, %tmp17             ; <i32> [#uses=1]
  %tmp19 = load <4 x i32>* %tx_data.addr          ; <<4 x i32>> [#uses=1]
  %tmp20 = extractelement <4 x i32> %tmp19, i32 0 ; <i32> [#uses=1]
  %tmp21 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp22 = extractelement <2 x i32> %tmp21, i32 0 ; <i32> [#uses=1]
  %tmp23 = sub nsw i32 %tmp20, %tmp22             ; <i32> [#uses=1]
  %tmp24 = mul i32 %tmp18, %tmp23                 ; <i32> [#uses=1]
  %conv = sitofp i32 %tmp24 to float              ; <float> [#uses=1]
  store float %conv, float* %dist
  %tmp25 = load float* %dist                      ; <float> [#uses=1]
  %tmp26 = load <4 x i32>* %tx_data.addr          ; <<4 x i32>> [#uses=1]
  %tmp27 = extractelement <4 x i32> %tmp26, i32 1 ; <i32> [#uses=1]
  %tmp28 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp29 = extractelement <2 x i32> %tmp28, i32 1 ; <i32> [#uses=1]
  %tmp30 = sub nsw i32 %tmp27, %tmp29             ; <i32> [#uses=1]
  %tmp31 = load <4 x i32>* %tx_data.addr          ; <<4 x i32>> [#uses=1]
  %tmp32 = extractelement <4 x i32> %tmp31, i32 1 ; <i32> [#uses=1]
  %tmp33 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp34 = extractelement <2 x i32> %tmp33, i32 1 ; <i32> [#uses=1]
  %tmp35 = sub nsw i32 %tmp32, %tmp34             ; <i32> [#uses=1]
  %tmp36 = mul i32 %tmp30, %tmp35                 ; <i32> [#uses=1]
  %conv37 = sitofp i32 %tmp36 to float            ; <float> [#uses=1]
  %tmp38 = fadd float %tmp25, %conv37             ; <float> [#uses=1]
  store float %tmp38, float* %dist
  %tmp39 = load float* %dist                      ; <float> [#uses=1]
  %call40 = call float @__sqrt_f32(float %tmp39) nounwind ; <float> [#uses=1]
  %tmp41 = load i32* %cell_res.addr               ; <i32> [#uses=1]
  %conv42 = sitofp i32 %tmp41 to float            ; <float> [#uses=1]
  %tmp43 = fmul float %call40, %conv42            ; <float> [#uses=1]
  store float %tmp43, float* %dist
  %tmp44 = load float* %dist                      ; <float> [#uses=1]
  %cmp = fcmp olt float %tmp44, 1.000000e+01      ; <i1> [#uses=1]
  br i1 %cmp, label %if.then, label %if.end

return:                                           ; preds = %if.end69
  ret void

if.end:                                           ; preds = %if.then, %entry
  %tmp48 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp49 = extractelement <2 x i32> %tmp48, i32 1 ; <i32> [#uses=1]
  %tmp50 = load i32* %ncols.addr                  ; <i32> [#uses=1]
  %tmp51 = mul i32 %tmp49, %tmp50                 ; <i32> [#uses=1]
  %tmp52 = load <2 x i32>* %ccoord                ; <<2 x i32>> [#uses=1]
  %tmp53 = extractelement <2 x i32> %tmp52, i32 0 ; <i32> [#uses=1]
  %tmp54 = add nsw i32 %tmp51, %tmp53             ; <i32> [#uses=1]
  store i32 %tmp54, i32* %dem_idx
  %call55 = call i32 @get_global_id(i32 1) nounwind ; <i32> [#uses=1]
  %call56 = call i32 @get_global_size(i32 0) nounwind ; <i32> [#uses=1]
  %tmp57 = mul i32 %call55, %call56               ; <i32> [#uses=1]
  %call58 = call i32 @get_global_id(i32 0) nounwind ; <i32> [#uses=1]
  %tmp59 = add i32 %tmp57, %call58                ; <i32> [#uses=1]
  store i32 %tmp59, i32* %element_idx
  %tmp60 = load float* %dist                      ; <float> [#uses=1]
  %tmp61 = fdiv float %tmp60, 1.000000e+03        ; <float> [#uses=1]
  store float %tmp61, float* %dist
  %tmp62 = load <4 x i32>* %tx_data.addr          ; <<4 x i32>> [#uses=1]
  %tmp63 = extractelement <4 x i32> %tmp62, i32 2 ; <i32> [#uses=1]
  %conv64 = sitofp i32 %tmp63 to float            ; <float> [#uses=1]
  %tmp65 = load float addrspace(1)** %dem_in.addr ; <float addrspace(1)*> [#uses=1]
  %tmp66 = load i32* %dem_idx                     ; <i32> [#uses=1]
  %arrayidx = getelementptr float addrspace(1)* %tmp65, i32 %tmp66 ; <float addrspace(1)*> [#uses=1]
  %tmp67 = load float addrspace(1)* %arrayidx     ; <float> [#uses=1]
  %cmp68 = fcmp ogt float %conv64, %tmp67         ; <i1> [#uses=1]
  br i1 %cmp68, label %if.then70, label %if.else

if.then:                                          ; preds = %entry
  %tmp45 = load i32* %cell_res.addr               ; <i32> [#uses=1]
  %conv46 = sitofp i32 %tmp45 to float            ; <float> [#uses=1]
  %tmp47 = fdiv float %conv46, 2.000000e+00       ; <float> [#uses=1]
  store float %tmp47, float* %dist
  br label %if.end

if.end69:                                         ; preds = %if.else, %if.then70
  %call88 = call i32 @get_local_id(i32 1) nounwind ; <i32> [#uses=1]
  %call89 = call i32 @get_local_size(i32 0) nounwind ; <i32> [#uses=1]
  %tmp90 = mul i32 %call88, %call89               ; <i32> [#uses=1]
  %call91 = call i32 @get_local_id(i32 0) nounwind ; <i32> [#uses=1]
  %tmp92 = add i32 %tmp90, %call91                ; <i32> [#uses=1]
  store i32 %tmp92, i32* %local_idx
  %tmp93 = load <2 x float> addrspace(3)** %pblock.addr ; <<2 x float> addrspace(3)*> [#uses=1]
  %tmp94 = load i32* %local_idx                   ; <i32> [#uses=1]
  %arrayidx95 = getelementptr <2 x float> addrspace(3)* %tmp93, i32 %tmp94 ; <<2 x float> addrspace(3)*> [#uses=1]
  %tmp96 = load float* %dist                      ; <float> [#uses=1]
  %tmp97 = load <2 x float>* %tmp1                ; <<2 x float>> [#uses=1]
  %tmp98 = insertelement <2 x float> %tmp97, float %tmp96, i32 0 ; <<2 x float>> [#uses=1]
  store <2 x float> %tmp98, <2 x float>* %tmp1
  %tmp99 = load float* %height_diff               ; <float> [#uses=1]
  %tmp100 = load <2 x float>* %tmp1               ; <<2 x float>> [#uses=1]
  %tmp101 = insertelement <2 x float> %tmp100, float %tmp99, i32 1 ; <<2 x float>> [#uses=1]
  store <2 x float> %tmp101, <2 x float>* %tmp1
  %tmp102 = load <2 x float>* %tmp1               ; <<2 x float>> [#uses=1]
  store <2 x float> %tmp102, <2 x float> addrspace(3)* %arrayidx95
  call void @barrier(i32 3, i32 1) nounwind
  %tmp103 = load float addrspace(1)** %pl_out.addr ; <float addrspace(1)*> [#uses=1]
  %tmp104 = load i32* %element_idx                ; <i32> [#uses=1]
  %arrayidx105 = getelementptr float addrspace(1)* %tmp103, i32 %tmp104 ; <float addrspace(1)*> [#uses=1]
  %tmp106 = load float* %frequency.addr           ; <float> [#uses=1]
  %call107 = call float @__log10_f32(float %tmp106) nounwind ; <float> [#uses=1]
  %tmp108 = fmul float 0x403A28F5C0000000, %call107 ; <float> [#uses=1]
  %tmp109 = fadd float 0x4051633340000000, %tmp108 ; <float> [#uses=1]
  %tmp110 = load <2 x float> addrspace(3)** %pblock.addr ; <<2 x float> addrspace(3)*> [#uses=1]
  %tmp111 = load i32* %local_idx                  ; <i32> [#uses=1]
  %arrayidx112 = getelementptr <2 x float> addrspace(3)* %tmp110, i32 %tmp111 ; <<2 x float> addrspace(3)*> [#uses=1]
  %tmp113 = load <2 x float> addrspace(3)* %arrayidx112 ; <<2 x float>> [#uses=1]
  %tmp114 = extractelement <2 x float> %tmp113, i32 1 ; <float> [#uses=1]
  %call115 = call float @__log10_f32(float %tmp114) nounwind ; <float> [#uses=1]
  %tmp116 = fmul float 0x402BA3D700000000, %call115 ; <float> [#uses=1]
  %tmp117 = fsub float %tmp109, %tmp116           ; <float> [#uses=1]
  %tmp118 = load float* %ahr.addr                 ; <float> [#uses=1]
  %tmp119 = fsub float %tmp117, %tmp118           ; <float> [#uses=1]
  %tmp120 = load <2 x float> addrspace(3)** %pblock.addr ; <<2 x float> addrspace(3)*> [#uses=1]
  %tmp121 = load i32* %local_idx                  ; <i32> [#uses=1]
  %arrayidx122 = getelementptr <2 x float> addrspace(3)* %tmp120, i32 %tmp121 ; <<2 x float> addrspace(3)*> [#uses=1]
  %tmp123 = load <2 x float> addrspace(3)* %arrayidx122 ; <<2 x float>> [#uses=1]
  %tmp124 = extractelement <2 x float> %tmp123, i32 1 ; <float> [#uses=1]
  %call125 = call float @__log10_f32(float %tmp124) nounwind ; <float> [#uses=1]
  %tmp126 = fmul float 0x401A333340000000, %call125 ; <float> [#uses=1]
  %tmp127 = fsub float 0x4046733340000000, %tmp126 ; <float> [#uses=1]
  %tmp128 = load <2 x float> addrspace(3)** %pblock.addr ; <<2 x float> addrspace(3)*> [#uses=1]
  %tmp129 = load i32* %local_idx                  ; <i32> [#uses=1]
  %arrayidx130 = getelementptr <2 x float> addrspace(3)* %tmp128, i32 %tmp129 ; <<2 x float> addrspace(3)*> [#uses=1]
  %tmp131 = load <2 x float> addrspace(3)* %arrayidx130 ; <<2 x float>> [#uses=1]
  %tmp132 = extractelement <2 x float> %tmp131, i32 0 ; <float> [#uses=1]
  %call133 = call float @__log10_f32(float %tmp132) nounwind ; <float> [#uses=1]
  %tmp134 = fmul float %tmp127, %call133          ; <float> [#uses=1]
  %tmp135 = fadd float %tmp119, %tmp134           ; <float> [#uses=1]
  store float %tmp135, float addrspace(1)* %arrayidx105
  br label %return

if.then70:                                        ; preds = %if.end
  %tmp71 = load <4 x i32>* %tx_data.addr          ; <<4 x i32>> [#uses=1]
  %tmp72 = extractelement <4 x i32> %tmp71, i32 2 ; <i32> [#uses=1]
  %tmp73 = load <4 x i32>* %tx_data.addr          ; <<4 x i32>> [#uses=1]
  %tmp74 = extractelement <4 x i32> %tmp73, i32 3 ; <i32> [#uses=1]
  %tmp75 = add nsw i32 %tmp72, %tmp74             ; <i32> [#uses=1]
  %conv76 = sitofp i32 %tmp75 to float            ; <float> [#uses=1]
  store float %conv76, float* %height_diff
  %tmp77 = load float* %height_diff               ; <float> [#uses=1]
  %tmp78 = load float addrspace(1)** %dem_in.addr ; <float addrspace(1)*> [#uses=1]
  %tmp79 = load i32* %dem_idx                     ; <i32> [#uses=1]
  %arrayidx80 = getelementptr float addrspace(1)* %tmp78, i32 %tmp79 ; <float addrspace(1)*> [#uses=1]
  %tmp81 = load float addrspace(1)* %arrayidx80   ; <float> [#uses=1]
  %tmp82 = load float* %rx_height.addr            ; <float> [#uses=1]
  %tmp83 = fadd float %tmp81, %tmp82              ; <float> [#uses=1]
  %tmp84 = fsub float %tmp77, %tmp83              ; <float> [#uses=1]
  store float %tmp84, float* %height_diff
  br label %if.end69

if.else:                                          ; preds = %if.end
  %tmp85 = load <4 x i32>* %tx_data.addr          ; <<4 x i32>> [#uses=1]
  %tmp86 = extractelement <4 x i32> %tmp85, i32 3 ; <i32> [#uses=1]
  %conv87 = sitofp i32 %tmp86 to float            ; <float> [#uses=1]
  store float %conv87, float* %height_diff
  br label %if.end69
}
