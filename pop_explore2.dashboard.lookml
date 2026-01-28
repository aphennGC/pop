- name: add_a_unique_name_1769607302
  title: Untitled Visualization
  model: model_PoP
  explore: order_items
  type: looker_area
  fields: [order_items.created_day_of_month, order_items.total_sale_price, order_items.created_month_name]
  pivots: [order_items.created_month_name]
  filters:
    order_items.created_month_name: January,March
    order_items.created_year: '2023'
  sorts: [order_items.created_month_name, order_items.created_day_of_month desc]
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
  x_axis_gridlines: false
  y_axis_gridlines: true
  show_view_names: false
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
  limit_displayed_rows: false
  legend_position: center
  point_style: none
  show_value_labels: true
  label_density: 25
  x_axis_scale: auto
  y_axis_combined: true
  show_null_points: true
  interpolation: linear
  show_totals_labels: false
  show_silhouette: false
  totals_color: "#808080"
  y_axes: [{label: '', orientation: left, series: [{axisId: order_items.total_sale_price,
          id: January - 1 - order_items.total_sale_price, name: January - Order Items
            Total Sales}, {axisId: order_items.total_sale_price, id: March - 3 - order_items.total_sale_price,
          name: March - Order Items Total Sales}], showLabels: true, showValues: true,
      unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
    {label: !!null '', orientation: right, series: [{axisId: percent_change_from_previous_column_of_order_items_total_sales,
          id: March - 3 - percent_change_from_previous_column_of_order_items_total_sales,
          name: March - Percent change from previous column of Order Items Total Sales}],
      showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
      tickDensityCustom: 5, type: linear}]
  x_axis_zoom: true
  y_axis_zoom: true
  font_size: '10'
  series_types:
    March - 3 - percent_change_from_previous_column_of_order_items_total_sales: column
  series_colors:
    March - 3 - percent_change_from_previous_column_of_order_items_total_sales: "#EA4335"
  series_labels:
    March - 3 - percent_change_from_previous_column_of_order_items_total_sales: Percentage
      Change
  advanced_vis_config: |-
    {
      chart: {},
      "series": [
        {
          "name": "January - Order Items Total Sales",
          "dataLabels": {
            "enabled": false
          }
        },
        {
          "name": "March - Order Items Total Sales",
          "dataLabels": {
            "enabled": false
          }
        },
        {
          "name": "Percentage Change",
          "dataLabels": {
            "enabled": true
          }
        }
      ]
    }
  hidden_pivots:
    January|FIELD|1:
      measure_names:
      - percent_change_from_previous_column_of_order_items_total_sales
  defaults_version: 1
  ordering: none
  show_null_labels: false
