#include "./shared.h"

/// Adjusts gamma based on luminance using the guidelines from ITU BT.2408.
/// At `gammaAdjustmentFactor` = 1.15, it works well to preserve the appearance of
/// shadows and midtones at 100 cd/m2 while scaling the SDR nominal peak white to 203 cd/m2.
/// See: https://www.itu.int/dms_pub/itu-r/opb/rep/R-REP-BT.2408-7-2023-PDF-E.pdf Section 5.1.3.2
/// @param linearColor The color to adjust.
/// @param gammaAdjustmentFactor Factor to adjust the gamma.
/// @return The color with adjusted gamma.
float3 AdjustGammaOnLuminance(float3 linearColor, float gammaAdjustmentFactor) {
  if (gammaAdjustmentFactor == 1.f) return linearColor;
  // Calculate the original luminance
  float originalLuminance = renodx::color::y::from::BT709(abs(linearColor));

  // Adjust luminance only if it is less than or equal to 1
  float adjustedLuminance = originalLuminance > 1.0 ? originalLuminance : renodx::color::gamma::Encode(originalLuminance, 1 / gammaAdjustmentFactor);

  // Recombine the colors with the adjusted luminance
  if (originalLuminance == 0) return float3(0, 0, 0);  // Prevent division by zero
  return linearColor * (adjustedLuminance / originalLuminance);
}

/// Applies a modified `renodx::lut::Sample` that accounts for only black level correction,
/// leaving peak white untouched as LUTs are already HDR, ensuring no highlight impact.
/// @param color_input Input color to apply the LUT to.
/// @param lut_texture The LUT texture.
/// @param lut_config Configuration for LUT sampling.
/// @return Color output after applying LUT correction.
float3 LUTBlackCorrection(float3 color_input, Texture3D lut_texture, renodx::lut::Config lut_config) {
  float3 lutInputColor = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lutOutputColor = renodx::lut::SampleColor(lutInputColor, lut_config, lut_texture);
  float3 color_output = renodx::lut::LinearOutput(lutOutputColor, lut_config);
  if (lut_config.scaling != 0) {
    float3 lutBlack = renodx::lut::SampleColor(renodx::lut::ConvertInput(0, lut_config), lut_config, lut_texture);
    float3 lutMid = renodx::lut::SampleColor(renodx::lut::ConvertInput(0.18f, lut_config), lut_config, lut_texture);
    float3 unclamped = renodx::lut::Unclamp(
        renodx::lut::GammaOutput(lutOutputColor, lut_config),
        renodx::lut::GammaOutput(lutBlack, lut_config),
        renodx::lut::GammaOutput(lutMid, lut_config),
        1.f,  // set peak to 1 so it doesn't touch highlights
        renodx::lut::GammaInput(color_input, lutInputColor, lut_config));
    float3 recolored = renodx::lut::RecolorUnclamped(color_output, renodx::lut::LinearUnclampedOutput(unclamped, lut_config));
    color_output = lerp(color_output, recolored, lut_config.scaling);
  }
  color_output = renodx::lut::RestoreSaturationLoss(color_input, color_output, lut_config);
  if (lut_config.strength != 1.f) {
    color_output = lerp(color_input, color_output, lut_config.strength);
  }
  return color_output;
}