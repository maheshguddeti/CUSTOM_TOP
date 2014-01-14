#!/bin/bash
#
#************************************************************************************************************+
#--File Name          : XXRS_WS_SC_CONTRACT_HIST_INSTALL_111122-02448.sh                                     |
#--Program Purpose    : Install script to compile Objects to report customer contract history.               |
#--Author Name        : Vaibhav Goyal                                                                        |
#--Initial Build Date : 08-DEC-2011                                                                          | 
#--Version            : 1.0.0                                                                                |  
#--Ticket Number      : 111122-02448                                                                         |
#------------------------------------------------------------------------------------------------------------+
#--Modification History                                                                                      |
#------------------------------------------------------------------------------------------------------------+
#-- | 08-DEC-2011     | 1.0.0   | Vaibhav Goyal | Initial Build                                              |
#                                                                                                            |
#------------------------------------------------------------------------------------------------------------+
#************************************************************************************************************/
#
#--------------------------------------------------------------------------
# Set the environmental variables and other administrative requirements.
#--------------------------------------------------------------------------
DATETIMESTAMP=`date +%Y%m%d%H%M%S`
p_apps_usrn_pwd=$1
jdbc=$2
xxrs_pwd=$3
CUSTOM_TOP=$XXRS_TOP
SQL_DIR=$CUSTOM_TOP/install/sql
LDT_DIR=$CUSTOM_TOP/install/ldt
XML_DIR=$CUSTOM_TOP/xml
LOG_DIR=$CUSTOM_TOP/log
INSTALL_DIR=$CUSTOM_TOP/install
OUTDIR=$CUSTOM_TOP/out
OUTFILE=$OUTDIR/XXRS_WS_SC_CONTRACT_HIST_INSTALL_111122-02448.out
apps_login=apps
#--------------------------------------------------------------------------
# Define the function to get the APPS password.
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
  if [ -n "$xxrs_pwd" ];then
    echo ""
  else
    echo "Please enter XXRS Password=>"
    stty -echo
    read xxrs_pwd
    stty echo
  fi
}
#--------------------------------------------------------------------------
# Function to upload the responsibilities
#--------------------------------------------------------------------------
DbObjectsRegister()
{
cd $SQL_DIR
sqlplus -s xxrs/$xxrs_pwd << EOF
spool $OUTFILE
@XXRS_WS_SC_CONTRACT_HIST_TYPE.sql;
@XXRS_WS_SC_CONTRACT_HIST_GRANT1.sql;
conn $p_apps_usrn_pwd
@XXRS_WS_SC_CONTRACT_HIST_SYNONYM.sql;
@XXRS_WS_SC_CONTRACT_HIST_PKG.pks;
@XXRS_WS_SC_CONTRACT_HIST_PKG.pkb;
@XXRS_WS_SC_CONTRACT_HIST_GRANT2.sql;
exit;
/
EOF
}
#---------------------------------------------------------------------
# Call the functions					      
#---------------------------------------------------------------------

Psswd

DbObjectsRegister

echo -e "\nDone.\n" >> $OUTFILE
