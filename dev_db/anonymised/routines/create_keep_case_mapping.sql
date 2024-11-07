
DECLARE
    old_num CHAR(1);            -- Variable for digits 0-9 (old_num)
    new_num CHAR(1);            -- Variable for randomly shuffled new numbers (new_num)
    all_nums CHAR(1)[10];       -- Array containing digits 0-9
    shuffled_nums CHAR(1)[10];  -- Shuffled array of digits 0-9
    i INT;                      -- Index for iteration
BEGIN
    -- Create a permanent number_mapping table if it doesn't exist
    CREATE TABLE IF NOT EXISTS number_mapping (
        old_num CHAR(1) PRIMARY KEY,
        new_num CHAR(1) UNIQUE
    );

    -- Check if the mappings already exist. If not, create them.
    IF NOT EXISTS (SELECT 1 FROM number_mapping) THEN
        -- Step 1: Populate the array with digits 0-9
        all_nums := ARRAY['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

        -- Step 2: Shuffle the array to ensure uniqueness
        SELECT array_agg(val ORDER BY random()) INTO shuffled_nums
        FROM unnest(all_nums) AS val;

        -- Step 3: Insert unique mappings from shuffled array
        FOR i IN 1..array_length(all_nums, 1) LOOP
            INSERT INTO number_mapping (old_num, new_num)
            VALUES (all_nums[i], shuffled_nums[i]);
        END LOOP;
    END IF;
END;
