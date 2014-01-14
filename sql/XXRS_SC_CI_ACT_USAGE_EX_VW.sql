/**********************************************************************************************************************
*                                                                                                                     *
* NAME : XXRS_SC_CI_ACT_USAGE_EX_VW.sql                                                                               *
*                                                                                                                     *
* DESCRIPTION : View to support explicit resources in usage for  billing engine                                       *
*                                                                                                                     *
* AUTHOR       : Pavan Amirineni                                                                                      *
* DATE WRITTEN : 02/25/2012                                                                                           *
*                                                                                                                     *
* CHANGE CONTROL :                                                                                                    *
* Version# | Ticket #      | WHO             |  DATE      |   REMARKS                                                 *
*---------------------------------------------------------------------------------------------------------------------*
* 1.0.0    | 111122-02448  | Pavan Amirineni | 02/25/2012 | Initial Creation                                          *
* 1.0.1    | 130621-07223  | Pavan Amirineni | 08/14/2013 | modified po number logic                                  *
**********************************************************************************************************************/  
/* $Header:  XXRS_SC_CI_ACT_USAGE_EX_VW.sql 1.0.1 08/14/2013 03:00:00 PM Pavan Amirineni $ */ 
CREATE OR REPLACE FORCE VIEW apps.xxrs_sc_ci_act_usage_ex_vw
(
  org_id
,  cust_account_id
,  cust_acct_site_id
,  contract_snid
,  product_snid
,  resource_snid
,  product_def_snid
,  resource_def_snid
,  product_resource_def_snid
,  opportunity_num
,  device_num
,  support_team
,  account_manager_name
,  location_code
,  resource_name
,  spcl_price_flag
,  tiered_flag
,  quantity
,  unit_of_measure_code
,  unit_price
,  amount
,  receipt_method_id
,  bank_account_uses_id
,  po_number
,  prepay_months
,  product_name
,  ticket_num
,  excl_from_daily_bill_flag
,  resource_num
,  product_status_code
,  product_status_name
,  resource_billing_type_code
,  resource_billing_type_name
,  billing_start_date
,  billing_end_date
,  billed_date
,  date_cancelled
,  service_id
)
AS
  SELECT aprod.org_id
       ,  aprod.cust_account_id
       ,  aprod.cust_acct_site_id
       ,  aprod.contract_snid
       ,  aprod.account_product_snid "PRODUCT_SNID"
       ,  arsrc.account_resource_snid "RESOURCE_SNID"
       ,  aprod.product_def_snid
       ,  prdt.resource_def_snid
       ,  arsrc.product_resource_def_snid
       ,  cont.opportunity_num
       ,  LTRIM ( RTRIM ( arsrc.device_num ) ) "DEVICE_NUM"
       ,  cont.support_team
       ,  cont.account_manager_name
       ,  aprod.location_code "LOCATION_CODE"
       ,  rdt.resource_name
       ,  arsrc.spcl_price_flag
       ,  rdt.tiered_flag
       ,  0 "QUANTITY"
       ,            -- Cannot be defined since quantity comes from usage file.
        LTRIM ( RTRIM ( rdt.unit_of_measure_code ) ) "UNIT_OF_MEASURE_CODE"
       ,  CASE
            WHEN rdt.tiered_flag = 'N'
            THEN
              --#090224-05663 - For AutoFile - Fixed resources, if the Special Price checkbox is not selected,
              -- then an error should display on the billing engine log file stating - Unit price is -3 (error)
              -- even if the spcl price flag is selected and no unit price is mentioned it is still error.
              DECODE ( arsrc.spcl_price_flag
                     ,  'T', NVL ( arsrc.unit_price, -3 )
                     ,  -3
                      )
            --#090224-05663 - commented this code as spl pricing logic only applies for tiered
            --                xxrs_sc_ci_get_price_0001 (arsrc.billing_start_date
            --                                         , arsrc.spcl_price_flag
            --                                         , rdt.tiered_flag
            --                                         , aprod.org_id
            --                                         , aprod.cust_account_id
            --                                         , aprod.cust_acct_site_id
            --                                         , prdt.resource_def_snid
            --                                         , arsrc.account_resource_snid
            --                                         , arsrc.quantity
            --                                         , arsrc.unit_price
            --                                         , -3
            --                )
            WHEN rdt.tiered_flag = 'Y' -- PA R12 Changing flag from 'T' to 'Y' as per Genie Ticket # 111122-02448
            THEN
              0     -- Cannot be defined since quantity comes from usage file.
            ELSE
              -3                                                      -- error
          END
            "UNIT_SELLING_PRICE"
       ,  0 "AMOUNT"
       ,            -- Cannot be defined since quantity comes from usage file.
        aprod.receipt_method_id "RECEIPT_METHOD_ID"
       ,  aprod.bank_account_uses_id "BANK_ACCOUNT_USES_ID"
