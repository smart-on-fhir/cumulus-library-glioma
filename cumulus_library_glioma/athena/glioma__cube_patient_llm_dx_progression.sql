CREATE TABLE glioma__cube_patient_llm_dx_progression AS (
    WITH
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(age_at_dx AS varchar),
                'cumulus__none'
            ) AS age_at_dx,
            coalesce(
                cast(grade_code AS varchar),
                'cumulus__none'
            ) AS grade_code,
            coalesce(
                cast(histology AS varchar),
                'cumulus__none'
            ) AS histology,
            coalesce(
                cast(progression AS varchar),
                'cumulus__none'
            ) AS progression,
            coalesce(
                cast(progression_bin AS varchar),
                'cumulus__none'
            ) AS progression_bin,
            coalesce(
                cast(regrowth_pattern AS varchar),
                'cumulus__none'
            ) AS regrowth_pattern,
            coalesce(
                cast(symptom_burden AS varchar),
                'cumulus__none'
            ) AS symptom_burden,
            coalesce(
                cast(tumor_location AS varchar),
                'cumulus__none'
            ) AS tumor_location,
            coalesce(
                cast(tumor_size_mass_effect AS varchar),
                'cumulus__none'
            ) AS tumor_size_mass_effect,
            coalesce(
                cast(visual_status AS varchar),
                'cumulus__none'
            ) AS visual_status
        FROM glioma__llm_dx_progression
        
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "age_at_dx",
            "grade_code",
            "histology",
            "progression",
            "progression_bin",
            "regrowth_pattern",
            "symptom_burden",
            "tumor_location",
            "tumor_size_mass_effect",
            "visual_status",
            concat_ws(
                '-',
                COALESCE("age_at_dx",''),
                COALESCE("grade_code",''),
                COALESCE("histology",''),
                COALESCE("progression",''),
                COALESCE("progression_bin",''),
                COALESCE("regrowth_pattern",''),
                COALESCE("symptom_burden",''),
                COALESCE("tumor_location",''),
                COALESCE("tumor_size_mass_effect",''),
                COALESCE("visual_status",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "age_at_dx",
            "grade_code",
            "histology",
            "progression",
            "progression_bin",
            "regrowth_pattern",
            "symptom_burden",
            "tumor_location",
            "tumor_size_mass_effect",
            "visual_status"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
            p."age_at_dx",
            p."grade_code",
            p."histology",
            p."progression",
            p."progression_bin",
            p."regrowth_pattern",
            p."symptom_burden",
            p."tumor_location",
            p."tumor_size_mass_effect",
            p."visual_status"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
);