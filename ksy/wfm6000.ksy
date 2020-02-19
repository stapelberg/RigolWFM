meta:
  id: wfm6000
  file-extension: wfm
  endian: le

instances:
  header:
    pos: 0
    type: header
  data:
    pos: 20916
    type: raw_data

types:
  header:
    seq:
      - id: magic
        contents: [0xa5,0xa5]
        
      - id: structure_size
        type: u2
        doc: size of this structure, should be 0x38
        
      - id: model
        size: 20
        type: str
        terminator: 0
        encoding: ascii
        
      - id: firmware_version
        size: 20
        type: str
        terminator: 0
        encoding: ascii

      - id: block_num
        type: u2

      - id: file_version
        type: u2
        
      - id: unused_1
        size: 18
    
      - id: unused_bits
        type: b4
      - id: ch4_enabled
        type: b1
      - id: ch3_enabled
        type: b1
      - id: ch2_enabled
        type: b1
      - id: ch1_enabled
        type: b1
        
      - id: channel_offset
        type: u4
        repeat: expr
        repeat-expr: 4

      - id: acquistion_mode
        type: u1
        enum: acquistion_enum

      - id: average_time
        type: u2
        doc: average time 0-2048
 
      - id: sample_mode
        type: u2
        doc: equ or real

      - id: mem_depth
        type: u4
        doc: storage depth
      
      - id: sample_rate_hz
        type: f4
        
      - id: time_mode
        type: u2
        enum: time_enum
        
      - id: time_scale_ps
        type: u8
        doc: horizontal timebase in picoseconds
        
      - id: time_offset_ps
        type: s8
        doc: horizontal offset in picoseconds
        
      - id: channel
        type: channel_header
        repeat: expr
        repeat-expr: 4

      - id: setup_size
        type: u4
      - id: setup_offset
        type: u4
      - id: wfm_offset
        type: u4
      - id: storage_depth
        type: u4
      - id: z_pt_offset
        type: u4
        doc: offset that valid waveform data compared with the start of storage waveform data
  
      - id: wfm_len
        type: u4
        doc: real waveform storage depth
        
      - id: mem_offset
        type: u2
        repeat: expr
        repeat-expr: 2
        
      - id: equ_coarse
        type: u2
        repeat: expr
        repeat-expr: 2
        
      - id: equ_fine
        type: u2
        repeat: expr
        repeat-expr: 2
  
      - id: mem_last_addr
        type: u4
        repeat: expr
        repeat-expr: 2
        
      - id: mem_length
        type: u4
        repeat: expr
        repeat-expr: 2
        
      - id: mem_start_addr
        type: u4
        repeat: expr
        repeat-expr: 2
        
      - id: bank_size
        type: u4
        repeat: expr
        repeat-expr: 2
        
      - id: roll_scrn_wave_length
        type: u2
      - id: analog_interp_en
        type: u1
      - id: main_force_analog_trig
        type: u1
      - id: zoom_force_analog_trig
        type: u1
      - id: horiz_slow_force_stop_frame
        type: u1
      - id: get_spu_dig_data_status
        type: u1
      - id: main_mem_offset
        type: s8
      - id: mem_view_offset
        type: s8
      - id: slow_deta_wave_length
        type: s8
      - id: slow_deta_wave_length_no_delay
        type: s8
      - id: real_sa_dot_period
        type: u8
      - id: trig_type_deta_delay
        type: s4
      - id: chnl1_2_max_delay
        type: s4
      - id: chnl3_4_max_delay
        type: s4
      - id: chnl_dly_to_mem_len
        type: u4
      - id: spu_mem_depth_deta
        type: u4
      - id: spu_mem_depth_rema
        type: u4
      - id: mem_offset_base
        type: u4
      - id: spu_mem_bank_size
        type: u4
      - id: s16_adc1__clock_delay
        type: u2
      - id: s16_adc2__clock_delay
        type: u2
      - id: max_main_scrn_chnl_delay
        type: u2
      - id: max_zoom_scrn_chnl_delay
        type: u2
      - id: main_dgtl_trig_data_offset
        type: u2
      - id: zoom_dgtl_trig_data_offset
        type: u2
      - id: record_frame_index
        type: u4
        
    instances:
      seconds_per_point:
        value: 1/sample_rate_hz
      time_scale:
        value: 1.0e-12 * time_scale_ps
      time_delay:
        value: 1.0e-12 * time_offset_ps
      points:
        value: _root.header.mem_depth
        
  channel_header:
    seq:
      - id: enabled
        type: u1
      - id: coupling
        type: u1
        enum: coupling_enum
      - id: bandwidth_limit
        type: u1
        enum: bandwidth_enum
      - id: probe_type
        size: u1
        enum: probe_type_enum
      - id: probe_ratio
        size: u1
        enum: probe_ratio_enun
      - id: probe_diff
        type: u1
        enum: probe_enum
      - id: probe_signal
        type: u1
        enum: probe_enum
      - id: probe_impedance
        type: u1
        enum: impedance_enum

      - id: scale
        type: f4
      - id: offset
        type: f4
      - id: invert
        type: u1
      - id: unit
        type: u1
        enum: unit_enum
      - id: filter_enabled
        type: u1
      - id: filter_type
        type: u1
        enum: filter_enum
      - id: filter_high
        type: u4
      - id: filter_low
        type: u4
    instances:
      volts_per_division:
        value: 1e-6 * scale
        doc: Voltage scale in volts per division.
      volts_offset:
        value: 1e-6 * offset
        doc: Voltage offset in volts.  
        
  channel_mask:
    seq:
      - id: unused
        type: b4
      - id: channel_4
        type: b1
      - id: channel_3
        type: b1
      - id: channel_2
        type: b1
      - id: channel_1
        type: b1
        
  raw_data:
    seq:
      - id: channel_1
        type: u1
        repeat: expr
        repeat-expr: _root.header.mem_depth
        if: _root.header.ch1_enabled
      - id: padding_1
        size: _root.header.bytes_per_channel_1 - _root.header.mem_depth
        if: _root.header.ch1_enabled
        
      - id: channel_2
        type: u1
        repeat: expr
        repeat-expr: _root.header.mem_depth
        if: _root.header.ch2_enabled
      - id: padding_2
        size: _root.header.bytes_per_channel_1 - _root.header.mem_depth
        if: _root.header.ch2_enabled
        
      - id: channel_3
        type: u1
        repeat: expr
        repeat-expr: _root.header.mem_depth
        if: _root.header.ch3_enabled
      - id: padding_3
        size: _root.header.bytes_per_channel_1 - _root.header.mem_depth
        if: _root.header.ch3_enabled
        
      - id: channel_4
        type: u1
        repeat: expr
        repeat-expr: _root.header.mem_depth
        if: _root.header.ch4_enabled
      - id: padding_4
        size: _root.header.bytes_per_channel_1 - _root.header.mem_depth
        if: _root.header.ch4_enabled

enums:
  acquistion_enum:
    0: normal
    1: average
    2: peak
    3: high_resolution
    
  bandwidth_enum:
    0: none
    1: mhz_20
    2: mhz_100
    3: mhz_200
    4: mhz_250

  coupling_enum:
    0: dc
    1: ac
    2: gnd

  filter_enum:
    0: low_pass
    1: high_pass
    2: band_pass
    3: band_reject
    
  impedance_enum:
    0: ohm_50
    1: ohm_1meg

  mem_depth:
    0: auto
    1: p_7k
    2: p_70k
    3: p_700k
    4: p_7m
    5: p_70m
    6: p_14k
    7: p_140k
    8: p_1m4
    9: p_14m
    10: p_140m

  probe_enum:
    0: single
    1: diff

  probe_ratio_enum:
    0: x0_01
    1: x0_02
    2: x0_05
    3: x0_1
    4: x0_2
    5: x0_5 
    6: x1
    7: x2
    8: x5
    9: x10
    10: x20
    11: x50
    12: x100
    13: x200
    14: x500
    15: x1000

  probe_type_enum:
    0: normal
    1: diff

  time_enum:
    0: yt
    1: xy
    2: roll

  unit_enum:
    0: watts
    1: amps
    2: volts
    3: unknown
    