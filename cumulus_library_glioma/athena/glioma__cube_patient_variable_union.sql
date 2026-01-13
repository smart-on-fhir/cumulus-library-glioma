CREATE or replace VIEW glioma__cube_patient_variable_union AS 
    WITH
    filtered_table AS (
        SELECT
            s.subject_ref,
            --noqa: disable=RF03, AL02
            s."code",
            s."display",
            s."system",
            s."variable"
            --noqa: enable=RF03, AL02
        FROM glioma__cohort_variable_union AS s
    ),
    
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(code AS varchar),
                'cumulus__none'
            ) AS code,
            coalesce(
                cast(display AS varchar),
                'cumulus__none'
            ) AS display,
            coalesce(
                cast(system AS varchar),
                'cumulus__none'
            ) AS system,
            coalesce(
                cast(variable AS varchar),
                'cumulus__none'
            ) AS variable
        FROM filtered_table
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "code",
            "display",
            "system",
            "variable",
            concat_ws(
                '-',
                COALESCE("code",''),
                COALESCE("display",''),
                COALESCE("system",''),
                COALESCE("variable",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "code",
            "display",
            "system",
            "variable"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
        p."code",
        p."display",
        p."system",
        p."variable"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
;