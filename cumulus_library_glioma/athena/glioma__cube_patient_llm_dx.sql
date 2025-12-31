CREATE or replace VIEW glioma__cube_patient_llm_dx AS
    WITH
    filtered_table AS (
        SELECT
            s.subject_ref,
            --noqa: disable=RF03, AL02
            s."behavior_display_best",
            s."behavior_has_mention",
            s."category_display_best",
            s."grade_display_best",
            s."grade_has_mention",
            s."morphology_display_best",
            s."morphology_has_mention",
            s."topography_display_best",
            s."topography_has_mention"
            --noqa: enable=RF03, AL02
        FROM glioma__llm_dx AS s
    ),
    
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(behavior_display_best AS varchar),
                'cumulus__none'
            ) AS behavior_display_best,
            coalesce(
                cast(behavior_has_mention AS varchar),
                'cumulus__none'
            ) AS behavior_has_mention,
            coalesce(
                cast(category_display_best AS varchar),
                'cumulus__none'
            ) AS category_display_best,
            coalesce(
                cast(grade_display_best AS varchar),
                'cumulus__none'
            ) AS grade_display_best,
            coalesce(
                cast(grade_has_mention AS varchar),
                'cumulus__none'
            ) AS grade_has_mention,
            coalesce(
                cast(morphology_display_best AS varchar),
                'cumulus__none'
            ) AS morphology_display_best,
            coalesce(
                cast(morphology_has_mention AS varchar),
                'cumulus__none'
            ) AS morphology_has_mention,
            coalesce(
                cast(topography_display_best AS varchar),
                'cumulus__none'
            ) AS topography_display_best,
            coalesce(
                cast(topography_has_mention AS varchar),
                'cumulus__none'
            ) AS topography_has_mention
        FROM filtered_table
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "behavior_display_best",
            "behavior_has_mention",
            "category_display_best",
            "grade_display_best",
            "grade_has_mention",
            "morphology_display_best",
            "morphology_has_mention",
            "topography_display_best",
            "topography_has_mention",
            concat_ws(
                '-',
                COALESCE("behavior_display_best",''),
                COALESCE("behavior_has_mention",''),
                COALESCE("category_display_best",''),
                COALESCE("grade_display_best",''),
                COALESCE("grade_has_mention",''),
                COALESCE("morphology_display_best",''),
                COALESCE("morphology_has_mention",''),
                COALESCE("topography_display_best",''),
                COALESCE("topography_has_mention",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "behavior_display_best",
            "behavior_has_mention",
            "category_display_best",
            "grade_display_best",
            "grade_has_mention",
            "morphology_display_best",
            "morphology_has_mention",
            "topography_display_best",
            "topography_has_mention"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
        p."behavior_display_best",
        p."behavior_has_mention",
        p."category_display_best",
        p."grade_display_best",
        p."grade_has_mention",
        p."morphology_display_best",
        p."morphology_has_mention",
        p."topography_display_best",
        p."topography_has_mention"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 1
;