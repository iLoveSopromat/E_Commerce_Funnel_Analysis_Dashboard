SELECT  user_pseudo_id 
        ,event_name
        ,timestamp_micros(event_timestamp) as date
        ,(select ep.value.int_value from unnest(event_params) as ep where ep.key="ga_session_id") as ga_session_id
        ,(select 
        REGEXP_EXTRACT(ep.value.string_value, r'^https://shop\.googlemerchandisestore\.com/Google\+Redesign/(.*)$')
         from unnest(event_params) as ep where ep.key="page_location") as page_location
         ,(select ep.value.string_value from unnest(event_params) as ep where ep.key="page_title") as page_title
         ,traffic_source.medium as medium
         ,traffic_source.source as source
         ,device.category
         ,device.language
         ,device.operating_system
         ,geo.country
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` ga4
where event_name in ('session_start','view_item','add_to_cart','begin_checkout','add_shipping_info','add_payment_info','purchase')
and
_table_suffix between '20201101' and '20210131'