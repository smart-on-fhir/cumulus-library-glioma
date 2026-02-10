CREATE TABLE glioma__cube_patient_llm_progression AS (
    WITH
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(age_at_progression AS varchar),
                'cumulus__none'
            ) AS age_at_progression,
            coalesce(
                cast(clinical_trial_status AS varchar),
                'cumulus__none'
            ) AS clinical_trial_status,
            coalesce(
                cast(neurocognitive_risk AS varchar),
                'cumulus__none'
            ) AS neurocognitive_risk,
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
                cast(therapy_modality AS varchar),
                'cumulus__none'
            ) AS therapy_modality,
            coalesce(
                cast(visual_status AS varchar),
                'cumulus__none'
            ) AS visual_status
        FROM glioma__llm_progression
        
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "age_at_progression",
            "clinical_trial_status",
            "neurocognitive_risk",
            "progression",
            "progression_bin",
            "regrowth_pattern",
            "symptom_burden",
            "therapy_modality",
            "visual_status",
            concat_ws(
                '-',
                COALESCE("age_at_progression",''),
                COALESCE("clinical_trial_status",''),
                COALESCE("neurocognitive_risk",''),
                COALESCE("progression",''),
                COALESCE("progression_bin",''),
                COALESCE("regrowth_pattern",''),
                COALESCE("symptom_burden",''),
                COALESCE("therapy_modality",''),
                COALESCE("visual_status",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "age_at_progression",
            "clinical_trial_status",
            "neurocognitive_risk",
            "progression",
            "progression_bin",
            "regrowth_pattern",
            "symptom_burden",
            "therapy_modality",
            "visual_status"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
            p."age_at_progression",
            p."clinical_trial_status",
            p."neurocognitive_risk",
            p."progression",
            p."progression_bin",
            p."regrowth_pattern",
            p."symptom_burden",
            p."therapy_modality",
            p."visual_status"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
);