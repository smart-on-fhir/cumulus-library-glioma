create or replace view glioma__valueset_casedef_rx as
WITH
lower_str as
(
    select  lower(str) as display, *
    from    glioma__valueset_casedef_rx_union
),
freq_rxnorm as
(
    select  count(*) as tf, rxcui, display
    from    lower_str
    where   SAB='RXNORM'
    group   by rxcui, display
),
freq_vocab as
(
    select  count(*) as tf, rxcui, display
    from    lower_str
    where   SAB not in ('RXNORM', 'GS', 'NDDF', 'MMX', 'MMSL')
    and     rxcui not in (select distinct rxcui from freq_rxnorm)
    group   by rxcui, display
),
freq as
(
    select * from freq_rxnorm
    UNION ALL
    select * from freq_vocab
),
ranked as
(
    SELECT rxcui, display, tf
    FROM (
        SELECT
            rxcui,
            display,
            tf,
            row_number() OVER (
                PARTITION BY rxcui
                ORDER BY tf DESC, display ASC
            ) AS rn
        FROM freq
    ) t
    WHERE rn = 1
)
select  distinct
        'http://www.nlm.nih.gov/research/umls/rxnorm' as system,
        ranked.rxcui        as code,
        ranked.display      as display,
        rx_union.steward    as valueset,
        ranked.tf
 from   ranked,
        glioma__valueset_casedef_rx_union as rx_union
where   ranked.rxcui = rx_union.rxcui
order by ranked.rxcui ;