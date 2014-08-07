<!--- oauth2-authorize.cfm --->

<cfparam name="FORM.blog" default="">
<cfparam name="FORM.client_id" default="">
<cfparam name="FORM.redirect_uri" default="">
<cfparam name="FORM.response_type" default="token">

<!--- Generate a HTTP request to https://public-api.wordpress.com/oauth2/authorize  to request a temporary--->
<cfhttp method="POST" url="https://public-api.wordpress.com/oauth2/authorize" result="result">
	<cfhttpparam type="URL" name="client_id" value="#FORM.client_id#"/>
	<cfhttpparam type="URL" name="redirect_uri" value="#FORM.redirect_uri#"/>
	<cfhttpparam type="URL" name="blog" value="#FORM.blog#"/>
	<cfhttpparam type="URL" name="response_type" value="#FORM.response_type#"/>
</cfhttp>

<!--- HTML output --->
<!DOCTYPE html>
<html lang="en">
	<head>
		<link rel="stylesheet" href="css/bootstrap/css/bootstrap.min.css">
		<link rel="stylesheet" href="css/wpapi.css">
		<title>WPAPI Step 2 - authorize</title>
	</head>
	<body>
		<header>
			<h3>WordPress.com API authorize <small>Step 2.</small></h3>
			<hr>
		</header>
		<main class="container-fluid">
			<!--- Wait for then display the HTML reply from WordPress.com --->
			<cfoutput>#result.filecontent#</cfoutput>

			<!--- Display the FORM variables passed on from index.cfm --->
			<cfdump var="#FORM#" label="FORM variables that were passed through to https://public-api.wordpress.com/oauth2/authorize">
			
			<!--- Debug the HTTP response --->
			<cfdump var="#result#" label="HTTP reply from https://public-api.wordpress.com/oauth2/authorize" expand="false">
		</main>
	</body>
</html>