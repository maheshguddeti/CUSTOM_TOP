#!/bin/bash

#************************************************************************************************************+
#--File Name          :       XXRSINVSTBCR_INSTALL_111122-02448.sh                                           |
#--Program Purpose    :       Installation script for Inventory Simplification Process                       |
#--Author Name        :       Vinodh Bhasker                                                                 |
#--Initial Build Date :       14-DEC-2011                                                                    |
#--                                                                                                          |
#--Version            :       1.0.0                                                                          |
#--Modification History                                                                                      |
#   | Ver   | Ticket No.   | Author          | Date        | Description                                     |
#------------------------------------------------------------------------------------------------------------+
#-- | 1.0.0 | 111122-02448 | Vinodh Bhasker  | 14-DEC-2011 | Initial Build                                   |
#------------------------------------------------------------------------------------------------------------+
#************************************************************************************************************/
#
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
 OUTFILE=$OUTDIR/XXRSINVSTBCR_INSTALL_111122-02448.out
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
@XXRS_CREATE_INV_OBJECTS.sql
@XXRS_FA_SUBASSEMBLY_PKG.pks
@XXRS_FA_SUBASSEMBLY_PKG.pkb
exit;
/
EOF
} 
#--------------------------------------------------------------------------
# Mailing output file
#--------------------------------------------------------------------------
MailOutFile()
{
  /bin/mail vinodh.bhasker@rackspace.com -c bruce.martinez@rackspace.com,tim.cowen@rackspace.com -s "Installation log for Rackspace Inventory Simplification Process in ${TWO_TASK}" < $OUTFILE
}
#--------------------------------------------------------------------------
# Using the FNDLOAD to load AOL objects
#--------------------------------------------------------------------------
LoadAOLData()
{
  cd ${LDT_DIR}

  FNDLOAD $p_apps_usrn_pwd O Y UPLOAD @FND:patch/115/import/afcpprog.lct XXRSFAADJSAL.ldt >> $OUTFILE

  FNDLOAD $p_apps_usrn_pwd 0 Y UPLOAD @FND:patch/115/import/afcpprog.lct XXRSINVSTBCR.ldt >> $OUTFILE

  FNDLOAD $p_apps_usrn_pwd 0 Y UPLOAD @FND:patch/115/import/afscprof.lct XXRS_INV_DEFAULT_DECOM_SUBINV.ldt >> $OUTFILE

  cat *.log >> $OUTFILE
  mv *.log ${LOG_DIR}
}
#--------------------------------------------------------------------------
# Using the XDOLOADER to load XML Publisher Files
#--------------------------------------------------------------------------
LoadXMLFiles()
{
  cd ${INSTALL_DIR}
   
java oracle.apps.xdo.oa.util.XDOLoader \
UPLOAD \
-DB_USERNAME $apps_login \
-DB_PASSWORD $apps_pwd \
-JDBC_CONNECTION $jdbc \
-LOB_TYPE XML_SAMPLE \
-APPS_SHORT_NAME XXRS \
-LOB_CODE XXRSINVSTBCR \
-LANGUAGE en \
-TERRITORY US \
-XDO_FILE_TYPE XML \
-FILE_NAME ${XML_DIR}/XXRSINVSTBCR_DATA.xml \
-NLS_LANG AMERICAN_AMERICA.UTF8 \
-CUSTOM_MODE FORCE >> $OUTFILE

java oracle.apps.xdo.oa.util.XDOLoader \
UPLOAD \
-DB_USERNAME $apps_login \
-DB_PASSWORD $apps_pwd \
-JDBC_CONNECTION $jdbc \
-LOB_TYPE DATA_TEMPLATE \
-APPS_SHORT_NAME XXRS \
-LOB_CODE XXRSINVSTBCR \
-LANGUAGE en \
-TERRITORY US \
-XDO_FILE_TYPE XML \
-FILE_NAME ${XML_DIR}/XXRSINVSTBCR.xml \
-NLS_LANG AMERICAN_AMERICA.UTF8 \
-CUSTOM_MODE FORCE >> $OUTFILE

java oracle.apps.xdo.oa.util.XDOLoader \
UPLOAD \
-DB_USERNAME $apps_login \
-DB_PASSWORD $apps_pwd \
-JDBC_CONNECTION $jdbc \
-LOB_TYPE TEMPLATE \
-APPS_SHORT_NAME XXRS \
-LOB_CODE XXRSINVSTBCR \
-LANGUAGE en \
-TERRITORY US \
-XDO_FILE_TYPE RTF \
-FILE_NAME ${XML_DIR}/XXRSINVSTBCR.rtf \
-NLS_LANG AMERICAN_AMERICA.UTF8 \
-CUSTOM_MODE FORCE >> $OUTFILE

java oracle.apps.xdo.oa.util.XDOLoader \
UPLOAD \
-DB_USERNAME $apps_login \
-DB_PASSWORD $apps_pwd \
-JDBC_CONNECTION $jdbc \
-LOB_TYPE XML_SAMPLE \
-APPS_SHORT_NAME XXRS \
-LOB_CODE XXRSINVSTBCF \
-LANGUAGE en \
-TERRITORY US \
-XDO_FILE_TYPE XML \
-FILE_NAME ${XML_DIR}/XXRSINVSTBCF.xml \
-NLS_LANG AMERICAN_AMERICA.UTF8 \
-CUSTOM_MODE FORCE >> $OUTFILE

java oracle.apps.xdo.oa.util.XDOLoader \
UPLOAD \
-DB_USERNAME $apps_login \
-DB_PASSWORD $apps_pwd \
-JDBC_CONNECTION $jdbc \
-LOB_TYPE TEMPLATE \
-APPS_SHORT_NAME XXRS \
-LOB_CODE XXRSINVSTBCF \
-LANGUAGE en \
-TERRITORY US \
-XDO_FILE_TYPE RTF \
-FILE_NAME ${XML_DIR}/XXRSINVSTBCF.rtf \
-NLS_LANG AMERICAN_AMERICA.UTF8 \
-CUSTOM_MODE FORCE >> $OUTFILE

  cat *.log >> $OUTFILE
  mv *.log ${LOG_DIR}
}
#--------------------------------------------------------------------------
# Set permissions on folders
#--------------------------------------------------------------------------
SetPermisssions()
{
  cd $JAVA_TOP/xxrs/oracle/apps

  chmod -R 750 $JAVA_TOP/xxrs/oracle/apps
} 
#--------------------------------------------------------------------------
# Download OA Framework Files
#--------------------------------------------------------------------------
Createfwkfiles() 
{
  cd $JAVA_TOP/xxrs/oracle/apps

  chmod -R 750 $JAVA_TOP/xxrs/oracle/apps

  tar xvzf $JAVA_TOP/xxrs/install/xxrs_oaf_inv_111122-02448.tar.gz
}

