-- ============================================================
-- 05_hit_recipe.sql
-- Q: What is the audio "recipe" of a top-tier hit?
-- ============================================================
-- Filters to the top 5% of tracks by popularity (95th percentile and
-- above), then averages every audio feature to characterize the
-- elite profile.

WITH top_5_pct AS (
  SELECT *
  FROM `spotify-analytics-497521.spotify.TRACKS`
  WHERE popularity >= (
    SELECT APPROX_QUANTILES(popularity, 100)[OFFSET(95)]
    FROM `spotify-analytics-497521.spotify.TRACKS`
  )
)
SELECT
  COUNT(*)                                                              AS n_songs_in_top_5pct,
  ROUND(AVG(popularity), 1)                                             AS avg_popularity,
  ROUND(AVG(danceability), 3)                                           AS hit_danceability,
  ROUND(AVG(energy), 3)                                                 AS hit_energy,
  ROUND(AVG(valence), 3)                                                AS hit_valence,
  ROUND(AVG(acousticness), 3)                                           AS hit_acousticness,
  ROUND(AVG(loudness), 2)                                               AS hit_loudness_db,
  ROUND(AVG(tempo), 1)                                                  AS hit_tempo_bpm,
  ROUND(AVG(duration_ms) / 1000.0, 0)                                   AS hit_duration_sec,
  ROUND(100.0 * SUM(CASE WHEN explicit THEN 1 ELSE 0 END)
        / COUNT(*), 1)                                                  AS pct_explicit
FROM top_5_pct;


-- ============================================================
-- RESULTS:
-- ============================================================
-- | n_songs | avg_pop | dance | energy | valence | acoustic | loud_db | tempo | dur_sec | explicit |
-- |---------|---------|-------|--------|---------|----------|---------|-------|---------|----------|
-- | 6,104   | 75.2    | 0.613 | 0.671  | 0.504   | 0.225    | -6.72   | 120.4 | 218     | 15.7%    |

-- THE HIT RECIPE:
-- - Tempo:         120 BPM (the danceable mid-tempo zone)
-- - Duration:      3:38 (218 seconds)
-- - Danceability:  0.61 (clearly above average)
-- - Energy:        0.67 (driven, not chill)
-- - Valence:       0.50 (neutral on happy-sad — neither overly happy
--                       nor overly sad outperforms)
-- - Acousticness:  0.22 (heavily produced, not acoustic)
-- - Loudness:      -6.7 dB (mastered loud for streaming)
-- - Explicit:      15.7% (most hits are NOT explicit — explicit boost
--                        only matters in specific genres like pop & R&B)
