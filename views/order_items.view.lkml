view: order_items {
  sql_table_name: `bigquery-public-data.thelook_ecommerce.order_items` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension_group: created {
    type: time
    timeframes: [raw, time, date, hour_of_day,day_of_week,day_of_week_index,week,week_of_year, day_of_month,day_of_year,month,month_name,month_num, quarter,year]
    sql: ${TABLE}.created_at ;;
    convert_tz: no
  }
  dimension_group: delivered {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.delivered_at ;;
  }
  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }
  dimension: order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;
  }
  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }
  dimension_group: returned {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.returned_at ;;
  }
  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }
  dimension_group: shipped {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.shipped_at ;;
  }
  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }
  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }
  measure: count {
    label: "Count of Order Items"
    type: count
    drill_fields: [detail*]
  }

  measure: count_orders {
    label: "Count of orders"
    type: count_distinct
    sql: ${id} ;;
    hidden: yes
  }

  measure: total_sale_price {
    label: "Total Sales"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    drill_fields: [created_date]
  }

##### The Dynamic Period (MoM, YoY, WoW)
  parameter: compare_by {
    view_label: "Consecutive Block Method"
    label: "Comparison Period"
    type: unquoted
    allowed_value: { label: "Year over Year" value: "year" }
    allowed_value: { label: "Month over Month" value: "month" }
    allowed_value: { label: "Week over Week" value: "week"}
    default_value: "year"
  }

  dimension: current_period {
    view_label: "Consecutive Block Method"
    label_from_parameter: compare_by
    sql:
      {% if compare_by._parameter_value == 'year' %}
        ${created_year}
      {% elsif compare_by._parameter_value == 'month' %}
        ${created_month}
      {% else %}
        ${created_week}
      {% endif %} ;;
  }

  dimension: period_match_day {
    view_label: "Consecutive Block Method"
    label: "Day in Period"
    description: "Aligns days for comparison (e.g. Day 1 of 2023 vs Day 1 of 2024)"
    sql:
      {% if compare_by._parameter_value == 'year' %}
        ${created_day_of_year}
      {% elsif compare_by._parameter_value == 'month' %}
        ${created_day_of_month}
      {% else %}
        ${created_day_of_week_index}
      {% endif %} ;;
# HTML Logic to display Names for Weeks, but Numbers for others
    html:
      {% if compare_by._parameter_value == 'week' %}
        {% case value %}
          {% when 0 %} Monday
          {% when 1 %} Tuesday
          {% when 2 %} Wednesday
          {% when 3 %} Thursday
          {% when 4 %} Friday
          {% when 5 %} Saturday
          {% when 6 %} Sunday
        {% endcase %}
      {% else %}
        {{ rendered_value }}
      {% endif %} ;;
  }
  #The Limitation: Because Method 2 relies on the standard Created Date filter, you must select a continuous block of time.

  #If you filter for "Last 2 Weeks", you get the immediate last 2 weeks.

  #If you filter for "Last 2 Years" (to catch Week 50 2023 and 2024), you inevitably drag in every single week between them. Your chart would show 104 weeks, not just the two you want to compare.

  #####Method 3 (Custom Period Comparison)####
  filter: period_a_filter {
    view_label: "Custom Period Method"
    type: date
    label: "1. Current Period"
  }

  filter: period_b_filter {
    type: date
    view_label: "Custom Period Method"
    label: "2. Previous Period"
  }

  dimension: period_label {
    view_label: "Custom Period Method"
    description: "Pivot on this field to compare periods"
    sql:
      CASE
        WHEN {% condition period_a_filter %} ${created_raw} {% endcondition %}
        THEN 'Current Period'
        WHEN {% condition period_b_filter %} ${created_raw} {% endcondition %}
        THEN 'Previous Period'
        ELSE NULL
      END ;;
  }

  dimension: day_in_period {
    view_label: "Custom Period Method"
    label: "Days Since Start"
    type: number
    sql:
    CASE
    WHEN {% condition period_a_filter %} ${created_raw} {% endcondition %}
    -- calculate difference in Days between the two Timestamps directly
    THEN TIMESTAMP_DIFF(${created_raw}, {% date_start period_a_filter %}, DAY)

    WHEN {% condition period_b_filter %} ${created_raw} {% endcondition %}
    THEN TIMESTAMP_DIFF(${created_raw}, {% date_start period_b_filter %}, DAY)
    ELSE NULL
    END ;;
  }


  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
  id,
  users.last_name,
  users.id,
  users.first_name,
  inventory_items.id,
  inventory_items.product_name,
  products.name,
  products.id,
  orders.order_id
  ]
  }

}
