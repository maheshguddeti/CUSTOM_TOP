<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" indent="yes" /> 
 
  <xsl:template match="XXRSARPCCP">
    <xsl:apply-templates />
  </xsl:template> 
 
  <xsl:template match="G_SUMMARY">
    <transRequest xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <xsl:attribute name="xsi:noNamespaceSchemaLocation">C:\OrbitalRequestSchemav024.xsd</xsl:attribute>
      <xsl:attribute name="RequestCount"><xsl:value-of select="CS_COUNT"/></xsl:attribute>
      <batchFileID>
         <userID><xsl:value-of select="CHASE_USER_ID"/></userID>
         <fileDateTime><xsl:value-of select="SYSTEM_TIMESTAMP"/></fileDateTime>
         <fileID><xsl:value-of select="FILE_ID"/></fileID>
      </batchFileID>
      <xsl:apply-templates select="G_NEW_ORDER"/>
    </transRequest>
  </xsl:template>
  
  <xsl:template match="G_NEW_ORDER">
    <newOrder>
      <xsl:attribute name="BatchRequestNo"><xsl:value-of select="BATCH_REQUEST_NO"/></xsl:attribute> 
      <industryType>
        <xsl:value-of select="INDUSTRY_TYPE" />
      </industryType>
      <transType>
        <xsl:value-of select="TRANS_TYPE" />
      </transType>
      <bin>
        <xsl:value-of select="BIN" />
      </bin>
      <merchantID>
        <xsl:value-of select="MERCHANT_ID" />
      </merchantID>
      <terminalID>
        <xsl:value-of select="TERMINAL_ID" />
      </terminalID>
      <xsl:if test="CARD_BRAND ='ED'">
      <cardBrand>
        <xsl:value-of select="CARD_BRAND" />
      </cardBrand>
      </xsl:if>
      <ccAccountNum>
        <xsl:value-of select="CC_ACCOUNT_NUMBER" />
      </ccAccountNum>
      <avsName>      
        <xsl:value-of select="AVS_NAME" />
      </avsName>
      <orderID>
        <xsl:value-of select="ORDER_ID" />
      </orderID>
      <amount>
        <xsl:value-of select="AMOUNT" />
      </amount>
      <comments>
        <xsl:value-of select="COMMENTS" />
      </comments>
      <euddCountryCode>
	 <xsl:value-of select="BANK_COUNTRY_CODE" />
      </euddCountryCode>
      <euddBankSortCode/>
      <euddRIBCode/>
    </newOrder>
  </xsl:template>
</xsl:stylesheet>