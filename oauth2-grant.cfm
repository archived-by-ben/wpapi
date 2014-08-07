<!--- oauth2-grant.cfm --->

<cfparam name="FORM.grant_type" default="">
<cfparam name="FORM.client_id" default="">
<cfparam name="FORM.client_secret" default="">
<cfparam name="FORM.username" default="">
<cfparam name="FORM.password" default="">
<cfparam name="FORM.code" default="">
<cfparam name="FORM.redirect_uri" default="">

<cfset fileContentJSON = structNew()>

<cfif FORM.grant_type is "authorization_code">
	<cfset title = "authorisation code grant">
	<cfset option = "Step 5">
<cfelseif FORM.grant_type is "password">
	<cfset title = "client owner authentication token">
	<cfset option = "Option B">
<cfelse>
	<cfset title = "error">
	<cfset option = "error">
</cfif>

<!--- Generate a HTTP request to resource url and include the authorization token in the header --->
<cfhttp method="POST" url="https://public-api.wordpress.com/oauth2/token" result="result">
	<cfhttpparam type="formField" name="grant_type" value="#FORM.grant_type#"/>
	<cfhttpparam type="formField" name="client_id" value="#FORM.client_id#"/>
	<cfhttpparam type="formField" name="client_secret" value="#FORM.client_secret#"/>
	<cfif FORM.grant_type is "password">
		<cfhttpparam type="formField" name="username" value="#FORM.username#"/>
		<cfhttpparam type="formField" name="password" value="#FORM.password#"/>
	<cfelseif FORM.grant_type is "authorization_code">
		<cfhttpparam type="formField" name="code" value="#FORM.code#"/>
		<cfhttpparam type="formField" name="redirect_uri" value="#FORM.redirect_uri#"/>
	</cfif>
</cfhttp>

<!--- If the reply file content variable returns, expect JSON content. Deserialize it into a CFML structure. --->
<cfif structKeyExists(result, "filecontent")
	and IsJSON(result.filecontent)>
	<cfset fileContentJSON = DeserializeJSON(result.filecontent)>
</cfif>

<!--- HTML output --->
<!DOCTYPE html>
<html lang="en">
	<head>
		<link rel="stylesheet" href="css/bootstrap/css/bootstrap.min.css">
		<link rel="stylesheet" href="css/wpapi.css">
		<title><cfoutput>WPAPI #option# - #title#</cfoutput></title>
	</head>
	<body>
		<header>
			<h3><cfoutput>WPAPI #title# <small>#option#.</small></cfoutput></h3>
			<hr>
		</header>
		<cfoutput>
			<main class="container-fluid">
				<cfif structKeyExists(fileContentJSON, "access_token")>
					<div id="boldTokenContainer">
						<p>Congratulations, you can copy this authorization token and use it in the <span class="recommend">Fetch data from the WordPress.com API</span> (Part 3.) form on <a href="index.cfm">/index.cfm</a>.</p>
						<div class="well">
							<h2 id="boldToken" class="success"><cfoutput>#fileContentJSON.access_token#</cfoutput></h2>
						</div>
					</div>
					<hr>
				<cfelseif structKeyExists(fileContentJSON, "error")>
					<!--- Display any errors --->
					<div class="alert alert-danger" role="alert"><strong>#fileContentJSON.error#</strong> #fileContentJSON.error_description#</div>
				</cfif>
				<!--- Display the FORM variables passed on from index.cfm --->
				<cfdump var="#FORM#" label="FORM variables that were passed through to https://public-api.wordpress.com/oauth2/token">
				<hr>
				<!--- Dump the reply as a CFML structure --->
				<cfif structCount(fileContentJSON)>
					<cfdump var="#fileContentJSON#" label="public-api.wordpress.com reply">
				</cfif>
				<hr>
				<!--- dump the http post result to user --->
				<cfdump var="#result.responseheader#" label="HTTP reply from https://public-api.wordpress.com/oauth2/token">
			</main>
		</cfoutput>
		<footer>
			<hr>
			<p>Return to <a href="index.cfm">/index.cfm</a>.</p>
		</footer>
	</body>
</html>