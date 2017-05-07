# 10.8.77.107

dim_db.dbo.dimflt_airline
dim_db.dbo.dimflt_airport

dim_db.dbo.dimhtl_hotelbrand
dim_db.dbo.dimhtl_mgrgroup
dim_db.dbo.dimhotel

CustDB.dbo.DimClient where insertdt>='2016-01-01'
custdb.dbo.factbosuid
custdb.dbo.factcbcardcreditcard
CustDB.dbo.FactCustBossMP
custdb.dbo.factsmsrpt
custdb.dbo.factmktsms_upprocess
custdb.dbo.factmktsms_dnprocess
custdb.dbo.factmktuidmobile
custdb.dbo.factsubscription where insertdt>'2016-01-01'
custdb.dbo.factemailsubscription where insertdt>'2016-01-01'

dim_db.dbo.DimEmployee(@2017-02-15)

# hive

dw_mobdb.client  <-source_mobdb.client
dw_mobdb.members
dw_htldb.facthtlorder 
dw_fltdb.FactFltOrderPassenger
dw_fltdb.factfltorder
dw_fltdb.FactFltSegment


bimob
    bbz_pub
        kpi portal
            import kpi portals db
                dw
                    members(19872)


select * from source_mobdb.client limit 5;