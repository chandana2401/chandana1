view: derived_test {
  derived_table: {
    sql: SELECT
          `users`.`gender` AS `users.gender`,
              (DATE(CONVERT_TZ(`orders`.`created_at`,'UTC','America/Los_Angeles'))) AS `orders.created_date`
      FROM
          `demo_db`.`orders` AS `orders`
          LEFT JOIN `demo_db`.`users` AS `users` ON `orders`.`user_id` = `users`.`id`
          WHERE
        {% condition date_filter%} orders.created_at {% endcondition %}
      GROUP BY
          1,
          2
      ORDER BY
          (DATE(CONVERT_TZ(`orders`.`created_at`,'UTC','America/Los_Angeles'))) DESC
      LIMIT 500
       ;;
  }
  filter: date_filter {
    type: string
    suggest_dimension:orders.datefilter
    suggest_explore: orders
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: users_gender {
    type: string
    sql: ${TABLE}.`users.gender` ;;
  }

  dimension: orders_created_date {
    type: date
    sql: ${TABLE}.`orders.created_date` ;;
  }

  set: detail {
    fields: [users_gender, orders_created_date]
  }

  dimension: date_formatted {

    label: "Date_formatted"

    sql: ${orders_created_date} ;;
    drill_fields: [detail*]

   html:

    {% if _user_attributes['gender_a'] == 'm' %}

    {{linked_value}}

    {% endif %}

    {% if _user_attributes['gender_f'] == 'f' %}

    {{linked_value}}

    {% endif %};;
link: {
  label: "testing"
  url: "google.com"
}
    }

  #measure: average_of_fixed_fee{
   # type: average
    #sql: ${TABLE}.count ;;
    #description: "Average of fixed fee, excluding credits"
    #value_format: "#,##0"
    #html:
    #{% if _user_attributes['currency'] == 'GBP' %}
    #£{{linked_value}}
    #{% elsif _user_attributes['currency'] == 'AUD' %}
    #${{linked_value}}
    #{% elsif _user_attributes['currency'] == 'EUR' %}
    #€{{linked_value}}
    #{% elsif _user_attributes['currency'] == 'USD' %}
    #${{linked_value}}
    #{% else %}
    #{{linked_value}}
    #{% endif %}
    #;;
    #drill_fields: [detail*]
  #}

}
