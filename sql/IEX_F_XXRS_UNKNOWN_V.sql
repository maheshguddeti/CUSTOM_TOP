/**********************************************************************************************************************
*                                                                                                                     *
* NAME : IEX_F_XXRS_UNKNOWN_V.sql                                                                                     *
*                                                                                                                     *
* DESCRIPTION : View to list delinquent customers who are not EMG, ENT, EMA,CRP                                       *
*                                                                                                                     *
* AUTHOR       : Pavan Amirineni                                                                                      *
* DATE WRITTEN : 12/05/2011                                                                                           *
*                                                                                                                     *
* CHANGE CONTROL :                                                                                                    *
* Version#  | Ticket #      | WHO             |  DATE          |   REMARKS                                            *
*---------------------------------------------------------------------------------------------------------------------*
* 1.0.0     | 111122-02448  | Pavan Amirineni | 12/05/2011     | Initial Creation                                     *
**********************************************************************************************************************/
/* $Header: IEX_F_XXRS_UNKNOWN_V.sql 1.0.0 12/05/2011 15:00:00 Pavan Amirineni$ */
CREATE OR REPLACE FORCE VIEW apps.iex_f_xxrs_unknown_v ( cust_account_id )
AS
  SELECT   cust_account_id
      FROM iex_delinquencies de
     WHERE 1 = 1
       AND de.status <> 'CURRENT'
       AND NOT EXISTS
             (SELECT 'X'
                FROM xxrs_ar_cust_multi_org_v
               WHERE cust_account_id = de.cust_account_id)
       AND NOT EXISTS
             (SELECT 'X'
                FROM apps.iex_f_xxrs_no_aging_v navw
               WHERE navw.cust_account_id = de.cust_account_id)
       AND EXISTS
             (SELECT 'X'
                FROM ar.hz_cust_accounts hca
                   ,  ar.hz_cust_acct_sites_all hcsa
                   ,  apps.xxrs_iex_team_mapping_v tmv
               WHERE 1 = 1
                 AND hca.cust_account_id = hcsa.cust_account_id
                 AND hca.cust_account_id = de.cust_account_id
                 AND tmv.parent_flex_value = 'NTM'
                 AND tmv.flex_value = hcsa.attribute2)
  GROUP BY de.cust_account_id;
/