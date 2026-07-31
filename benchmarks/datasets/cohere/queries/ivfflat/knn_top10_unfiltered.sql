-- Guarded like the filtered queries: `emb` is TOASTed out of line, so the heap looks tiny to the
-- planner and an uncosted parallel seq scan + top-N heapsort can beat the ANN index on estimate
-- while running ~45x slower -- and scoring recall the index never achieved.
SET enable_seqscan=off; SET enable_bitmapscan=off; SET enable_sort=off; SET ivfflat.probes={{ probes_unfiltered }}; SELECT _id, title FROM cohere_wiki
ORDER BY emb <=> current_setting('cohere.qvec')::vector(1024)
LIMIT 10;
