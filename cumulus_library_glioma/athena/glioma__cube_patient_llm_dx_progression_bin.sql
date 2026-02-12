CREATE TABLE glioma__cube_patient_llm_dx_progression_bin AS (
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
                cast(progression_bin AS varchar),
                'cumulus__none'
            ) AS progression_bin,
            coalesce(
                cast(symptom_burden_bin AS varchar),
                'cumulus__none'
            ) AS symptom_burden_bin,
            coalesce(
                cast(tumor_location AS varchar),
                'cumulus__none'
            ) AS tumor_location,
            coalesce(
                cast(tumor_size_mass_effect AS varchar),
                'cumulus__none'
            ) AS tumor_size_mass_effect,
            coalesce(
                cast(visual_status_bin AS varchar),
                'cumulus__none'
            ) AS visual_status_bin
        FROM glioma__llm_dx_progression
        
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "age_at_dx",
            "grade_code",
            "histology",
            "progression_bin",
            "symptom_burden_bin",
            "tumor_location",
            "tumor_size_mass_effect",
            "visual_status_bin",
            concat_ws(
                '-',
                COALESCE("age_at_dx",''),
                COALESCE("grade_code",''),
                COALESCE("histology",''),
                COALESCE("progression_bin",''),
                COALESCE("symptom_burden_bin",''),
                COALESCE("tumor_location",''),
                COALESCE("tumor_size_mass_effect",''),
                COALESCE("visual_status_bin",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "age_at_dx",
            "grade_code",
            "histology",
            "progression_bin",
            "symptom_burden_bin",
            "tumor_location",
            "tumor_size_mass_effect",
            "visual_status_bin"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
            p."age_at_dx",
            p."grade_code",
            p."histology",
            p."progression_bin",
            p."symptom_burden_bin",
            p."tumor_location",
            p."tumor_size_mass_effect",
            p."visual_status_bin"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
);