CREATE TABLE glioma__cube_patient_llm_dx AS (
    WITH
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(age_at_dx AS varchar),
                'cumulus__none'
            ) AS age_at_dx,
            coalesce(
                cast(behavior_code AS varchar),
                'cumulus__none'
            ) AS behavior_code,
            coalesce(
                cast(grade_code AS varchar),
                'cumulus__none'
            ) AS grade_code,
            coalesce(
                cast(nf1_status AS varchar),
                'cumulus__none'
            ) AS nf1_status,
            coalesce(
                cast(tumor_location AS varchar),
                'cumulus__none'
            ) AS tumor_location,
            coalesce(
                cast(tumor_region AS varchar),
                'cumulus__none'
            ) AS tumor_region,
            coalesce(
                cast(tumor_size_mass_effect AS varchar),
                'cumulus__none'
            ) AS tumor_size_mass_effect
        FROM glioma__llm_dx
        
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "age_at_dx",
            "behavior_code",
            "grade_code",
            "nf1_status",
            "tumor_location",
            "tumor_region",
            "tumor_size_mass_effect",
            concat_ws(
                '-',
                COALESCE("age_at_dx",''),
                COALESCE("behavior_code",''),
                COALESCE("grade_code",''),
                COALESCE("nf1_status",''),
                COALESCE("tumor_location",''),
                COALESCE("tumor_region",''),
                COALESCE("tumor_size_mass_effect",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "age_at_dx",
            "behavior_code",
            "grade_code",
            "nf1_status",
            "tumor_location",
            "tumor_region",
            "tumor_size_mass_effect"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
            p."age_at_dx",
            p."behavior_code",
            p."grade_code",
            p."nf1_status",
            p."tumor_location",
            p."tumor_region",
            p."tumor_size_mass_effect"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
);