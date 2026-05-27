-- ============================================================
-- 03_genre_analysis.sql
-- Q: Which genres consistently produce hits?
-- ============================================================
-- Top genres by hit rate. Dataset is balanced — 1,000 songs per genre,
-- so this comparison is fair (no genre has more hits just from having
-- more songs).

SELECT
  track_genre,
  COUNT(*)                                                              AS n_songs,
  ROUND(AVG(popularity), 1)                                             AS avg_popularity,
  MAX(popularity)                                                       AS top_popularity,
  SUM(CASE WHEN popularity >= 70 THEN 1 ELSE 0 END)                     AS n_hits,
  ROUND(100.0 * SUM(CASE WHEN popularity >= 70 THEN 1 ELSE 0 END)
        / COUNT(*), 2)                                                  AS hit_rate_pct
FROM `spotify-analytics-497521.spotify.TRACKS`
WHERE track_genre IS NOT NULL
GROUP BY track_genre
ORDER BY hit_rate_pct DESC
LIMIT 20;


-- ============================================================
-- RESULTS (top 10 of 20):
-- ============================================================
-- | track_genre       | n_songs | avg_pop | top_pop | n_hits | hit_rate_pct |
-- |-------------------|---------|---------|---------|--------|--------------|
-- | pop               | 1,000   | 47.6    | 100     | 317    | 31.7%  <-- king
-- | k-pop             | 1,000   | 56.9    | 88      | 225    | 22.5%        |
-- | metal             | 1,000   | 43.7    | 88      | 217    | 21.7%  <-- sleeper
-- | grunge            | 1,000   | 49.6    | 85      | 93     | 9.30%        |
-- | emo               | 1,000   | 48.1    | 87      | 78     | 7.80%        |
-- | british           | 1,000   | 43.8    | 87      | 73     | 7.30%        |
-- | pop-film          | 1,000   | 59.3    | 80      | 67     | 6.70%        |
-- | piano             | 1,000   | 45.3    | 96      | 59     | 5.90%        |
-- | progressive-house | 1,000   | 46.6    | 89      | 49     | 4.90%        |
-- | chill             | 1,000   | 53.7    | 93      | 46     | 4.60%        |

-- ZERO-HIT GENRES (for contrast):
-- | sertanejo         | 1,000   | 47.9    | 63      | 0      | 0.00%        |
-- | mandopop          | 1,000   | 45.0    | 71      | 1      | 0.10%        |
-- | pagode            | 1,000   | 44.3    | 84      | 4      | 0.40%        |

-- KEY FINDING:
-- Pop dominates (31.7%). K-pop second (22.5%). Metal is the surprise
-- at 21.7% — outperforming grunge, emo, and electronic.
-- Sertanejo (Brazilian country) and mandopop (Chinese pop) have ZERO
-- hits despite massive home-market followings, suggesting Spotify's
-- "popularity" metric is heavily English-language-weighted.
