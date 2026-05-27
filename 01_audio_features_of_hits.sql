-- ============================================================
-- 01_audio_features_of_hits.sql
-- Q: What audio features do hit songs share?
-- ============================================================
-- "Hit" = popularity >= 70 (top ~5% of all tracks).
-- Compares average audio features for hits vs non-hits across
-- the full 114,000 track dataset.

SELECT
  CASE WHEN popularity >= 70 THEN 'Hit' ELSE 'Non-Hit' END AS song_tier,
  COUNT(*)                              AS n_songs,
  ROUND(AVG(danceability), 3)           AS avg_danceability,
  ROUND(AVG(energy), 3)                 AS avg_energy,
  ROUND(AVG(valence), 3)                AS avg_valence,
  ROUND(AVG(acousticness), 3)           AS avg_acousticness,
  ROUND(AVG(loudness), 2)               AS avg_loudness_db,
  ROUND(AVG(tempo), 1)                  AS avg_tempo_bpm,
  ROUND(AVG(duration_ms) / 1000, 1)     AS avg_duration_sec
FROM `spotify-analytics-497521.spotify.TRACKS`
GROUP BY song_tier
ORDER BY song_tier;


-- ============================================================
-- RESULTS:
-- ============================================================
-- | song_tier | n_songs | avg_dance | avg_energy | avg_valence | avg_acoustic | avg_loud_db | avg_tempo | avg_dur_sec |
-- |-----------|---------|-----------|------------|-------------|--------------|-------------|-----------|-------------|
-- | Hit       | 5,472   | 0.616     | 0.671      | 0.504       | 0.221        | -6.66       | 120.1     | 218.4       |
-- | Non-Hit   | 108,528 | 0.564     | 0.640      | 0.473       | 0.320        | -8.34       | 122.2     | 228.5       |

-- KEY FINDING:
-- Hits are +9% more danceable, +5% more energetic, and 31% LESS
-- acoustic than non-hits. Acousticness is the single biggest signal.
-- Tempo barely matters (120 vs 122 BPM).
