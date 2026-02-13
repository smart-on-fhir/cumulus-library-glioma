create table glioma__sample_casedef_peri_post_enc_with_dx as
select  distinct
        peri_post.*,
        casedef.dx_category_code,
        casedef.dx_system,
        casedef.dx_code,
        casedef.dx_display
from    glioma__sample_casedef_peri_post as peri_post,
        glioma__cohort_casedef as casedef
where   peri_post.encounter_ref = casedef.encounter_ref
and     casedef.dx_category_code is NOT null
;