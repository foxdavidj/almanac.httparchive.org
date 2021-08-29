#standardSQL
# Most used apps - mobile only
SELECT
  total_sites,

  category,
  app,
  COUNT(0) AS sites_with_app,
  COUNT(0) / total_sites AS pct_sites_with_app
FROM
  `httparchive.technologies.2021_07_01_mobile`
CROSS JOIN (
  SELECT
    COUNT(0) AS total_sites
  FROM
    `httparchive.summary_pages.2021_07_01_mobile`
)
GROUP BY
  total_sites,
  category,
  app
ORDER BY
  pct_sites_with_app DESC