#---------------------------------------------------------------------
# Importing OAF pages
#---------------------------------------------------------------------
ImportOAFPages()
{
  cd $JAVA_TOP

#importing the page into MDS  
java oracle.jrad.tools.xml.importer.XMLImporter ./xxrs/oracle/apps/inv/util/webui/ChangeOrgRN.xml \
-rootdir $JAVA_TOP \
-username $apps_login \
-password $apps_pwd \
-dbconnection $jdbc >> $OUTFILE

#importing the page into MDS  
java oracle.jrad.tools.xml.importer.XMLImporter ./xxrs/oracle/apps/inv/invtxn/webui/ServerItemsPG.xml \
-rootdir $JAVA_TOP \
-username $apps_login \
-password $apps_pwd \
-dbconnection $jdbc >> $OUTFILE

#importing the page into MDS  
java oracle.jrad.tools.xml.importer.XMLImporter ./xxrs/oracle/apps/inv/invtxn/webui/BuildTrainRN.xml \
-rootdir $JAVA_TOP \
-username $apps_login \
-password $apps_pwd \
-dbconnection $jdbc >> $OUTFILE

#importing the page into MDS  
java oracle.jrad.tools.xml.importer.XMLImporter ./xxrs/oracle/apps/inv/invtxn/webui/BuildTrainFooterRN.xml \
-rootdir $JAVA_TOP \
-username $apps_login \
-password $apps_pwd \
-dbconnection $jdbc >> $OUTFILE

#importing the page into MDS  
java oracle.jrad.tools.xml.importer.XMLImporter ./xxrs/oracle/apps/inv/invtxn/webui/BuildSubassemblyPG.xml \
-rootdir $JAVA_TOP \
-username $apps_login \
-password $apps_pwd \
-dbconnection $jdbc >> $OUTFILE

#importing the page into MDS  
java oracle.jrad.tools.xml.importer.XMLImporter ./xxrs/oracle/apps/inv/invtxn/webui/BuildReviewPG.xml \
-rootdir $JAVA_TOP \
-username $apps_login \
-password $apps_pwd \
-dbconnection $jdbc >> $OUTFILE

#importing the page into MDS  
java oracle.jrad.tools.xml.importer.XMLImporter ./xxrs/oracle/apps/inv/invtxn/webui/AssignPartsPG.xml \
-rootdir $JAVA_TOP \
-username $apps_login \
-password $apps_pwd \
-dbconnection $jdbc >> $OUTFILE

#importing the page into MDS  
java oracle.jrad.tools.xml.importer.XMLImporter ./xxrs/oracle/apps/inv/invtxn/lov/webui/SubassemblyItemLovRN.xml \
-rootdir $JAVA_TOP \
-username $apps_login \
-password $apps_pwd \
-dbconnection $jdbc >> $OUTFILE

#importing the page into MDS  
java oracle.jrad.tools.xml.importer.XMLImporter ./xxrs/oracle/apps/inv/invtxn/lov/webui/PartLovRN.xml \
-rootdir $JAVA_TOP \
-username $apps_login \
-password $apps_pwd \
-dbconnection $jdbc >> $OUTFILE

#importing the page into MDS  
java oracle.jrad.tools.xml.importer.XMLImporter ./xxrs/oracle/apps/inv/invtxn/lov/webui/ChassisLovRN.xml \
-rootdir $JAVA_TOP \
-username $apps_login \
-password $apps_pwd \
-dbconnection $jdbc >> $OUTFILE
  
}
#--------------------------------------------------------------------------
# submitting Generate Messages concurrent program
#--------------------------------------------------------------------------
Submitconcprg()
{
  #submitting Generate Messages concurrent program
  cd ${INSTALL_DIR}
  
CONCSUB $p_apps_usrn_pwd SYSADMIN "System Administrator" SYSADMIN WAIT=N CONCURRENT FND FNDMDGEN '"US" "XXRS" "DB_TO_RUNTIME" "" ""'>> $OUTFILE
}
#--------------------------------------------------------------------------
# Calling Functions
#--------------------------------------------------------------------------
Psswd

echo -e "\nCREATIONG Database Objects...\n" >> $OUTFILE
CreateDBObjects

echo -e "\nLOADING AOL Data...\n" >> $OUTFILE
LoadAOLData

echo -e "\nLOADING XML Files...\n" >> $OUTFILE
LoadXMLFiles

echo -e "\nCHANGING permissions recursively on $JAVA_TOP/xxrs/oracle/apps/inv ...\n" >> $OUTFILE
SetPermisssions

echo -e "\nUNZIPPING OA Framework Components for inventory project to $JAVA_TOP/xxrs/oracle/apps/inv ...\n" >> $OUTFILE
Createfwkfiles

echo -e "\nCHANGING permissions recursively on $JAVA_TOP/xxrs/oracle/apps/inv ...\n" >> $OUTFILE
SetPermisssions

echo -e "\nIMPORTING OAF pages ...\n" >> $OUTFILE
ImportOAFPages

echo -e "\nSUBMITTING concurrent request to compile messages ...\n" >> $OUTFILE
Submitconcprg

echo -e "\nDone.\n" >> $OUTFILE

echo -e "\nEmailing the outfile.\n"
MailOutFile

echo -e "\nOutput file is ${OUTFILE}"
