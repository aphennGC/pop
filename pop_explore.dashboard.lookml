- name: add_a_unique_name_1769607115
  title: Untitled Visualization
  model: model_PoP
  explore: order_items
  type: looker_grid
  fields: [order_items.current_period, order_items.period_match_day, order_items.total_sale_price]
  pivots: [order_items.current_period]
  filters:
    order_items.created_date: 4 weeks
    order_items.compare_by: week
  sorts: [order_items.current_period, order_items.period_match_day]
  limit: 500
  column_limit: 50
  dynamic_fields:
  - _kind_hint: measure
    _type_hint: number
    args:
    - order_items.total_sale_price
    based_on: order_items.total_sale_price
    calculation_type: percent_change_from_previous_column
    category: table_calculation
    label: Percent change from previous column of Order Items Total Sales
    source_field: order_items.total_sale_price
    table_calculation: percent_change_from_previous_column_of_order_items_total_sales
    value_format:
    value_format_name: percent_0
    is_disabled: true
  show_view_names: false
  show_row_numbers: true
  transpose: false
  truncate_text: true
  hide_totals: false
  hide_row_totals: false
  size_to_fit: true
  table_theme: white
  limit_displayed_rows: false
  enable_conditional_formatting: false
  header_text_alignment: left
  header_font_size: 12
  rows_font_size: 12
  conditional_formatting_include_totals: false
  conditional_formatting_include_nulls: false
  x_axis_gridlines: false
  y_axis_gridlines: true
  show_y_axis_labels: true
  show_y_axis_ticks: true
  y_axis_tick_density: default
  y_axis_tick_density_custom: 5
  show_x_axis_label: true
  show_x_axis_ticks: true
  y_axis_scale_mode: linear
  x_axis_reversed: false
  y_axis_reversed: false
  plot_size_by_field: false
  trellis: ''
  stacking: ''
  legend_position: center
  point_style: none
  show_value_labels: false
  label_density: 25
  x_axis_scale: auto
  y_axis_combined: true
  ordering: none
  show_null_labels: false
  show_totals_labels: false
  show_silhouette: false
  totals_color: "#808080"
  hidden_pivots: {}
  defaults_version: 1
  minimum_column_width: 75
  series_column_widths:
    order_items.period_match_day: 107
    2025-11-24_order_items.total_sale_price: 104
    2025-12-01_order_items.total_sale_price: 104
    2025-12-08_order_items.total_sale_price: 104
    2025-12-15_order_items.total_sale_price: 110
