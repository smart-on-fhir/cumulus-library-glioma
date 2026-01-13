CREATE or replace VIEW glioma__cube_patient_variable_wide_dx AS 
    WITH
    filtered_table AS (
        SELECT
            s.subject_ref,
            --noqa: disable=RF03, AL02
            s."dx_brain_tumor",
            s."dx_cancer",
            s."dx_endo_diabetes",
            s."dx_focal_deficit",
            s."dx_neuro",
            s."dx_neurofibromatosis",
            s."dx_neuropathy"
            --noqa: enable=RF03, AL02
        FROM glioma__cohort_variable_wide AS s
    ),
    
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(dx_brain_tumor AS varchar),
                'cumulus__none'
            ) AS dx_brain_tumor,
            coalesce(
                cast(dx_cancer AS varchar),
                'cumulus__none'
            ) AS dx_cancer,
            coalesce(
                cast(dx_endo_diabetes AS varchar),
                'cumulus__none'
            ) AS dx_endo_diabetes,
            coalesce(
                cast(dx_focal_deficit AS varchar),
                'cumulus__none'
            ) AS dx_focal_deficit,
            coalesce(
                cast(dx_neuro AS varchar),
                'cumulus__none'
            ) AS dx_neuro,
            coalesce(
                cast(dx_neurofibromatosis AS varchar),
                'cumulus__none'
            ) AS dx_neurofibromatosis,
            coalesce(
                cast(dx_neuropathy AS varchar),
                'cumulus__none'
            ) AS dx_neuropathy
        FROM filtered_table
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "dx_brain_tumor",
            "dx_cancer",
            "dx_endo_diabetes",
            "dx_focal_deficit",
            "dx_neuro",
            "dx_neurofibromatosis",
            "dx_neuropathy",
            concat_ws(
                '-',
                COALESCE("dx_brain_tumor",''),
                COALESCE("dx_cancer",''),
                COALESCE("dx_endo_diabetes",''),
                COALESCE("dx_focal_deficit",''),
                COALESCE("dx_neuro",''),
                COALESCE("dx_neurofibromatosis",''),
                COALESCE("dx_neuropathy",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "dx_brain_tumor",
            "dx_cancer",
            "dx_endo_diabetes",
            "dx_focal_deficit",
            "dx_neuro",
            "dx_neurofibromatosis",
            "dx_neuropathy"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
        p."dx_brain_tumor",
        p."dx_cancer",
        p."dx_endo_diabetes",
        p."dx_focal_deficit",
        p."dx_neuro",
        p."dx_neurofibromatosis",
        p."dx_neuropathy"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
;