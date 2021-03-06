<?php

if ($oauthdisc !== true) {
    echo xlt("Error. Not authorized");
    exit();
}

global $authServer;
$base_url = $authServer->authBaseFullUrl;

$passwordGrantString = '';
if (!empty($GLOBALS['oauth_password_grant'])) {
    $passwordGrantString = '"password",';
}

$discovery = <<<TEMPLATE
{
"issuer": "$authServer->authIssueFullUrl",
"authorization_endpoint": "$base_url/authorize",
"token_endpoint": "$base_url/token",
"jwks_uri": "$base_url/jwk",
"userinfo_endpoint": "$base_url/userinfo",
"registration_endpoint": "$base_url/registration",
"end_session_endpoint": "$base_url/logout",
"scopes_supported": [
    "openid",
    "profile",
    "name",
    "given_name",
    "family_name",
    "nickname",
    "phone",
    "phone_verified",
    "address",
    "email",
    "email_verified",
    "api:oemr",
    "api:fhir",
    "api:port",
    "api:pofh"
],
"response_types_supported": [
    "code",
    "token",
    "id_token",
    "code token",
    "code id_token",
    "token id_token",
    "code token id_token"
],
"code_challenge_methods_supported": [
    "S256",
    "plain"
],
"grant_types_supported": [
    "authorization_code",
    $passwordGrantString
    "refresh_token"
],
"response_modes_supported": [
    "query",
    "fragment",
    "form_post"
],
"subject_types_supported": [
    "public"
],
"claims_supported": [
    "aud",
    "email",
    "email_verified",
    "exp",
    "family_name",
    "given_name",
    "iat",
    "iss",
    "locale",
    "name",
    "sub"
],
"require_request_uri_registration": ["false"],
"id_token_signing_alg_values_supported": [
    "RS256"
],
"token_endpoint_auth_methods_supported": [
    "client_secret_post"
],
"token_endpoint_auth_signing_alg_values_supported": [
    "RS256"
]
}
TEMPLATE;

header('Content-Type: application/json');
echo($discovery);
