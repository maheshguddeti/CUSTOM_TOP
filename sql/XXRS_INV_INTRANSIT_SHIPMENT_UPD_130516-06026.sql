/**************************************************************************************************************
* NAME : XXRS_INV_INTRANSIT_SHIPMENT_UPD_130516-06026.sql                                                           *
*                                                                                                             *
* DESCRIPTION :                                                                                               *
*   Script to update serial numbers for items intransit receipt is not able to received.                                   *
*                                                                                                             *
* AUTHOR       : Mahesh Guddeti                                                                                *
* DATE WRITTEN : 17-MAY-2013                                                                                  *
*                                                                                                             *
* CHANGE CONTROL :                                                                                            *
* Version#     |  Racker Ticket #  | WHO             |  DATE          |   REMARKS                             *
*-------------------------------------------------------------------------------------------------------------*
* 1.0.0        |  130516-06026     | Mahesh Guddeti   |  17-MAY-2013   | Initial Creation.                     *
***************************************************************************************************************/
--
/* $Header: XXRS_INV_INTRANSIT_SHIPMENT_UPD_130516-06026.sql 1.0.0 05/17/2013 11:30:00 AM Mahesh Guddeti $ */
--
SET SERVEROUTPUT ON SIZE 1000000
SET LINES 1000
SET PAGESIZE 1000
SET COLSEP '|'
COL file_name NEW_VALUE spool_file_name NOPRINT
SELECT 'XXRS_INV_INTRANSIT_SHIPMENT_UPD_130516-06026_'||TO_CHAR(SYSDATE,'YYYYMMDDHHMISS')||'.log' file_name
FROM DUAL;

SPOOL &spool_file_name

PROMPT "Before Updating Serial Numbers for items intransit receipt is not able to received"

SELECT serial_number
     , inventory_item_id
     , group_mark_id
     , line_mark_id
     , lot_line_mark_id 
FROM mtl_serial_numbers
WHERE inventory_item_id IN 
(36, 38, 499, 500, 502, 21002, 
58002, 190002, 348002, 502005, 
733019, 790017)
AND serial_number IN 
('1251974', '1251979', 'LD5036', 'LD5693', 
'W41097', 'W30529', 'W40802', 'W51134', 
'W41354', 'W57001', '1562794', '1291912', 
'1780237', '1956569', '1516395', '1637224', 
'1637227', '1981757', '1981758', '1981760', 
'1981761', '1981755', '1981858', '1981615', 
'1981617', '1981635', '1981658', '1981659', 
'1981664', '1981665', '1981670', '1981671', 
'1981672', '1981726', '1981727', '1980918', 
'1955903', '1981266', '1981892', '1981862', 
'1981863', '1981864', '1981865', '1981866', 
'1981867', '1981868', '1981869', '1981870', 
'1981871', '1981872', '1981873', '1981874', 
'1981875', '1981876', '1981877', '1981878', 
'1981879', '1981880', '1981881', '1981882', 
'1981883', '1981884', '1981885', '1981886', 
'1981887', '1981888', '1981889', '1981890', 
'1981891', '1981893', '1981894', '1981895', 
'1981896', '1981897', '1981898', '1981899', 
'1981900', '1981901', '1981902', '1981903', 
'1981904', '1981905', '1981906', '1981907', 
'1981908', '1981909', '1981764', '1981765')
and current_organization_id = 132
and group_mark_id IS NOT NULL
and line_mark_id IS NOT NULL
and lot_line_mark_id IS NOT NULL;

PROMPT "Updating Serial Numbers for items intransit receipt is not able to received"

UPDATE mtl_serial_numbers
SET group_mark_id = NULL,
line_mark_id = NULL, lot_line_mark_id = NULL
WHERE inventory_item_id IN
(36, 38, 499, 500, 502, 21002, 
58002, 190002, 348002, 502005, 
733019, 790017)
and serial_number IN
('1251974', '1251979', 'LD5036', 'LD5693', 
'W41097', 'W30529', 'W40802', 'W51134', 
'W41354', 'W57001', '1562794', '1291912', 
'1780237', '1956569', '1516395', '1637224', 
'1637227', '1981757', '1981758', '1981760', 
'1981761', '1981755', '1981858', '1981615', 
'1981617', '1981635', '1981658', '1981659', 
'1981664', '1981665', '1981670', '1981671', 
'1981672', '1981726', '1981727', '1980918', 
'1955903', '1981266', '1981892', '1981862', 
'1981863', '1981864', '1981865', '1981866', 
'1981867', '1981868', '1981869', '1981870', 
'1981871', '1981872', '1981873', '1981874', 
'1981875', '1981876', '1981877', '1981878', 
'1981879', '1981880', '1981881', '1981882', 
'1981883', '1981884', '1981885', '1981886', 
'1981887', '1981888', '1981889', '1981890', 
'1981891', '1981893', '1981894', '1981895', 
'1981896', '1981897', '1981898', '1981899', 
'1981900', '1981901', '1981902', '1981903', 
'1981904', '1981905', '1981906', '1981907', 
'1981908', '1981909', '1981764', '1981765')
AND current_organization_id = 132
AND group_mark_id IS NOT NULL
AND line_mark_id IS NOT NULL
AND lot_line_mark_id IS NOT NULL;   


PROMPT "After Updating Serial Number information for items intransit receipt in not able to received"
   
SELECT serial_number
     , inventory_item_id
     , group_mark_id
     , line_mark_id
     , lot_line_mark_id 
FROM mtl_serial_numbers
WHERE inventory_item_id IN 
(36, 38, 499, 500, 502, 21002, 
58002, 190002, 348002, 502005, 
733019, 790017)
AND serial_number IN 
('1251974', '1251979', 'LD5036', 'LD5693', 
'W41097', 'W30529', 'W40802', 'W51134', 
'W41354', 'W57001', '1562794', '1291912', 
'1780237', '1956569', '1516395', '1637224', 
'1637227', '1981757', '1981758', '1981760', 
'1981761', '1981755', '1981858', '1981615', 
'1981617', '1981635', '1981658', '1981659', 
'1981664', '1981665', '1981670', '1981671', 
'1981672', '1981726', '1981727', '1980918', 
'1955903', '1981266', '1981892', '1981862', 
'1981863', '1981864', '1981865', '1981866', 
'1981867', '1981868', '1981869', '1981870', 
'1981871', '1981872', '1981873', '1981874', 
'1981875', '1981876', '1981877', '1981878', 
'1981879', '1981880', '1981881', '1981882', 
'1981883', '1981884', '1981885', '1981886', 
'1981887', '1981888', '1981889', '1981890', 
'1981891', '1981893', '1981894', '1981895', 
'1981896', '1981897', '1981898', '1981899', 
'1981900', '1981901', '1981902', '1981903', 
'1981904', '1981905', '1981906', '1981907', 
'1981908', '1981909', '1981764', '1981765')
and current_organization_id = 132
AND group_mark_id IS NULL
AND line_mark_id IS NULL
AND lot_line_mark_id IS NULL;   
/