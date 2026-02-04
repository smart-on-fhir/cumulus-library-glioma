create table glioma__cohort_casedef_dx as
with excluded_codes as (
    select distinct code, system
    from glioma__valueset_casedef
),
filtered_dx as (
    select
        dx.subject_ref,
        dx.gender,
        dx.encounter_ref,
        dx.age_at_visit,
        coalesce(dx.dx_category_code, 'no_code') as dx_category_code,
        coalesce(dx.dx_code, 'no_code') as dx_code,
        coalesce(dx.dx_display, 'no_display') as dx_display,
        coalesce(dx.race_display, 'no_display') as race_display,
        dx.dx_system
    from glioma__cohort_study_population_dx as dx
    left join excluded_codes ev
      on dx.dx_code = ev.code
      and dx.dx_system = ev.system
    where ev.code is null
),
casedef_unique as (
    select distinct
        subject_ref, days_since, ordinal_since, pre, peri, peri_post, post
    from glioma__cohort_casedef
)
select
    c.days_since,
    c.ordinal_since,
    c.pre,
    c.peri,
    c.peri_post,
    c.post,
    f.*
from filtered_dx f
join casedef_unique c on f.subject_ref = c.subject_ref;
