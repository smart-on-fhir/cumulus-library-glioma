create TABLE glioma__valueset_casedef_rx_union          AS
select * from glioma__rx_ta_cancer_valuesets	    UNION ALL
select * from glioma__rx_class_alk_valuesets	    UNION ALL
select * from glioma__rx_class_alkylating_valuesets	UNION ALL
select * from glioma__rx_class_antimetabolite_valuesets	UNION ALL
select * from glioma__rx_class_braf_valuesets	    UNION ALL
select * from glioma__rx_class_fgfr_valuesets	    UNION ALL
select * from glioma__rx_class_idh_valuesets	    UNION ALL
select * from glioma__rx_class_mab_valuesets	    UNION ALL
select * from glioma__rx_class_mapk_valuesets	    UNION ALL
select * from glioma__rx_class_mek_valuesets	    UNION ALL
select * from glioma__rx_class_mtor_valuesets	    UNION ALL
select * from glioma__rx_class_ntrk_valuesets	    UNION ALL
select * from glioma__rx_class_pan_raf_valuesets	UNION ALL
select * from glioma__rx_class_platinum_valuesets	UNION ALL
select * from glioma__rx_class_vinca_valuesets	    UNION ALL
select * from glioma__rx_in_bevacizumab_valuesets	UNION ALL
select * from glioma__rx_in_carboplatin_valuesets	UNION ALL
select * from glioma__rx_in_cisplatin_valuesets	    UNION ALL
select * from glioma__rx_in_irinotecan_valuesets	UNION ALL
select * from glioma__rx_in_temozolomide_valuesets	UNION ALL
select * from glioma__rx_in_thioguanine_valuesets	UNION ALL
select * from glioma__rx_in_trametinib_valuesets	UNION ALL
select * from glioma__rx_in_vinblastine_valuesets	UNION ALL
select * from glioma__rx_in_vincristine_valuesets
;