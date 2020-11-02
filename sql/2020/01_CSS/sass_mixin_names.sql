#standardSQL
CREATE TEMPORARY FUNCTION getMixinNames(payload STRING) RETURNS ARRAY<STRING> LANGUAGE js AS '''
try {
  var $ = JSON.parse(payload);
  var scss = JSON.parse($['_sass']);
  if (!scss.scss) {
    return [];
  }

  return Object.keys(scss.scss.stats.mixins);
} catch (e) {
  return [];
}
''';

SELECT
  client,
  mixin,
  COUNT(DISTINCT url) AS pages,
  total_pages,
  COUNT(DISTINCT url) / total_pages AS pct_pages,
  COUNT(0) AS freq,
  SUM(COUNT(0)) OVER (PARTITION BY client) AS total,
  COUNT(0) / SUM(COUNT(0)) OVER (PARTITION BY client) AS pct
FROM (
  SELECT
    _TABLE_SUFFIX AS client,
    url,
    mixin
  FROM
    `httparchive.pages.2020_08_01_*`,
    UNNEST(getMixinNames(payload)) AS mixin)
JOIN (
  SELECT
    _TABLE_SUFFIX AS client,
    COUNT(DISTINCT url) AS total_pages
  FROM
    `httparchive.pages.2020_08_01_*`
  GROUP BY
    _TABLE_SUFFIX)
USING
  (client)
GROUP BY
  client,
  mixin,
  total_pages
ORDER BY
  pct DESC
LIMIT
  1000