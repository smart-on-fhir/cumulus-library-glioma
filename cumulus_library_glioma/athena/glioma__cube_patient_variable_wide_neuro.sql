CREATE or replace VIEW glioma__cube_patient_variable_wide_neuro AS 
    WITH
    filtered_table AS (
        SELECT
            s.subject_ref,
            --noqa: disable=RF03, AL02
            s."dx_focal_deficit",
            s."dx_neuro",
            s."dx_neurofibromatosis",
            s."dx_neuropathy",
            s."proc_neurosurgery"
            --noqa: enable=RF03, AL02
        FROM glioma__cohort_variable_wide AS s
    ),
    
    null_replacement AS (
        SELECT
            subject_ref,
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
            ) AS dx_neuropathy,
            coalesce(
                cast(proc_neurosurgery AS varchar),
                'cumulus__none'
            ) AS proc_neurosurgery
        FROM filtered_table
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "dx_focal_deficit",
            "dx_neuro",
            "dx_neurofibromatosis",
            "dx_neuropathy",
            "proc_neurosurgery",
            concat_ws(
                '-',
                COALESCE("dx_focal_deficit",''),
                COALESCE("dx_neuro",''),
                COALESCE("dx_neurofibromatosis",''),
                COALESCE("dx_neuropathy",''),
                COALESCE("proc_neurosurgery",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "dx_focal_deficit",
            "dx_neuro",
            "dx_neurofibromatosis",
            "dx_neuropathy",
            "proc_neurosurgery"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
        p."dx_focal_deficit",
        p."dx_neuro",
        p."dx_neurofibromatosis",
        p."dx_neuropathy",
        p."proc_neurosurgery"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
;