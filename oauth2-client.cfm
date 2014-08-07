<!--- oauth2-client.cfm --->

<!--- Collect the settings --->
<cfinclude template="configuration.cfm">

<cfif structKeyExists(URL, "code")>
	<cfset title = "authorisation code grant">
	<cfset step = "4">
<cfelse>
	<cfset title = "implicit token grant">
	<cfset step = "3">
</cfif>

<!DOCTYPE html>
<html lang="en">
	<head>
		<link rel="stylesheet" href="css/bootstrap/css/bootstrap.min.css">
		<link rel="stylesheet" href="css/wpapi.css">
		<script>
			function fetchToken() {

			// Abort script if doing an authorisation code grant (the URL contains the CODE argument)
			if(window.location.search.indexOf('code=') > -1) { return; }

			/* This function decodes the fragment URL passed on by by public-api.wordpress.com.
			The fragment URL contains the WordPress OAuth2 authorisation 
			token or an error code as to why the token request was rejected.
			*/

			// Fetch the URL
			var url = document.URL;
			// Decode any special characters likely to be contained in the access_token
			var urlDecoded = decodeURIComponent(url);
			// Search for the position of the first occurrence of a hash character # in the URL. This hash character marks the URL fragment.
			var fragmentIndex = urlDecoded.indexOf("#");
			//  Fetch the complete string right of the URL fragment.
			var fragmentString = urlDecoded.slice(fragmentIndex+1);
			// Create an array containing the field names where are searching for.
			// They must be in the same order as they appear in the URL.
			var oauthItems = ["access_token", "expires_in", "token_type", "site_id"];
			// Create an JS object to store our results.
			var oauth = {};
			// These variables will temporary contain strings of text to search.
			var oauthPrefix = ""; // this will be the oauthItem field name.
			var oauthSuffix = ""; // this will be the following oauthItem field name.
			// These variables will character index positions of the successfully searched text in the two previous variables.
			var oauthPrefixIndex = "";
			var oauthSuffixIndex = "";

			// Check for errors in the reply, if so abort the JavaScript.
			if(fragmentString.indexOf('error=') >= 0) {
				document.getElementById('errorContainer').style.display="block";
				document.getElementById('fragmentBreakDown').style.display="none";
				document.getElementById('errorDescription').innerHTML=decodeURI(fragmentString);
				return;
			}

			// Loop through the oauthItems array.
			// This loop will slice and save the text contained within the two oauthItems.
			for (i = 0; i < oauthItems.length; ++i) {
				oauthPrefix = oauthItems[i]; // Get the oauthItems ie access_token
				oauthPrefixIndex = fragmentString.indexOf(oauthPrefix + "="); // Append an = equal sign to the oauthItems, ie access_token= and search for that in the fragmentString.

				if(i < oauthItems.length) {
					oauthSuffix = oauthItems[i+1]; // Get the following oauthItems ie expires_in
					oauthSuffixIndex = fragmentString.indexOf("&" + oauthSuffix + "="); // Append an = equal sign to the oauthItems, ie expires_in= and search for that in the fragmentString.
					// Using the oauthPrefixIndex and the oauthSuffixIndex we slice text contained within and save it to the oauth object as an item.
					// Ie. oauth["access_token"] = "abcedfgabcedfgabcedfgabcedfgabcedfgabcedfgabcedfgabcedfg";
					oauth[oauthPrefix] = fragmentString.slice(oauthPrefixIndex+oauthPrefix.length+1,oauthSuffixIndex);
				} else {
					// If this is the final oauthItems then we don't need to use the oauthSuffix and oauthSuffixIndex variables.
					oauth[oauthPrefix] = fragmentString.slice(oauthPrefixIndex+oauthPrefix.length+1);
				}
			}

			// Finally using all the data contained in our oauth object, we update the HTML.
			if (fragmentString.length > 0){
				document.getElementById('urlFragment').innerHTML=fragmentString;
			}
			if ("access_token" in oauth){
				document.getElementById('boldTokenContainer').style.display="block";
				document.getElementById('accessToken').innerHTML=oauth['access_token'];
				document.getElementById('boldToken').innerHTML=oauth['access_token'];
			}
			if ("expires_in" in oauth){
				document.getElementById('expiresIn').innerHTML=oauth['expires_in'];
			}
			if ("token_type" in oauth){
				document.getElementById('tokenType').innerHTML=oauth['token_type'];
			}
			if ("site_id" in oauth){
				document.getElementById('siteId').innerHTML=oauth['site_id'];
			}
		}
		</script>
		<title><cfoutput>WPAPI Step #step# - #title#</cfoutput></title>
	</head>
	<body onload="fetchToken();">
		<header>
			<h3><cfoutput>WPAPI #title# <small>Step #step#.</small></cfoutput></h3>
			<hr>
		</header>

	<cfif structKeyExists(URL, "code")>
		<cfoutput>
		<!--- Page to display when a security code is given (authorisation code grant) --->
		<main class="container-fluid">
			<!--- Container to display the granted security code --->
			<div class="well">
				<h2 id="boldToken" class="success">#URL.code#</h2>
			</div>
			<!--- Form used to submit the security code. The security code is required when you request an authentication token with no expiry time. --->
			<div class="row">
				<div class="col-md-5">
					<h3 class="recommend">Get an authentication token <small>Option A.</small></h3>
					<p>This is the preferred and recommended method of authenticating with WordPress.com's API. It requests a standard user authentication token.</p>
					<!--- POST to oauth2-authorize.cfm --->
					<form action="oauth2-grant.cfm" method="post">
						<div class="form-group">
							<label for="blog">Site <small><kbd>blog</kbd></small></label>
							<input type="text" class="form-control" name="blog" value="#api_application.site#" placeholder="WordPress.com blog URL">
							<p class="help-block">Do not include the http:// scheme.</p>
						</div>
						<div class="form-group">
							<label for="client_id">Client ID <small><kbd>client_id</kbd></small></label>
							<input type="number" class="form-control" name="client_id" value="#api_application.client_id#">
						</div>
						<div class="form-group">
							<label for="authorization">Redirect URL <small><kbd>redirect_uri</kbd></small></label>
							<input type="url" class="form-control" name="redirect_uri" value="#api_application.redirect_uri#">
						</div>
						<div class="form-group">
							<label for="code">Code Authentication <small><kbd>code</kbd></small></label>
							<input type="text" class="form-control" name="code" value="#URL.code#">
						</div>
						<div class="form-group">
							<label for="grant_type">Grant Type <small><kbd>grant_type</kbd></small></label>
							<input type="text" class="form-control" name="grant_type" value="authorization_code" readonly>
						</div>

						<button type="submit" class="btn btn-default" name="submit">Request standard access</button>
						<button type="reset" class="btn btn-default">Reset</button>
					</form>
				</div>
			</div>
		</main>
		</cfoutput>

	<cfelse>
		<!--- Page to display when tokens are passed through as URL fragments (implicit token grant)  --->
		<main class="container-fluid">
			<!--- Container to display the granted token --->
			<div id="boldTokenContainer" style="display: none;">
				<p>Congratulations, you can copy this authorization token and use it in the <span class="recommend">Fetch data from the WordPress.com API</span> (Part 3.) form on <a href="index.cfm#part3">/index.cfm</a>.</p>
				<div class="well">
					<h2 id="boldToken" class="success"></h2>
				</div>
				<hr>
				<p>If successful there should be a long string above this text and a longer string attached to the URL of this page. This is the OAuth2 authorisation token that is passed by Wordpress.com to your browser as a URL fragment. The CFML server does not and cannot read the data in a URL fragment... <a href="https://en.wikipedia.org/wiki/Fragment_identifier">Wikipedia on Fragment Identifiers.</a></p>
			</div>
			<!--- Container to display any errors. They will be filled in by the JavaScript fetchToken() --->
			<div id="errorContainer" class="alert alert-danger" role="alert" style="display: none;">
				<span id="errorDescription"></span>
			</div>
			<!--- URL scope to show no data has been passed through to the CFML server --->
			<div>
				<cfdump var="#URL#" label="CFML server's URL SCOPE (should be empty)">
			</div>
			<p>So any interaction with the URL fragment and this web-page has to be done using JavaScript.</p>
			<!--- The URL fragment broken down --->
			<dl id="fragmentBreakDown" class="well well-sm">
				<dt>fragment</dt>
				<dd><code id="urlFragment">error</code></dd>
				<!-- The access token that we need to copy, save and use for future API requests -->
				<dt>access_token</dt>
				<dd><kbd id="accessToken">error</kbd></dd>
				<!-- The time in seconds before this token expires and becomes invalid -->
				<dt>expires_in</dt>
				<dd><kbd id="expiresIn">error</kbd> (seconds)</dd>
				<!-- The type of token, always 'bearer' -->
				<dt>token_type</dt>
				<dd><kbd id="tokenType">error</kbd></dd>
				<!-- The ID of the website this token is permitted to access. -->
				<dt>site_id</dt>
				<dd><kbd id="siteId">error</kbd></dd>
			</dl>
		</main>
		<footer>
			<hr>
			<p>Return to <a href="index.cfm">/index.cfm</a>.</p>
		</footer>
	</cfif>
	</body>
</html>