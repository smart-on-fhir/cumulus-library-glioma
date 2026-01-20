create  table glioma__cohort_casedef_rx_variable as
select  distinct
        valueset.valueset,
        rx.*
from    glioma__cohort_casedef_rx   as rx,
        glioma__valueset_casedef_rx as valueset
where   rx.rx_system= valueset.system
and     rx.rx_code  = valueset.code
;