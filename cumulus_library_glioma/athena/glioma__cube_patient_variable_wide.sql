CREATE or replace VIEW glioma__cube_patient_variable_wide AS 
    WITH
    filtered_table AS (
        SELECT
            s.subject_ref,
            --noqa: disable=RF03, AL02
            s."diag_brain_mri",
            s."diag_head_neck",
            s."diag_pathology",
            s."diag_radiology",
            s."dx_brain_tumor",
            s."dx_cancer",
            s."dx_endo_diabetes",
            s."dx_focal_deficit",
            s."dx_neuro",
            s."dx_neurofibromatosis",
            s."dx_neuropathy",
            s."lab_mtor_sirolimus",
            s."proc_neurosurgery",
            s."rx_cancer_directed",
            s."rx_chemo",
            s."rx_chemo_advanced",
            s."rx_chemo_bevacizumab",
            s."rx_chemo_platinum",
            s."rx_chemo_platinum_carboplatin",
            s."rx_chemo_vincristine",
            s."rx_endo_diabetes",
            s."rx_endo_therapy",
            s."rx_mtor_everolimus",
            s."rx_mtor_sirolimus"
            --noqa: enable=RF03, AL02
        FROM glioma__cohort_variable_wide AS s
    ),
    
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(diag_brain_mri AS varchar),
                'cumulus__none'
            ) AS diag_brain_mri,
            coalesce(
                cast(diag_head_neck AS varchar),
                'cumulus__none'
            ) AS diag_head_neck,
            coalesce(
                cast(diag_pathology AS varchar),
                'cumulus__none'
            ) AS diag_pathology,
            coalesce(
                cast(diag_radiology AS varchar),
                'cumulus__none'
            ) AS diag_radiology,
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
            ) AS dx_neuropathy,
            coalesce(
                cast(lab_mtor_sirolimus AS varchar),
                'cumulus__none'
            ) AS lab_mtor_sirolimus,
            coalesce(
                cast(proc_neurosurgery AS varchar),
                'cumulus__none'
            ) AS proc_neurosurgery,
            coalesce(
                cast(rx_cancer_directed AS varchar),
                'cumulus__none'
            ) AS rx_cancer_directed,
            coalesce(
                cast(rx_chemo AS varchar),
                'cumulus__none'
            ) AS rx_chemo,
            coalesce(
                cast(rx_chemo_advanced AS varchar),
                'cumulus__none'
            ) AS rx_chemo_advanced,
            coalesce(
                cast(rx_chemo_bevacizumab AS varchar),
                'cumulus__none'
            ) AS rx_chemo_bevacizumab,
            coalesce(
                cast(rx_chemo_platinum AS varchar),
                'cumulus__none'
            ) AS rx_chemo_platinum,
            coalesce(
                cast(rx_chemo_platinum_carboplatin AS varchar),
                'cumulus__none'
            ) AS rx_chemo_platinum_carboplatin,
            coalesce(
                cast(rx_chemo_vincristine AS varchar),
                'cumulus__none'
            ) AS rx_chemo_vincristine,
            coalesce(
                cast(rx_endo_diabetes AS varchar),
                'cumulus__none'
            ) AS rx_endo_diabetes,
            coalesce(
                cast(rx_endo_therapy AS varchar),
                'cumulus__none'
            ) AS rx_endo_therapy,
            coalesce(
                cast(rx_mtor_everolimus AS varchar),
                'cumulus__none'
            ) AS rx_mtor_everolimus,
            coalesce(
                cast(rx_mtor_sirolimus AS varchar),
                'cumulus__none'
            ) AS rx_mtor_sirolimus
        FROM filtered_table
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "diag_brain_mri",
            "diag_head_neck",
            "diag_pathology",
            "diag_radiology",
            "dx_brain_tumor",
            "dx_cancer",
            "dx_endo_diabetes",
            "dx_focal_deficit",
            "dx_neuro",
            "dx_neurofibromatosis",
            "dx_neuropathy",
            "lab_mtor_sirolimus",
            "proc_neurosurgery",
            "rx_cancer_directed",
            "rx_chemo",
            "rx_chemo_advanced",
            "rx_chemo_bevacizumab",
            "rx_chemo_platinum",
            "rx_chemo_platinum_carboplatin",
            "rx_chemo_vincristine",
            "rx_endo_diabetes",
            "rx_endo_therapy",
            "rx_mtor_everolimus",
            "rx_mtor_sirolimus",
            concat_ws(
                '-',
                COALESCE("diag_brain_mri",''),
                COALESCE("diag_head_neck",''),
                COALESCE("diag_pathology",''),
                COALESCE("diag_radiology",''),
                COALESCE("dx_brain_tumor",''),
                COALESCE("dx_cancer",''),
                COALESCE("dx_endo_diabetes",''),
                COALESCE("dx_focal_deficit",''),
                COALESCE("dx_neuro",''),
                COALESCE("dx_neurofibromatosis",''),
                COALESCE("dx_neuropathy",''),
                COALESCE("lab_mtor_sirolimus",''),
                COALESCE("proc_neurosurgery",''),
                COALESCE("rx_cancer_directed",''),
                COALESCE("rx_chemo",''),
                COALESCE("rx_chemo_advanced",''),
                COALESCE("rx_chemo_bevacizumab",''),
                COALESCE("rx_chemo_platinum",''),
                COALESCE("rx_chemo_platinum_carboplatin",''),
                COALESCE("rx_chemo_vincristine",''),
                COALESCE("rx_endo_diabetes",''),
                COALESCE("rx_endo_therapy",''),
                COALESCE("rx_mtor_everolimus",''),
                COALESCE("rx_mtor_sirolimus",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "diag_brain_mri",
            "diag_head_neck",
            "diag_pathology",
            "diag_radiology",
            "dx_brain_tumor",
            "dx_cancer",
            "dx_endo_diabetes",
            "dx_focal_deficit",
            "dx_neuro",
            "dx_neurofibromatosis",
            "dx_neuropathy",
            "lab_mtor_sirolimus",
            "proc_neurosurgery",
            "rx_cancer_directed",
            "rx_chemo",
            "rx_chemo_advanced",
            "rx_chemo_bevacizumab",
            "rx_chemo_platinum",
            "rx_chemo_platinum_carboplatin",
            "rx_chemo_vincristine",
            "rx_endo_diabetes",
            "rx_endo_therapy",
            "rx_mtor_everolimus",
            "rx_mtor_sirolimus"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
        p."diag_brain_mri",
        p."diag_head_neck",
        p."diag_pathology",
        p."diag_radiology",
        p."dx_brain_tumor",
        p."dx_cancer",
        p."dx_endo_diabetes",
        p."dx_focal_deficit",
        p."dx_neuro",
        p."dx_neurofibromatosis",
        p."dx_neuropathy",
        p."lab_mtor_sirolimus",
        p."proc_neurosurgery",
        p."rx_cancer_directed",
        p."rx_chemo",
        p."rx_chemo_advanced",
        p."rx_chemo_bevacizumab",
        p."rx_chemo_platinum",
        p."rx_chemo_platinum_carboplatin",
        p."rx_chemo_vincristine",
        p."rx_endo_diabetes",
        p."rx_endo_therapy",
        p."rx_mtor_everolimus",
        p."rx_mtor_sirolimus"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
;