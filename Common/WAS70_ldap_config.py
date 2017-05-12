# Advanced Lightweight Directory Access Protocol (LDAP) user registry settings
AdminTask.configureAdminLDAPUserRegistry('[-userFilter (&(uid=%v)(objectclass=inetorgperson)(ou=caseinc)) -groupFilter (&(cn=%v)(objectclass=groupofuniquenames)(ou=caseinc)) -userIdMap *:uid -groupIdMap *:cn -groupMemberIdMap ibm-allGroups:member;ibm-allGroups:uniqueMember -certificateFilter -certificateMapMode EXACT_DN -krbUserFilter (&(krbPrincipalName=%v)(objectclass=ePerson)) -customProperties ["com.ibm.websphere.security.ldap.recursiveSearch="] -verifyRegistry false ]')

# Standalone LDAP registry setup
AdminTask.configureAdminLDAPUserRegistry('[-ldapHost pretender.rtp.raleigh.ibm.com -ldapPort 389 -ldapServerType IBM_DIRECTORY_SERVER -baseDN -bindDN cn=root -bindPassword tdsadmin -searchTimeout 120 -reuseConnection true -sslEnabled false -sslConfig -autoGenerateServerId true -primaryAdminId wasadmin -ignoreCase true -customProperties -verifyRegistry false ]') 

# Verify Registry
AdminTask.configureAdminLDAPUserRegistry('[-verifyRegistry true]')

# Set LDAP registry active
AdminTask.setAdminActiveSecuritySettings ('[-activeUserRegistry LDAPUserRegistry]')

# Save config
AdminConfig.save()