--          aprod.po_number "PO_NUMBER",
       ,  NVL(arsrc.po_number,aprod.po_number) "PO_NUMBER" -- 130621-07223
       ,  arsrc.prepay_months
       ,  pdt.product_name
       ,  cont.ticket_num
       ,                                    --           dprod.component_code,
          --           dprod.upgrade_fee,
          arsrc.exclude_from_billing_flag "EXCL_FROM_DAILY_BILL_FLAG"
       ,  arsrc.resource_num
       ,  aprod.product_status_code
       ,  ( SELECT flv.meaning
              FROM applsys.fnd_lookup_values flv
                 ,  applsys.fnd_application fa
             WHERE fa.application_short_name = 'XXRS'
               AND flv.language = USERENV ( 'LANG' )
               AND flv.view_application_id = fa.application_id
               AND flv.security_group_id = 0
               AND flv.lookup_type = 'RS_SC_PRODUCT_STATUS'
               AND flv.lookup_code = aprod.product_status_code
               AND flv.enabled_flag = 'Y'
               AND NVL ( arsrc.billing_start_date, SYSDATE ) BETWEEN NVL (
                                                                           flv.start_date_active
                                                                         ,  arsrc.billing_start_date
                                                                     )
                                                                 AND NVL (
                                                                           flv.end_date_active
                                                                         ,  arsrc.billing_start_date
                                                                     ) )
            product_status_name
       ,  rdt.resource_billing_type_code
       ,  ( SELECT flv.meaning
              FROM applsys.fnd_lookup_values flv
                 ,  applsys.fnd_application fa
             WHERE fa.application_short_name = 'XXRS'
               AND flv.language = USERENV ( 'LANG' )
               AND flv.view_application_id = fa.application_id
               AND flv.security_group_id = 0
               AND flv.lookup_type = 'XXRS_SC_RESOURCE_BILLING_TYPE'
               AND flv.lookup_code = rdt.resource_billing_type_code
               AND flv.enabled_flag = 'Y'
               AND NVL ( arsrc.billing_start_date, SYSDATE ) BETWEEN NVL (
                                                                           flv.start_date_active
                                                                         ,  arsrc.billing_start_date
                                                                     )
                                                                 AND NVL (
                                                                           flv.end_date_active
                                                                         ,  arsrc.billing_start_date
                                                                     ) )
            resource_billing_type_name
       ,  arsrc.billing_start_date
       ,  arsrc.billing_end_date
       ,  arsrc.billed_date
       ,  aprod.date_cancelled
       ,  aprod.service_id --110223-01761 --110223-01761# added as part of the product segment changes
    FROM xxrs.xxrs_sc_account_product_tbl aprod
       ,  xxrs.xxrs_sc_account_resource_tbl arsrc
       ,  xxrs.xxrs_sc_product_def_tbl pdt
       ,  xxrs.xxrs_sc_product_rsrc_def_tbl prdt
       ,  xxrs.xxrs_sc_resource_def_tbl rdt
       ,  xxrs.xxrs_sc_contract_tbl cont
   WHERE 1 = 1
     AND aprod.locked_flag != 'P'
     AND aprod.bill_flag = 'T'
     AND aprod.void_flag = 'F'
     AND arsrc.voided_flag = 'F'
     AND arsrc.account_product_snid = aprod.account_product_snid
     AND pdt.product_def_snid = aprod.product_def_snid
     AND aprod.product_status_code IN
           ( SELECT flv.lookup_code
               FROM applsys.fnd_lookup_values flv
                  ,  applsys.fnd_application fa
              WHERE fa.application_short_name = 'XXRS'
                AND flv.language = USERENV ( 'LANG' )
                AND flv.view_application_id = fa.application_id
                AND flv.security_group_id = 0
                AND flv.lookup_type = 'RS_SC_PRODUCT_STATUS'
                AND flv.meaning IN ('Active', 'Pending Cancellation')
                AND flv.enabled_flag = 'Y'
                AND NVL ( arsrc.billing_start_date, SYSDATE ) BETWEEN NVL (
                                                                            flv.start_date_active
                                                                          ,  arsrc.billing_start_date
                                                                      )
                                                                  AND NVL (
                                                                            flv.end_date_active
                                                                          ,  arsrc.billing_start_date
                                                                      ) )
     AND rdt.resource_billing_type_code IN
           ( SELECT flv.lookup_code
               FROM applsys.fnd_lookup_values flv
                  ,  applsys.fnd_application fa
              WHERE fa.application_short_name = 'XXRS'
                AND flv.language = USERENV ( 'LANG' )
                AND flv.view_application_id = fa.application_id
                AND flv.security_group_id = 0
                AND flv.lookup_type = 'XXRS_SC_RESOURCE_BILLING_TYPE'
                AND flv.meaning IN ('Auto/File')
                AND flv.enabled_flag = 'Y'
                AND NVL ( arsrc.billing_start_date, SYSDATE ) BETWEEN NVL (
                                                                            flv.start_date_active
                                                                          ,  arsrc.billing_start_date
                                                                      )
                                                                  AND NVL (
                                                                            flv.end_date_active
                                                                          ,  arsrc.billing_start_date
                                                                      ) )
     AND prdt.product_resource_def_snid = arsrc.product_resource_def_snid
     AND rdt.resource_def_snid = prdt.resource_def_snid
     AND pdt.product_type = 'A'
     AND rdt.resource_type = pdt.product_type
     AND cont.contract_snid = aprod.contract_snid;
/
