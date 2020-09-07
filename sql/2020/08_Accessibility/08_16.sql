#standardSQL
# 08_16: Divs or spans with role of button or link
SELECT
  client,
  COUNT(0) AS total_sites,
  COUNTIF(total_role_button > 0) AS sites_with_div_span_role_button,
  COUNTIF(total_role_link > 0) AS sites_with_div_span_role_link,
  COUNTIF(total_either > 0) AS sites_with_div_span_role_either,

  ROUND((COUNTIF(total_role_button > 0) / COUNT(0)) * 100, 2) AS pct_sites_with_div_span_role_button,
  ROUND((COUNTIF(total_role_link > 0) / COUNT(0)) * 100, 2) AS pct_sites_with_div_span_role_link,
  ROUND((COUNTIF(total_either > 0) / COUNT(0)) * 100, 2) AS pct_sites_with_div_span_role_either,

  SUM(total_role_button) AS total_div_span_role_button,
  SUM(total_role_link) AS total_div_span_role_link,
  SUM(total_either) AS total_div_span_role_either
FROM (
  SELECT
    _TABLE_SUFFIX AS client,
    CAST(JSON_EXTRACT_SCALAR(JSON_EXTRACT_SCALAR(payload, "$._a11y"), "$.divs_or_spans_as_button_or_link.total_role_button") AS INT64) AS total_role_button,
    CAST(JSON_EXTRACT_SCALAR(JSON_EXTRACT_SCALAR(payload, "$._a11y"), "$.divs_or_spans_as_button_or_link.total_role_link") AS INT64) AS total_role_link,
    CAST(JSON_EXTRACT_SCALAR(JSON_EXTRACT_SCALAR(payload, "$._a11y"), "$.divs_or_spans_as_button_or_link.total_either") AS INT64) AS total_either
  FROM
    `httparchive.almanac.pages_desktop_*`
)
GROUP BY
  client
