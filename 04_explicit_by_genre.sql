-- ============================================================
-- 04_explicit_by_genre.sql
-- Q: Does explicit content help or hurt hit rate? Does it vary by genre?
-- ============================================================
-- Compares hit rate for explicit vs non-explicit songs within 6 major
-- genres. The genre-level breakdown is the headline finding.

SELECT
  track_genre,
  explicit,
  COUNT(*)                                                              AS n_songs,
  ROUND(AVG(popularity), 1)                                             AS avg_popularity,
  ROUND(100.0 * SUM(CASE WHEN popularity >= 70 THEN 1 ELSE 0 END)
        / COUNT(*), 2)                                                  AS hit_rate_pct
FROM `spotify-analytics-497521.spotify.TRACKS`
WHERE track_genre IN ('hip-hop', 'pop', 'rock', 'country', 'r-n-b', 'metal')
GROUP BY track_genre, explicit
ORDER BY track_genre, explicit;


-- ============================================================
-- RESULTS:
-- ============================================================
-- | track_genre | explicit | n_songs | avg_pop | hit_rate_pct |
-- |-------------|----------|---------|---------|--------------|
-- | country     | false    | 970     | 16.3    | 8.87%        |
-- | country     | true     | 30      | 41.0    | 3.33%  <-- REVERSED
-- | hip-hop     | false    | 681     | 44.5    | 10.43%       |
-- | hip-hop     | true     | 319     | 23.3    | 19.75%       |
-- | metal       | false    | 858     | 42.4    | 20.51%       |
-- | metal       | true     | 142     | 51.7    | 28.87%       |
-- | pop         | false    | 926     | 47.0    | 29.48%       |
-- | pop         | true     | 74      | 54.4    | 59.46%  <-- 2x boost
-- | r-n-b       | false    | 912     | 35.7    | 1.97%        |
-- | r-n-b       | true     | 88      | 46.8    | 18.18%  <-- 9x boost
-- | rock        | false    | 957     | 18.6    | 19.33%       |
-- | rock        | true     | 43      | 27.3    | 30.23%       |

-- HEADLINE FINDING:
-- Pop:      29.48% (clean) -> 59.46% (explicit) = +30 points, ~2x boost
-- R&B:       1.97% (clean) -> 18.18% (explicit) = +16 points, ~9x boost
-- Metal:    20.51% (clean) -> 28.87% (explicit) = +8 points
-- Country:   8.87% (clean) ->  3.33% (explicit) = -5.5 points, REVERSED
--
-- Country is the ONLY major genre where explicit content cuts hit rate.
-- Every other genre rewards it.
--
-- Caveat: explicit-pop and explicit-country sample sizes are small (74
-- and 30 songs respectively), so the exact percentages have wider error
-- bars than the headline numbers suggest. But the DIRECTION of the effect
-- is robust.
