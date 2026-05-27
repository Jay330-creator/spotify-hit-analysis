-- ============================================================
-- 02_song_length_trends.sql
-- Q: Does song length predict popularity?
-- ============================================================
-- Buckets tracks by duration, computes hit rate per bucket.

SELECT
  CASE
    WHEN duration_ms < 120000 THEN '1. Under 2 min'
    WHEN duration_ms < 180000 THEN '2. 2-3 min'
    WHEN duration_ms < 240000 THEN '3. 3-4 min'
    WHEN duration_ms < 300000 THEN '4. 4-5 min'
    ELSE '5. Over 5 min'
  END AS duration_bucket,
  COUNT(*)                                                              AS n_songs,
  ROUND(AVG(popularity), 1)                                             AS avg_popularity,
  SUM(CASE WHEN popularity >= 70 THEN 1 ELSE 0 END)                     AS n_hits,
  ROUND(100.0 * SUM(CASE WHEN popularity >= 70 THEN 1 ELSE 0 END)
        / COUNT(*), 2)                                                  AS hit_rate_pct
FROM `spotify-analytics-497521.spotify.TRACKS`
GROUP BY duration_bucket
ORDER BY duration_bucket;


-- ============================================================
-- RESULTS:
-- ============================================================
-- | duration_bucket | n_songs | avg_popularity | n_hits | hit_rate_pct |
-- |-----------------|---------|----------------|--------|--------------|
-- | 1. Under 2 min  | 6,253   | 28.4           | 85     | 1.36%        |
-- | 2. 2-3 min      | 26,079  | 32.1           | 1,179  | 4.52%        |
-- | 3. 3-4 min      | 42,404  | 34.7           | 2,711  | 6.39%  <-- sweet spot
-- | 4. 4-5 min      | 22,889  | 34.7           | 1,073  | 4.69%        |
-- | 5. Over 5 min   | 16,375  | 31.1           | 424    | 2.59%        |

-- KEY FINDING:
-- 3-4 minute songs hit at 6.39% vs 1.36% for songs under 2 min.
-- That's nearly 5x the hit probability based on length alone.
-- Songs over 5 min and under 2 min are basically guaranteed flops.
