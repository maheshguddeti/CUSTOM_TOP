#!/bin/bash
#************************************************************************************************************+
#--File Name          :       XXRSARPREPAY_INSTALL_111122-02448.sh                                           | 
#--Program Purpose    :       Installation script for Rackspace Pre-Payments Report                          |
#--Author Name        :       Sreekanth Reddy N                                                              |
#--Initial Build Date :       25-JAN-2012                                                                    |
#							                                                                                 |
#--Version            :       1.0.0                                                                          |
#--Modification History                                                                                      |
#   | Ver   | Ticket No.   | Author          | Date        | Description                                     |
#------------------------------------------------------------------------------------------------------------+
#-- | 1.0.0 | 111122-02448 | Sreekanth Reddy | 25-JAN-2012 | R12 Upgradation                                 |
#------------------------------------------------------------------------------------------------------------+
#************************************************************************************************************/
#/* $Header: XXRSARPREPAY_INSTALL_111122-02448.sh 1.0.0 25-JAN-2012 15:37:00 PM Sreekanth $ */
#--------------------------------------------------------------------------
# Set the environmental variables and other administrative requirements.
#--------------------------------------------------------------------------
 DATETIMESTAMP=`date +%Y%m%d%H%M%S`
 p_apps_usrn_pwd=$1
 jdbc=$2
 CUSTOM_TOP=$XXRS_TOP
 SQL_DIR=$CUSTOM_TOP/install/sql
 LDT_DIR=$CUSTOM_TOP/install/ldt
 XML_DIR=$CUSTOM_TOP/xml
 LOG_DIR=$CUSTOM_TOP/log
 INSTALL_DIR=$CUSTOM_TOP/install
 OUTDIR=$CUSTOM_TOP/out
 OUTFILE=$OUTDIR/XXRSARPREPAY_INSTALL_111122-02448.out
 apps_login=apps
 
 echo `date` > $OUTFILE

