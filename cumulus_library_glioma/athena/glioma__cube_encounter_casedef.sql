CREATE or replace VIEW glioma__cube_encounter_casedef AS 
    WITH
    null_replacement AS (
        SELECT
            encounter_ref,
            coalesce(
                cast(enc_class_code AS varchar),
                'cumulus__none'
            ) AS enc_class_code,
            coalesce(
                cast(enc_period_ordinal AS varchar),
                'cumulus__none'
            ) AS enc_period_ordinal,
            coalesce(
                cast(enc_servicetype_display AS varchar),
                'cumulus__none'
            ) AS enc_servicetype_display,
            coalesce(
                cast(enc_type_display AS varchar),
                'cumulus__none'
            ) AS enc_type_display
        FROM glioma__cohort_casedef
        
    ),

    powerset AS (
        SELECT
            count(DISTINCT encounter_ref) AS cnt_encounter_ref,
            "enc_class_code",
            "enc_period_ordinal",
            "enc_servicetype_display",
            "enc_type_display",
            concat_ws(
                '-',
                COALESCE("enc_class_code",''),
                COALESCE("enc_period_ordinal",''),
                COALESCE("enc_servicetype_display",''),
                COALESCE("enc_type_display",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "enc_class_code",
            "enc_period_ordinal",
            "enc_servicetype_display",
            "enc_type_display"
            )
    )

    SELECT
        p.cnt_encounter_ref AS cnt,
            p."enc_class_code",
            p."enc_period_ordinal",
            p."enc_servicetype_display",
            p."enc_type_display"
    FROM powerset AS p
    WHERE 
        p.cnt_encounter_ref >= 1
;