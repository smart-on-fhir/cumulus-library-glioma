CREATE or replace VIEW glioma__cube_encounter_variable_union AS 
    WITH
    filtered_table AS (
        SELECT
            s.subject_ref,
            s.encounter_ref,
            --noqa: disable=RF03, AL02
            s."age_at_visit",
            s."display",
            s."enc_class_code",
            s."enc_period_ordinal",
            s."gender",
            s."variable"
            --noqa: enable=RF03, AL02
        FROM glioma__cohort_variable_union AS s
        WHERE s.status = 'finished'
    ),
    
    null_replacement AS (
        SELECT
            subject_ref,
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
        FROM filtered_table
    ),
    secondary_powerset AS (
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
        WHERE encounter_ref IS NOT NULL
        GROUP BY
            cube(
            "age_at_visit",
            "display",
            "enc_class_code",
            "enc_period_ordinal",
            "gender",
            "variable"
            )
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
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
        s.cnt_encounter_ref AS cnt,
        p."age_at_visit",
        p."display",
        p."enc_class_code",
        p."enc_period_ordinal",
        p."gender",
        p."variable"
    FROM powerset AS p
    JOIN secondary_powerset AS s on s.id = p.id
    WHERE 
        p.cnt_subject_ref >= 10
        AND s.cnt_encounter_ref >= 10
;