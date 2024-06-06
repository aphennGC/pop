view: order_items {
  sql_table_name: `bigquery-public-data.thelook_ecommerce.order_items` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension_group: created {
    view_label: "_PoP"
    type: time
    timeframes: [raw, time, date, hour_of_day,day_of_week,day_of_week_index,week,week_of_year, day_of_month,day_of_year,month,month_name,month_num, quarter, year]
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
    view_label: "_PoP"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    drill_fields: [created_date]
  }
  #####(Method 1a) you may also wish to create MTD and YTD filters in LookML
  dimension: wtd_only {
    group_label: "To-Date Filters"
    label: "WTD"
    view_label: "_PoP"
    type: yesno
    sql:  (EXTRACT(DOW FROM ${created_raw}) < EXTRACT(DOW FROM GETDATE())
                    OR
                (EXTRACT(DOW FROM ${created_raw}) = EXTRACT(DOW FROM GETDATE()) AND
                EXTRACT(HOUR FROM ${created_raw}) < EXTRACT(HOUR FROM GETDATE()))
                    OR
                (EXTRACT(DOW FROM ${created_raw}) = EXTRACT(DOW FROM GETDATE()) AND
                EXTRACT(HOUR FROM ${created_raw}) <= EXTRACT(HOUR FROM GETDATE()) AND
                EXTRACT(MINUTE FROM ${created_raw}) < EXTRACT(MINUTE FROM GETDATE())))  ;;
  }

  dimension: mtd_only {
    group_label: "To-Date Filters"
    label: "MTD"
    view_label: "_PoP"
    type: yesno
    sql: (
          EXTRACT(DAY FROM ${created_raw}) < EXTRACT(DAY FROM CURRENT_TIMESTAMP())
            OR
          (EXTRACT(DAY FROM ${created_raw}) = EXTRACT(DAY FROM CURRENT_TIMESTAMP()) AND
           EXTRACT(HOUR FROM ${created_raw}) < EXTRACT(HOUR FROM CURRENT_TIMESTAMP()))
            OR
          (EXTRACT(DAY FROM ${created_raw}) = EXTRACT(DAY FROM CURRENT_TIMESTAMP()) AND
           EXTRACT(HOUR FROM ${created_raw}) <= EXTRACT(HOUR FROM CURRENT_TIMESTAMP()) AND
           EXTRACT(MINUTE FROM ${created_raw}) < EXTRACT(MINUTE FROM CURRENT_TIMESTAMP()))
        );;
  }

  dimension: ytd_only {
    group_label: "To-Date Filters"
    label: "YTD"
    view_label: "_PoP"
    type: yesno
    sql: (
          (DATE_DIFF(${created_raw}, DATE_TRUNC(${created_raw}, YEAR), DAY) + 1) < DATE_DIFF(CURRENT_DATE(), DATE_TRUNC(CURRENT_DATE(), YEAR), DAY) + 1
            OR
          (DATE_DIFF(${created_raw}, DATE_TRUNC(${created_raw}, YEAR), DAY) + 1) = DATE_DIFF(CURRENT_DATE(), DATE_TRUNC(CURRENT_DATE(), YEAR), DAY) + 1 AND
          EXTRACT(HOUR FROM ${created_raw}) < EXTRACT(HOUR FROM CURRENT_TIMESTAMP())
            OR
          (DATE_DIFF(${created_raw}, DATE_TRUNC(${created_raw}, YEAR), DAY) + 1) = DATE_DIFF(CURRENT_DATE(), DATE_TRUNC(CURRENT_DATE(), YEAR), DAY) + 1 AND
          EXTRACT(HOUR FROM ${created_raw}) <= EXTRACT(HOUR FROM CURRENT_TIMESTAMP()) AND
          EXTRACT(MINUTE FROM ${created_raw}) < EXTRACT(MINUTE FROM CURRENT_TIMESTAMP())
        );;
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
