FROM openjdk:11.0.5-jdk as openjdk
FROM jboss/keycloak:latest

COPY docker-entrypoint.sh /opt/jboss/tools
COPY --from=openjdk /usr/local/openjdk-11/conf/security/java.security /etc/alternatives/jre/conf/security/

COPY idps/wechat-mobile/keycloak-services-social-weixin.jar \
    /opt/jboss/keycloak/providers/

COPY idps/wechat-mobile/templates/realm-identity-provider-weixin-ext.html \
    /opt/jboss/keycloak/themes/base/admin/resources/partials

COPY idps/wechat-mobile/templates/realm-identity-provider-weixin.html \
    /opt/jboss/keycloak/themes/base/admin/resources/partials

RUN sed -ie 's#<dependencies>#<dependencies><module name="com.google.code.gson" services="import"/>#' /opt/jboss/keycloak/modules/system/layers/keycloak/org/keycloak/keycloak-services/main/module.xml

COPY idps/wecom/keycloak-services-social-wechat-work.jar \
    /opt/jboss/keycloak/providers/

COPY idps/wecom/templates/realm-identity-provider-wechat-work.html \
    /opt/jboss/keycloak/themes/base/admin/resources/partials
COPY idps/wecom/templates/realm-identity-provider-wechat-work-ext.html \
    /opt/jboss/keycloak/themes/base/admin/resources/partials

# add `<module name="org.infinispan" services="import"/>` to dependencies
RUN sed -ie 's#<dependencies>#<dependencies><module name="org.infinispan" services="import"/>#' /opt/jboss/keycloak/modules/system/layers/keycloak/org/keycloak/keycloak-services/main/module.xml

#
#COPY idps/sms/keycloak-sms-authenticator.jar \
#    /opt/jboss/keycloak/providers/
#COPY idps/sms/templates/sms-validation.ftl \
#    /opt/jboss/keycloak/themes/base/login/
#COPY idps/sms/templates/sms-validation-error.ftl \
#    /opt/jboss/keycloak/themes/base/login/

ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]
CMD ["-b", "0.0.0.0"]

#COPY docker-entrypoint.sh /opt/jboss/tools
#COPY --from=openjdk /usr/local/openjdk-11/conf/security/java.security /etc/alternatives/jre/conf/security/
#
#COPY idps/wechat-mobile/0.0.5/keycloak-services-social-weixin-0.0.5.jar \
#    /opt/jboss/keycloak/providers/
#
#COPY idps/wechat-mobile/0.0.5/templates/realm-identity-provider-weixin.html \
#    /opt/jboss/keycloak/themes/base/admin/resources/partials
#
#COPY idps/wechat-mobile/0.0.5/templates/realm-identity-provider-weixin-ext.html \
#    /opt/jboss/keycloak/themes/base/admin/resources/partials
#
#ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]
#CMD ["-b", "0.0.0.0"]
#
