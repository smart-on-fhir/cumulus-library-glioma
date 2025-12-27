CREATE or replace VIEW glioma__cube_patient_llm AS 
    WITH
    filtered_table AS (
        SELECT
            s.subject_ref,
            --noqa: disable=RF03, AL02
            s."behavior_code",
            s."behavior_has_mention",
            s."grade_code",
            s."grade_has_mention",
            s."morphology_display",
            s."morphology_has_mention",
            s."topography_display",
            s."topography_has_mention"
            --noqa: enable=RF03, AL02
        FROM glioma__llm AS s
    ),
    
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(behavior_code AS varchar),
                'cumulus__none'
            ) AS behavior_code,
            coalesce(
                cast(behavior_has_mention AS varchar),
                'cumulus__none'
            ) AS behavior_has_mention,
            coalesce(
                cast(grade_code AS varchar),
                'cumulus__none'
            ) AS grade_code,
            coalesce(
                cast(grade_has_mention AS varchar),
                'cumulus__none'
            ) AS grade_has_mention,
            coalesce(
                cast(morphology_display AS varchar),
                'cumulus__none'
            ) AS morphology_display,
            coalesce(
                cast(morphology_has_mention AS varchar),
                'cumulus__none'
            ) AS morphology_has_mention,
            coalesce(
                cast(topography_display AS varchar),
                'cumulus__none'
            ) AS topography_display,
            coalesce(
                cast(topography_has_mention AS varchar),
                'cumulus__none'
            ) AS topography_has_mention
        FROM filtered_table
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "behavior_code",
            "behavior_has_mention",
            "grade_code",
            "grade_has_mention",
            "morphology_display",
            "morphology_has_mention",
            "topography_display",
            "topography_has_mention",
            concat_ws(
                '-',
                COALESCE("behavior_code",''),
                COALESCE("behavior_has_mention",''),
                COALESCE("grade_code",''),
                COALESCE("grade_has_mention",''),
                COALESCE("morphology_display",''),
                COALESCE("morphology_has_mention",''),
                COALESCE("topography_display",''),
                COALESCE("topography_has_mention",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "behavior_code",
            "behavior_has_mention",
            "grade_code",
            "grade_has_mention",
            "morphology_display",
            "morphology_has_mention",
            "topography_display",
            "topography_has_mention"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
        p."behavior_code",
        p."behavior_has_mention",
        p."grade_code",
        p."grade_has_mention",
        p."morphology_display",
        p."morphology_has_mention",
        p."topography_display",
        p."topography_has_mention"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 1
;