# The name of this view in Looker is "Orders"
view: orders {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: demo_db.orders ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
    html: {{rendered_value | date : "%y-%m-%d"}} ;;
  }
dimension: datefilter {
  type: string
  sql: ${created_date} ;;
}
  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Status" in Explore.

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
    link: {
      label: "Drill Dashboard"
      url: "/dashboards-next/137?Status={{value}}&Count={{orders.count._value|url_encode}}"
    }
    link: {
      label: "Passing filters"
      url: "/dashboards-next/137?Created Date={{ _filters['created_date'] | url_encode }}"
    }
  }
  dimension: status1 {
    case: {
      when: {
        sql: ${TABLE}.status = "pending" ;;
        label: "2019-01-01"
      }
      when: {
        sql: ${TABLE}.status = 1 ;;
        label: "complete"
      }
      when: {
        sql: ${TABLE}.status = 0 ;;
        label: "returned"
      }
      else: "unknown"
    }
  }
  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }
  measure: test {
    type: count_distinct
    sql: ${id} ;;
    drill_fields: [created_date,user_id]
    link: {
      label: "Drill as scatter plot"
      url: "
      {% assign vis_config = '{\"type\": \"looker_scatter\"}' %}
      {{ link }}&vis_config={{ vis_config | encode_uri }}&toggle=dat,pik,vis&limit=5000"
    }
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: link {
    type: number
    link: {
      label: "linked"
       url: "/dashboards-next/191?Created Date={{ _filters['orders.created_date'] | url_encode }}"
    }
    sql: ${id} ;;
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.id,
      users.first_name,
      users.last_name,
      billion_orders.count,
      fakeorders.count,
      hundred_million_orders.count,
      hundred_million_orders_wide.count,
      order_items.count,
      ten_million_orders.count
    ]
  }
}
