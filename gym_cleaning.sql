-- 1. Check to see if the table has any NULL spaces.
/*
SELECT 
	* 
FROM 
	gym.gym_memberships
WHERE 
	id IS NULL 
	AND gender   IS NULL
	AND birthday IS NULL
	AND Age      IS NULL
	AND abonoment_type IS NULL
	AND visit_per_week IS NULL
	AND days_per_week IS NULL
	AND attend_group_lesson IS NULL
	AND fav_group_lesson IS NULL
	AND avg_time_check_in IS NULL
	AND avg_time_check_out IS NULL
	AND avg_time_in_gym IS NULL
	AND drink_abo IS NULL
	AND fav_drink IS NULL
	AND personal_training IS NULL
	AND name_personal_trainer iS NULL
	AND uses_sauna IS NULL
    */
    
-- 2. Make sure there are no empty values in the table. If there are, fill them in.
UPDATE gym.memberships
SET
	name_personal_trainer = "No Personal Trainer",
    fav_group_lesson = "No Favorite Lesson",
    fav_drink = "No Favorite Drink"
WHERE
	name_personal_trainer = '' OR
    fav_group_lesson = '' OR
    fav_drink = '';

-- 3. Make sure all the fields are in the correct datatype

-- 3a. Change birthday's data type from TEXT to DATE.
    ALTER TABLE gym.gym_memberships
	ADD COLUMN birthdate DATE;

    UPDATE gym.gym_memberships
	SET birthdate = STR_TO_DATE(birthday, '%m/%d/%y');

	ALTER TABLE gym.gym_memberships
	DROP COLUMN birthdate;

	ALTER TABLE gym.gym_memberships
	CHANGE birthdate birthday DATE;

	ALTER TABLE gym.gym_memberships
	MODIFY birthday DATE after gender;

-- 3b. Change attend_group_lessons, drink_abo, personal_training, and uses_sauna from TEXT to BIT
		-- 1. Add column with BIT datatype.
			ALTER TABLE gym.gym_memberships
			ADD COLUMN drinks_abo BIT;

		-- 2. Populate the new column (drinks_abo) with the old column (drink_abo) with BIT values.
			UPDATE gym.gym_memberships
			SET drinks_abo = CASE
				WHEN drink_abo = 'TRUE' THEN 1
				WHEN drink_abo = 'FAlSE' THEN 0
				ELSE NULL
			END;

		-- 3. DROP the old column (drink_abo).
			ALTER TABLE gym.gym_memberships
			DROP COLUMN drink_abo;

		-- 4. Rename the new column as the old column.
			ALTER TABLE gym.gym_memberships
			RENAME COLUMN drinks_abo TO drink_abo;

		-- 5. Modify the table to be in the right spot in the table. (OPTIONAL)
			ALTER TABLE gym.gym_memberships
			MODIFY drink_abo BIT AFTER avg_time_in_gym;

	-- REPEAT THIS WITH attend_group_lesson, personal_training, and uses_sauna. 
-- 4.

	-- Convert avg_time_check_in and avg_time_check_out to the TIME datatype. 
		ALTER TABLE gym.gym_memberships
		MODIFY avg_time_check_in TIME;
    
		ALTER TABLE gym.gym_memberships
		MODIFY avg_time_check_out TIME;
        
	-- When running the code, we will display the time in AM/PM format.
		SELECT
			DATE_FORMAT(avg_time_check_in, '%h:%i %p') AS avg_time_check_in,
            DATE_FORMAT(avg_time_check_out, '%h:%i %p') AS avg_time_check_out;

-- Run this code to display FINAL table.
SELECT 
	id,
    gender,
    birthday,
    Age,
    abonoment_type,
    visit_per_week,
    days_per_week,
    CASE attend_group_lesson
		WHEN 1 THEN 'TRUE'
        WHEN 0 THEN 'FALSE'
	END AS attend_group_lesson,
    fav_group_lesson,
    DATE_FORMAT(avg_time_check_in, '%h:%i %p') AS avg_time_check_in,
    DATE_FORMAT(avg_time_check_out, '%h:%i %p') AS avg_time_check_out,
    avg_time_in_gym,
    CASE drink_abo
		WHEN 1 THEN 'TRUE'
        WHEN 0 THEN 'FALSE'
	END AS drink_abo,
    fav_drink,
    CASE personal_training
		WHEN 1 THEN 'TRUE'
        WHEN 0 THEN 'FALSE'
	END AS personal_training,
    name_personal_trainer,
    CASE uses_sauna
		WHEN 1 THEN 'TRUE'
        WHEN 0 THEN 'FALSE'
	END AS uses_sauna
FROM 
	gym.gym_memberships