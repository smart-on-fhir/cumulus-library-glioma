CREATE or replace VIEW glioma__cube_encounter_variable_union AS 
    WITH
    null_replacement AS (
        SELECT
            encounter_ref,
            coalesce(
                cast(age_at_visit AS varchar),
                'cumulus__none'
            ) AS age_at_visit,
            coalesce(
                cast(display AS varchar),
                'cumulus__none'
            ) AS display,
            coalesce(
                cast(enc_class_code AS varchar),
                'cumulus__none'
            ) AS enc_class_code,
            coalesce(
                cast(enc_period_ordinal AS varchar),
                'cumulus__none'
            ) AS enc_period_ordinal,
            coalesce(
                cast(gender AS varchar),
                'cumulus__none'
            ) AS gender,
            coalesce(
                cast(variable AS varchar),
                'cumulus__none'
            ) AS variable
        FROM glioma__cohort_variable_union
        
    ),

    powerset AS (
        SELECT
            count(DISTINCT encounter_ref) AS cnt_encounter_ref,
            "age_at_visit",
            "display",
            "enc_class_code",
            "enc_period_ordinal",
            "gender",
            "variable",
            concat_ws(
                '-',
                COALESCE("age_at_visit",''),
                COALESCE("display",''),
                COALESCE("enc_class_code",''),
                COALESCE("enc_period_ordinal",''),
                COALESCE("gender",''),
                COALESCE("variable",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "age_at_visit",
            "display",
            "enc_class_code",
            "enc_period_ordinal",
            "gender",
            "variable"
            )
    )

    SELECT
        p.cnt_encounter_ref AS cnt,
            p."age_at_visit",
            p."display",
            p."enc_class_code",
            p."enc_period_ordinal",
            p."gender",
            p."variable"
    FROM powerset AS p
    WHERE 
        p.cnt_encounter_ref >= 10
;