#--------------------------------------------------------------------------
# Define the function to get the APPS and XXRS password.
#--------------------------------------------------------------------------
Psswd()
{
  if [ -n "$p_apps_usrn_pwd" ];then
    apps_pwd=${p_apps_usrn_pwd##*/}
  else
    echo "Please enter apps password =>"
    stty -echo
    read apps_pwd
    p_apps_usrn_pwd=apps/$apps_pwd
    stty echo
  fi
  if [ -n "$jdbc" ];then
    echo ""
  else
    echo "Please enter JDBC TNSNAMES Connection, (hostname:port:SID, dfw1svdevdbs02.ora.rackspace.com:1551:DEV)=>"
    read jdbc
  fi
}
#--------------------------------------------------------------------------
# Create Database Objects
#--------------------------------------------------------------------------
CreateDBObjects()
{
cd $SQL_DIR
sqlplus $p_apps_usrn_pwd << EOF
spool $OUTFILE
@XXRS_AR_PREPAY_PKG.pks
@XXRS_AR_PREPAY_PKG.pkb 
exit;
/
EOF
} 
#--------------------------------------------------------------------------
# Mailing output file
#--------------------------------------------------------------------------
MailOutFile()
{
  /bin/mail vinodh.bhasker@rackspace.com -c bruce.martinez@rackspace.com,tim.cowen@rackspace.com -s "Installation log for Rackspace Pre-Payments Report in ${TWO_TASK}" < $OUTFILE
}
#--------------------------------------------------------------------------
# Using the FNDLOAD to load AOL objects
#--------------------------------------------------------------------------
LoadAOLData()
{
  cd ${LDT_DIR}

   FNDLOAD $p_apps_usrn_pwd  O Y UPLOAD @FND:patch/115/import/afcpprog.lct $CUSTOM_TOP/install/ldt/XXRSARPREPAY.ldt CUSTOM_MODE='FORCE' >> $OUTFILE
   FNDLOAD $p_apps_usrn_pwd  O Y UPLOAD @FND:patch/115/import/afcpreqg.lct $CUSTOM_TOP/install/ldt/XXRSARPREPAY_REQ_ALL.ldt CUSTOM_MODE='FORCE' >> $OUTFILE
   FNDLOAD $p_apps_usrn_pwd  O Y UPLOAD @FND:patch/115/import/afcpreqg.lct $CUSTOM_TOP/install/ldt/XXRSARPREPAY_REQ_CON.ldt CUSTOM_MODE='FORCE' >> $OUTFILE
   FNDLOAD $p_apps_usrn_pwd  O Y UPLOAD @FND:patch/115/import/afcpreqg.lct $CUSTOM_TOP/install/ldt/XXRSARPREPAY_REQ_HK.ldt CUSTOM_MODE='FORCE' >> $OUTFILE
   FNDLOAD $p_apps_usrn_pwd  O Y UPLOAD @FND:patch/115/import/afcpreqg.lct $CUSTOM_TOP/install/ldt/XXRSARPREPAY_REQ_ONLY.ldt CUSTOM_MODE='FORCE' >> $OUTFILE
   FNDLOAD $p_apps_usrn_pwd  O Y UPLOAD @FND:patch/115/import/afcpreqg.lct $CUSTOM_TOP/install/ldt/XXRSARPREPAY_REQ_REC.ldt CUSTOM_MODE='FORCE' >> $OUTFILE
   FNDLOAD $p_apps_usrn_pwd  O Y UPLOAD @FND:patch/115/import/afcpreqg.lct $CUSTOM_TOP/install/ldt/XXRSARPREPAY_REQ_SC.ldt CUSTOM_MODE='FORCE' >> $OUTFILE
   FNDLOAD $p_apps_usrn_pwd  O Y UPLOAD @FND:patch/115/import/afcpreqg.lct $CUSTOM_TOP/install/ldt/XXRSARPREPAY_REQ_ADM.ldt CUSTOM_MODE='FORCE' >> $OUTFILE
   # Loading XML Data template and Template Definitions 
   FNDLOAD $p_apps_usrn_pwd  O Y UPLOAD @XDO:patch/115/import/xdotmpl.lct $CUSTOM_TOP/install/ldt/XXRSARPREPAY_XML.ldt CUSTOM_MODE='FORCE' >> $OUTFILE 

  cat *.log >> $OUTFILE
  mv *.log ${LOG_DIR}
}
#--------------------------------------------------------------------------
# Using the XDOLOADER to load XML Publisher Files
#--------------------------------------------------------------------------
LoadXMLFiles()
{
  cd ${INSTALL_DIR}
# Loading Data defination file
java oracle.apps.xdo.oa.util.XDOLoader \
UPLOAD \
-DB_USERNAME $apps_login \
-DB_PASSWORD $apps_pwd \
-JDBC_CONNECTION $jdbc \
-LOB_TYPE XML_SAMPLE \
-APPS_SHORT_NAME XXRS \
-LOB_CODE XXRSARPREPAY \
-LANGUAGE en \
-TERRITORY US \
-XDO_FILE_TYPE XML \
-FILE_NAME ${XML_DIR}/XXRSARPREPAY_PERVIEW.xml \
-NLS_LANG AMERICAN_AMERICA.UTF8 \
-CUSTOM_MODE FORCE >> $OUTFILE
# Loading Template or rtf file
java oracle.apps.xdo.oa.util.XDOLoader \
UPLOAD \
-DB_USERNAME $apps_login \
-DB_PASSWORD $apps_pwd \
-JDBC_CONNECTION $jdbc \
-LOB_TYPE TEMPLATE \
-APPS_SHORT_NAME XXRS \
-LOB_CODE XXRSARPREPAY \
-LANGUAGE en \
-TERRITORY US \
-XDO_FILE_TYPE RTF \
-FILE_NAME ${XML_DIR}/XXRSARPREPAY.rtf \
-NLS_LANG AMERICAN_AMERICA.UTF8 \
-CUSTOM_MODE FORCE >> $OUTFILE
  cat *.log >> $OUTFILE
  mv *.log ${LOG_DIR}
}
Psswd
echo -e "\nCREATIONG Database Objects...\n" >> $OUTFILE
CreateDBObjects

echo -e "\nLOADING AOL Data...\n" >> $OUTFILE
LoadAOLData

echo -e "\nLOADING XML Files...\n" >> $OUTFILE
LoadXMLFiles

echo -e "\nDone.\n" >> $OUTFILE

echo -e "\nEmailing the outfile.\n"
MailOutFile

echo -e "\nOutput file is ${OUTFILE}"
