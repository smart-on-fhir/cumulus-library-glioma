create TABLE glioma__llm_dx_response as
select  distinct
        dx.age_at_dx,
        dx.grade_code,
        dx.grade_display,
        dx.behavior_code,
        dx.behavior_display,
        dx.histology,
        dx.tumor_location,
        dx.tumor_region,
        dx.tumor_size_mass_effect,
        dx.nf1_status,
        progression.progression,
        progression.regrowth_pattern,
        progression.symptom_burden,
        progression.visual_status,
        progression.neurocognitive_risk,
        progression.has_prior_radiotherapy,
        progression.subject_ref
from    glioma__llm_dx          as dx,
        glioma__llm_progression as progression
where   dx.subject_ref = progression.subject_ref
;
