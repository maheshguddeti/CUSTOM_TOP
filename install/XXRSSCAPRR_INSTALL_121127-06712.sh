#!/bin/bash
#************************************************************************************************************+
#--File Name          :       XXRSSCAPRR_INSTALL_121127-06712.sh                                             | 
#--Program Purpose    :       Installation script for Rackspace Account Product Resource Report              |
#--Author Name        :       Pavan Amirineni                                                                |
#--Initial Build Date :       04-DEC-2012                                                                    |
#							                                                                        |
#--Version            :       1.0.0                                                                          |
#--Modification History                                                                                      |
#   | Ver   | Ticket No.   | Author          | Date        | Description                                     |
#------------------------------------------------------------------------------------------------------------+
#-- | 1.0.0 | 121127-06712 | Pavan Amirineni | 04-DEC-2012 | bug fix around dates                            |
#------------------------------------------------------------------------------------------------------------+
#************************************************************************************************************/
#/* $Header: XXRSSCAPRR_INSTALL_121127-06712.sh 1.0.0 29-FEB-2012 15:37:00 PM Vaibhav Goyal $ */
#--------------------------------------------------------------------------
# Set the environmental variables and other administrative requirements.
#--------------------------------------------------------------------------
 DATETIMESTAMP=`date +%Y%m%d%H%M%S`
 p_apps_usrn_pwd=$1
 jdbc=`echo $AD_APPS_JDBC_URL`
 CUSTOM_TOP=$XXRS_TOP
 SQL_DIR=$CUSTOM_TOP/install/sql
 LDT_DIR=$CUSTOM_TOP/install/ldt
 XML_DIR=$CUSTOM_TOP/xml
 LOG_DIR=$CUSTOM_TOP/log
 INSTALL_DIR=$CUSTOM_TOP/install
 OUTDIR=$CUSTOM_TOP/out
 OUTFILE=$OUTDIR/XXRSSCAPRR_INSTALL_121127-06712_$DATETIMESTAMP.out
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
}
#--------------------------------------------------------------------------
# Mailing output file
#--------------------------------------------------------------------------
MailOutFile()
{
 /bin/mail vaibhav.goyal@rackspace.com -c bruce.martinez@rackspace.com,tim.cowen@rackspace.com,vinodh.bhasker@rackspace.com -s "Installation log for Rackspace Account Product Resource Report in ${TWO_TASK}" < $OUTFILE
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
-LOB_TYPE DATA_TEMPLATE \
-APPS_SHORT_NAME XXRS \
-LOB_CODE XXRSSCAPRR \
-LANGUAGE en \
-TERRITORY US \
-XDO_FILE_TYPE XML \
-FILE_NAME ${XML_DIR}/XXRSSCAPRR.xml \
-NLS_LANG AMERICAN_AMERICA.UTF8 \
-CUSTOM_MODE FORCE >> $OUTFILE
}

Psswd

echo -e "\nLOADING XML Files...\n" >> $OUTFILE
LoadXMLFiles

echo -e "\nDone.\n" >> $OUTFILE

echo -e "\nEmailing the outfile.\n"
MailOutFile

echo -e "\nOutput file is ${OUTFILE}"
