<!--- api-call.cfm --->

<cfparam name="FORM.authorization" default="">
<cfparam name="FORM.blog" default="">
<cfparam name="FORM.resourceurl" default="">

<!--- Replace the string '%site-placeholder%' in the FORM.resourceurl with the value of FORM.blog--->
<cfif len(FORM.blog) gt 0
	and findNoCase("%site-placeholder%", FORM.resourceurl)>
	<cfset FORM.resourceurl = replaceNoCase(FORM.resourceurl, "%site-placeholder%", FORM.blog, "first")>
</cfif>

<cfset fileContentJSON = structNew()>

<!--- Generate a HTTP request to resource url and include the authorization token in the header --->
<cfhttp method="get" url="#FORM.resourceurl#/?pretty=1" result="result">
	<cfhttpparam type="header" name="authorization" value="Bearer #FORM.authorization#"/>
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
		<title>WPAPI Part 3 - API call</title>
	</head>
	<body>
		<header>
			<h3>WPAPI API call <small>Part 3.</small></h3>
			<hr>
		</header>
		<cfoutput>
			<main class="container-fluid">
				<div class="alert alert-info" role="alert">
					<strong>resourceurl</strong> #FORM.resourceurl#
				</div>

				<cfif structKeyExists(fileContentJSON, "error")>
					<!--- Display any errors --->
					<div class="alert alert-danger" role="alert"><strong>#fileContentJSON.error#</strong> #fileContentJSON.message#</div>
				</cfif>
				<!--- If the reply file content variable returns expect JSON content, dump it to user --->
				<cfdump var="#fileContentJSON#" label="WordPress.com API Results">
				
				<hr>
				<!--- dump the http post result to user --->
				<cfdump var="#result.responseheader#" label="HTTP reply from #FORM.resourceurl#">
			</main>
		</cfoutput>
		<footer>
			<hr>
			<p>Return to <a href="index.cfm">/index.cfm</a>.</p>
		</footer>
	</body>
</html>