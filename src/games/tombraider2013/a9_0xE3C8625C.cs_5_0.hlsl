// ---- Created with 3Dmigoto v1.4.1 on Mon Jan 20 18:02:21 2025

cbuffer cb6 : register(b6)
{
  int4 g_i2InputSize : packoffset(c0);
  int4 g_i2OutputSize : packoffset(c1);
  float4 DepthToW : packoffset(c2);
  float4 g_vCoCParams : packoffset(c3);
  float4 NearFocusParams : packoffset(c4);
  float4 FarFocusParams : packoffset(c5);
  float4 VignetteParams : packoffset(c6);
  float4 DepthToView : packoffset(c7);
  float4 Multipliers : packoffset(c8);
}

Texture2D<float4> mapInputTexture0 : register(t0);
Texture2D<float4> InputTexture1 : register(t1);
RWTexture2D<float4> g_uavOutput : register(u0);


// 3Dmigoto declarations
#define cmp -

[numthreads(16, 16, 1)]
void main(uint2 vThreadGroupID: SV_GroupID, uint2 vThreadIDInGroup: SV_GroupThreadID)
{
// Needs manual fix for instruction:
// unknown dcl_: dcl_uav_typed_texture2d (float,float,float,float) u0
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11;
  uint4 bitmask, uiDest;
  float4 fDest;

// Needs manual fix for instruction:
// unknown dcl_: dcl_thread_group 16, 16, 1
  r0.xyzw = (uint4)vThreadGroupID.xyyy << int4(4,4,4,4);
  r0.xyzw = (int4)r0.xyzw + (int4)vThreadIDInGroup.xyyy;
  r1.xy = cmp((int2)r0.xw < (int2)g_i2OutputSize.xy);
  r1.x = r1.y ? r1.x : 0;
  if (r1.x != 0) {
    r1.xy = (uint2)r0.xw << int2(1,1);
    r1.zw = (int2)g_i2InputSize.xy + int2(-1,-1);
    r1.xy = max(int2(0,0), (int2)r1.xy);
    r1.xy = min((int2)r1.xy, (int2)r1.zw);
    r2.x = max(0, VignetteParams.z);
    r2.yz = (int2)r1.xy;
    r3.xy = (int2)g_i2InputSize.xy;
    r2.yz = r2.yz / r3.xy;
    r3.zw = float2(-0.5,-0.5) + r2.yz;
    r2.w = dot(r3.zw, r3.zw);
    r2.w = sqrt(r2.w);
    r2.w = -VignetteParams.x + r2.w;
    r2.w = saturate(VignetteParams.y * r2.w);
    r2.x = r2.x * r2.w;
    r4.xy = (int2)r1.xy + int2(1,0);
    r3.zw = (int2)r4.xy;
    r3.zw = r3.zw / r3.xy;
    r4.zw = float2(0,0);
    r5.xyz = mapInputTexture0.Load(r4.xyw).xyz;
    r4.x = InputTexture1.Load(r4.xyz).x;
    r2.w = r4.x * DepthToW.x + DepthToW.y;
    r2.w = max(9.99999997e-07, r2.w);
    r2.w = 1 / r2.w;
    r4.xy = r3.zw * DepthToView.xy + DepthToView.zw;
    r4.z = 1;
    r3.z = dot(r4.xyz, r4.xyz);
    r3.z = sqrt(r3.z);
    r3.w = r3.z * r2.w;
    r4.x = cmp(0 != Multipliers.w);
    r4.y = g_vCoCParams.x * r3.w;
    r4.z = r2.w * r3.z + -g_vCoCParams.x;
    r4.y = r4.y / r4.z;
    r4.y = g_vCoCParams.y + r4.y;
    r4.y = g_vCoCParams.z * -r4.y;
    r4.y = g_vCoCParams.w * r4.y;
    r6.xyzw = float4(-20,20,8,16) * Multipliers.yyyy;
    r4.y = max(r6.x, r4.y);
    r7.y = min(r4.y, r6.y);
    r4.y = cmp(r7.y < 0);
    r7.xz = float2(0,0);
    r4.yz = r4.yy ? float2(0,0) : r7.xy;
    r4.w = -r2.w * r3.z + NearFocusParams.x;
    r4.w = saturate(NearFocusParams.y * r4.w);
    r4.w = NearFocusParams.z * r4.w;
    r2.w = r2.w * r3.z + -FarFocusParams.x;
    r2.w = saturate(FarFocusParams.y * r2.w);
    r2.w = FarFocusParams.z * r2.w;
    r3.z = g_vCoCParams.w + g_vCoCParams.w;
    r4.w = r4.w * r3.z;
    r2.w = r3.z * r2.w;
    r7.x = min(r4.w, r6.z);
    r7.y = min(r2.w, r6.z);
    r4.yz = r4.xx ? r4.yz : r7.xy;
    r2.x = Multipliers.y * r2.x;
    r2.x = 6 * r2.x;
    r2.w = r3.w / Multipliers.x;
    r2.w = saturate(1 + -r2.w);
    r2.w = r6.w * r2.w;
    r2.w = max(r2.x, r2.w);
    r2.w = max(r2.w, r4.y);
    r3.w = cmp(r4.z < r2.w);
    r2.w = r3.w ? -r2.w : r4.z;
    r8.xy = (int2)r1.xy + int2(0,1);
    r4.yz = (int2)r8.xy;
    r4.yz = r4.yz / r3.xy;
    r8.zw = float2(0,0);
    r9.xyz = mapInputTexture0.Load(r8.xyw).xyz;
    r7.x = InputTexture1.Load(r8.xyz).x;
    r3.w = r7.x * DepthToW.x + DepthToW.y;
    r3.w = max(9.99999997e-07, r3.w);
    r3.w = 1 / r3.w;
    r8.xy = r4.yz * DepthToView.xy + DepthToView.zw;
    r8.z = 1;
    r4.y = dot(r8.xyz, r8.xyz);
    r4.y = sqrt(r4.y);
    r4.z = r4.y * r3.w;
    r4.w = g_vCoCParams.x * r4.z;
    r5.w = r3.w * r4.y + -g_vCoCParams.x;
    r4.w = r4.w / r5.w;
    r4.w = g_vCoCParams.y + r4.w;
    r4.w = g_vCoCParams.z * -r4.w;
    r4.w = g_vCoCParams.w * r4.w;
    r4.w = max(r4.w, r6.x);
    r7.w = min(r4.w, r6.y);
    r4.w = cmp(r7.w < 0);
    r7.xy = r4.ww ? float2(0,0) : r7.zw;
    r4.w = -r3.w * r4.y + NearFocusParams.x;
    r4.w = saturate(NearFocusParams.y * r4.w);
    r4.w = NearFocusParams.z * r4.w;
    r3.w = r3.w * r4.y + -FarFocusParams.x;
    r3.w = saturate(FarFocusParams.y * r3.w);
    r3.w = FarFocusParams.z * r3.w;
    r4.y = r4.w * r3.z;
    r3.w = r3.w * r3.z;
    r8.x = min(r4.y, r6.z);
    r8.y = min(r3.w, r6.z);
    r4.yw = r4.xx ? r7.xy : r8.xy;
    r3.w = r4.z / Multipliers.x;
    r3.w = saturate(1 + -r3.w);
    r3.w = r6.w * r3.w;
    r3.w = max(r3.w, r2.x);
    r3.w = max(r3.w, r4.y);
    r4.y = cmp(r4.w < r3.w);
    r3.w = r4.y ? -r3.w : r4.w;
    r7.xy = (int2)r1.xy + int2(1,1);
    r4.yz = (int2)r7.xy;
    r3.xy = r4.yz / r3.xy;
    r7.zw = float2(0,0);
    r8.xyz = mapInputTexture0.Load(r7.xyw).xyz;
    r7.x = InputTexture1.Load(r7.xyz).x;
    r4.y = r7.x * DepthToW.x + DepthToW.y;
    r4.y = max(9.99999997e-07, r4.y);
    r4.y = 1 / r4.y;
    r7.xy = r3.xy * DepthToView.xy + DepthToView.zw;
    r7.z = 1;
    r3.x = dot(r7.xyz, r7.xyz);
    r3.x = sqrt(r3.x);
    r3.y = r4.y * r3.x;
    r4.z = g_vCoCParams.x * r3.y;
    r4.w = r4.y * r3.x + -g_vCoCParams.x;
    r4.z = r4.z / r4.w;
    r4.z = g_vCoCParams.y + r4.z;
    r4.z = g_vCoCParams.z * -r4.z;
    r4.z = g_vCoCParams.w * r4.z;
    r4.z = max(r4.z, r6.x);
    r7.y = min(r4.z, r6.y);
    r4.z = cmp(r7.y < 0);
    r7.xz = float2(0,0);
    r4.zw = r4.zz ? float2(0,0) : r7.xy;
    r5.w = -r4.y * r3.x + NearFocusParams.x;
    r5.w = saturate(NearFocusParams.y * r5.w);
    r5.w = NearFocusParams.z * r5.w;
    r3.x = r4.y * r3.x + -FarFocusParams.x;
    r3.x = saturate(FarFocusParams.y * r3.x);
    r3.x = FarFocusParams.z * r3.x;
    r4.y = r5.w * r3.z;
    r3.x = r3.x * r3.z;
    r7.x = min(r4.y, r6.z);
    r7.y = min(r3.x, r6.z);
    r4.yz = r4.xx ? r4.zw : r7.xy;
    r3.x = r3.y / Multipliers.x;
    r3.x = saturate(1 + -r3.x);
    r3.x = r6.w * r3.x;
    r3.x = max(r3.x, r2.x);
    r3.x = max(r3.x, r4.y);
    r3.y = cmp(r4.z < r3.x);
    r3.x = r3.y ? -r3.x : r4.z;
    r1.zw = float2(0,0);
    r10.xyz = mapInputTexture0.Load(r1.xyw).xyz;
    r1.x = InputTexture1.Load(r1.xyz).x;
    r1.x = r1.x * DepthToW.x + DepthToW.y;
    r1.x = max(9.99999997e-07, r1.x);
    r1.x = 1 / r1.x;
    r11.xy = r2.yz * DepthToView.xy + DepthToView.zw;
    r11.z = 1;
    r1.y = dot(r11.xyz, r11.xyz);
    r1.y = sqrt(r1.y);
    r1.z = r1.x * r1.y;
    r1.w = g_vCoCParams.x * r1.z;
    r2.y = r1.x * r1.y + -g_vCoCParams.x;
    r1.w = r1.w / r2.y;
    r1.w = g_vCoCParams.y + r1.w;
    r1.w = g_vCoCParams.z * -r1.w;
    r1.w = g_vCoCParams.w * r1.w;
    r1.w = max(r1.w, r6.x);
    r7.w = min(r1.w, r6.y);
    r1.w = cmp(r7.w < 0);
    r2.yz = r1.ww ? float2(0,0) : r7.zw;
    r1.w = -r1.x * r1.y + NearFocusParams.x;
    r1.w = saturate(NearFocusParams.y * r1.w);
    r1.w = NearFocusParams.z * r1.w;
    r1.x = r1.x * r1.y + -FarFocusParams.x;
    r1.x = saturate(FarFocusParams.y * r1.x);
    r1.x = FarFocusParams.z * r1.x;
    r1.xy = r1.xw * r3.zz;
    r6.xy = min(r1.yx, r6.zz);
    r1.xy = r4.xx ? r2.yz : r6.xy;
    r1.z = r1.z / Multipliers.x;
    r1.z = saturate(1 + -r1.z);
    r1.z = r6.w * r1.z;
    r1.z = max(r2.x, r1.z);
    r1.x = max(r1.z, r1.x);
    r1.z = cmp(r1.y < r1.x);
    r1.x = r1.z ? -r1.x : r1.y;
    r1.y = cmp(r2.w < 0);
    r1.z = cmp(r3.w < 0);
    r1.y = (int)r1.z | (int)r1.y;
    r1.z = cmp(r3.x < 0);
    r1.y = (int)r1.z | (int)r1.y;
    r1.z = cmp(r1.x < 0);
    r1.y = (int)r1.z | (int)r1.y;
    r1.z = min(r3.w, r2.w);
    r1.w = min(r3.x, r1.x);
    r1.z = min(r1.z, r1.w);
    r1.w = r1.y ? -r1.z : r2.w;
    r1.w = max(0, r1.w);
    r2.x = cmp(0 < r1.w);
    r2.y = r2.x ? 1.000000 : 0;
    r2.z = r1.y ? -r1.z : r3.w;
    r2.z = max(0, r2.z);
    r2.w = cmp(0 < r2.z);
    r2.x = r2.x ? 2 : 1;
    r2.x = r2.w ? r2.x : r2.y;
    r2.y = r1.y ? -r1.z : r3.x;
    r2.y = max(0, r2.y);
    r2.w = cmp(0 < r2.y);
    r3.x = 1 + r2.x;
    r2.x = r2.w ? r3.x : r2.x;
    r1.x = r1.y ? -r1.z : r1.x;
    r1.x = max(0, r1.x);
    r1.z = cmp(0 < r1.x);
    r2.w = 1 + r2.x;
    r3.x = r1.z ? r2.w : r2.x;
    r1.z = r2.z + r1.w;
    r1.z = r1.z + r2.y;
    r3.y = r1.z + r1.x;
    r1.z = cmp(r3.x == 0.000000);
    r2.x = r1.z ? 0.25 : r2.y;
    r2.y = r1.z ? 0.25 : r2.z;
    r1.xw = r1.zz ? float2(0.25,0.25) : r1.xw;
    r2.zw = r1.zz ? float2(1,1) : r3.xy;
    r3.xzw = r9.xyz * r2.yyy;
    r3.xzw = r5.xyz * r1.www + r3.xzw;
    r3.xzw = r8.xyz * r2.xxx + r3.xzw;
    r1.xzw = r10.xyz * r1.xxx + r3.xzw;
    r1.y = r1.y ? -r3.y : r3.y;
    r3.xyzw = r1.xzwy / r2.wwwz;
    // No code for instruction (needs manual fix):
    //  store_uav_typed u0.xyzw, r0.xyzw, r3.xyzw
    // g_uavOutput[r0.xy] = r3.xyzw;
    g_uavOutput[r0.xy] = max(0, r3.xyzw);
  }
  return;
}