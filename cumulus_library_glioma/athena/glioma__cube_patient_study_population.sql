CREATE TABLE glioma__cube_patient_study_population AS (
    WITH
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(age_at_visit AS varchar),
                'cumulus__none'
            ) AS age_at_visit,
            coalesce(
                cast(gender AS varchar),
                'cumulus__none'
            ) AS gender,
            coalesce(
                cast(race_display AS varchar),
                'cumulus__none'
            ) AS race_display
        FROM glioma__cohort_study_population
        
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "age_at_visit",
            "gender",
            "race_display",
            concat_ws(
                '-',
                COALESCE("age_at_visit",''),
                COALESCE("gender",''),
                COALESCE("race_display",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "age_at_visit",
            "gender",
            "race_display"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
            p."age_at_visit",
            p."gender",
            p."race_display"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
);