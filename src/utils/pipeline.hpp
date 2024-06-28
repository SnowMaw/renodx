/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <include/reshade.hpp>
#include "./format.hpp"

namespace renodx::utils::pipeline {

static reshade::api::pipeline_subobject* ClonePipelineSubObjects(uint32_t subobject_count, const reshade::api::pipeline_subobject* subobjects) {
  auto* new_subobjects = new reshade::api::pipeline_subobject[subobject_count];
  memcpy(new_subobjects, subobjects, sizeof(reshade::api::pipeline_subobject) * subobject_count);
  for (uint32_t i = 0; i < subobject_count; ++i) {
#ifdef DEBUG_LEVEL_2
    {
      std::stringstream s;
      s << "utils::pipeline::ClonePipelineSubObjects(cloning " << subobjects[i].type << "[" << i << "]";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
    }
#endif
    switch (subobjects[i].type) {
      case reshade::api::pipeline_subobject_type::vertex_shader:
      case reshade::api::pipeline_subobject_type::hull_shader:
      case reshade::api::pipeline_subobject_type::domain_shader:
      case reshade::api::pipeline_subobject_type::geometry_shader:
      case reshade::api::pipeline_subobject_type::compute_shader:
      case reshade::api::pipeline_subobject_type::pixel_shader:    {
        new_subobjects[i].data = malloc(sizeof(reshade::api::shader_desc));
        memcpy(new_subobjects[i].data, subobjects[i].data, sizeof(reshade::api::shader_desc));
        auto* old_desc = static_cast<reshade::api::shader_desc*>(subobjects[i].data);
        auto* new_desc = static_cast<reshade::api::shader_desc*>(new_subobjects[i].data);
        if (old_desc->code_size != 0u) {
          void* code_copy = malloc(old_desc->code_size);
          memcpy(code_copy, old_desc->code, old_desc->code_size);
          new_desc->code = code_copy;
        }

#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "utils::pipeline::ClonePipelineSubObjects(cloning ";
        s << subobjects[i].type;
        s << " with " << PRINT_CRC32(compute_crc32(static_cast<const uint8_t*>(old_desc->code), old_desc->code_size));
        s << " => " << PRINT_CRC32(compute_crc32(static_cast<const uint8_t*>(new_desc->code), new_desc->code_size));
        s << " (" << old_desc->code_size << " bytes)";
        s << " from " << old_desc->code;
        s << " to " << new_desc->code;
        s << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
        break;
      }
      case reshade::api::pipeline_subobject_type::input_layout:
        new_subobjects[i].data = malloc(sizeof(reshade::api::input_element) * subobjects[i].count);
        memcpy(new_subobjects[i].data, subobjects[i].data, sizeof(reshade::api::input_element) * subobjects[i].count);
        for (uint32_t j = 0; j < subobjects[i].count; j++) {
          auto* old_input_elements = static_cast<reshade::api::input_element*>(subobjects[i].data);
          auto* new_input_elements = static_cast<reshade::api::input_element*>(new_subobjects[i].data);
          new_input_elements[j].semantic = _strdup(old_input_elements[j].semantic);
        }
        break;
      case reshade::api::pipeline_subobject_type::stream_output_state:
        new_subobjects[i].data = malloc(sizeof(reshade::api::stream_output_desc));
        memcpy(new_subobjects[i].data, subobjects[i].data, sizeof(reshade::api::stream_output_desc));
        break;
      case reshade::api::pipeline_subobject_type::blend_state:
        new_subobjects[i].data = malloc(sizeof(reshade::api::blend_desc));
        memcpy(new_subobjects[i].data, subobjects[i].data, sizeof(reshade::api::blend_desc));
        break;
      case reshade::api::pipeline_subobject_type::rasterizer_state:
        new_subobjects[i].data = malloc(sizeof(reshade::api::rasterizer_desc));
        memcpy(new_subobjects[i].data, subobjects[i].data, sizeof(reshade::api::rasterizer_desc));
        break;
      case reshade::api::pipeline_subobject_type::depth_stencil_state:
        new_subobjects[i].data = malloc(sizeof(reshade::api::depth_stencil_desc));
        memcpy(new_subobjects[i].data, subobjects[i].data, sizeof(reshade::api::depth_stencil_desc));
        break;
      case reshade::api::pipeline_subobject_type::primitive_topology:
        new_subobjects[i].data = malloc(sizeof(reshade::api::primitive_topology));
        memcpy(new_subobjects[i].data, subobjects[i].data, sizeof(reshade::api::primitive_topology));
        break;
      case reshade::api::pipeline_subobject_type::depth_stencil_format:
        new_subobjects[i].data = malloc(sizeof(reshade::api::format));
        memcpy(new_subobjects[i].data, subobjects[i].data, sizeof(reshade::api::format));
        break;
      case reshade::api::pipeline_subobject_type::render_target_formats:
        new_subobjects[i].data = malloc(sizeof(reshade::api::format) * subobjects[i].count);
        memcpy(new_subobjects[i].data, subobjects[i].data, sizeof(reshade::api::format) * subobjects[i].count);
        break;
      case reshade::api::pipeline_subobject_type::sample_mask:
      case reshade::api::pipeline_subobject_type::sample_count:
      case reshade::api::pipeline_subobject_type::viewport_count:
        new_subobjects[i].data = malloc(sizeof(uint32_t));
        memcpy(new_subobjects[i].data, subobjects[i].data, sizeof(uint32_t));
        break;
      case reshade::api::pipeline_subobject_type::dynamic_pipeline_states:
        new_subobjects[i].data = malloc(sizeof(reshade::api::dynamic_state) * subobjects[i].count);
        memcpy(new_subobjects[i].data, subobjects[i].data, sizeof(reshade::api::dynamic_state) * subobjects[i].count);
        break;
      default:
        break;
    }
  }

  return new_subobjects;
}

}  // namespace renodx::utils::pipeline
