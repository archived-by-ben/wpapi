<!--- index.cfm --->

<!--- Collect the settings --->
<cfinclude template="configuration.cfm">

<!--- Guess a redirect URL --->
<cfset redirectUrlGuess = "://#CGI.server_name#:#CGI.server_port##GetDirectoryFromPath(CGI.script_name)#oauth2-client.cfm">
<cfif CGI.server_port_secure GT 0>
	<cfset redirectUrlGuess = "https" & redirectUrlGuess>
<cfelse>
	<cfset redirectUrlGuess = "http" & redirectUrlGuess>
</cfif>

<cfset temporaryAuthenticationToken = "">

<!DOCTYPE html>
<html lang="en">
	<head>
		<link rel="stylesheet" href="css/bootstrap/css/bootstrap.min.css">
		<link rel="stylesheet" href="css/wpapi.css">
		<title>WPAPI Part 1 - index</title>
	</head>
	<body>
		<cfoutput>
		<header>
			<h3>WPAPI for the WordPress.com API</h3>
			<hr>
		</header>
		<main class="container-fluid">
			<div class="alert alert-warning" role="alert"><strong>This is not intended for use on production servers!</strong></div>
			<div class="text-justify">
				<h3><small>Part 1.</small></h3>
				<ol>
					<li>
						To interact with the WordPress.com API you first need an authentication token.
						<ul>
							<li>This token is a unique string that acts as a password and gives you access to the API.</li>
							<li>Generally these tokens have a time limit of 2 weeks before WordPress.com API deletes them.</li>
							<li>After which you have to request a new token.</li>
						</ul>
					</li>
					<li>But before you can do any of this you must first create an <a href="https://developer.wordpress.com/apps/new/">application account on developer.wordpress.com</a>.</li>
					<li>The application account form requests a number of fields be filled in.
						<dl class="well well-sm">
							<dt>Name, Description, Website URL</dt>
							<dd>Are displayed at the WordPress.com Authorize page so should display something descriptive and meaningful.</dd>
							<dt>Redirect URL</dt>
							<dd><u>This is a most import setting!</u> This must match the address used in your web browser otherwise you will not receive an authentication token. As you're viewing this page from <code>#CGI.request_url#</code> the Redirect URL should be set to <code>#redirectUrlGuess#</code></dd>
							<dt>Javascript Origins</dt>
							<dd>Is a white-list of IP addresses that are allowed to access the API using your application and can be left blank.</dd>
							<dt>Type</dt>
							<dd>Should be set to <kbd>Native</kbd> while you are testing the API.</dd>
						</dl>
					</li>
					<li>Once saved you should be able to see and manage your created application under <em>My Applications</em>.</li>
					<li>Viewing your application should reveal an <em>OAuth Information</em> section containing some important details.	Please take note of the <strong>Client ID</strong>.</li>
					<li>Optionally you can edit <kbd>configuration.cfm</kbd> and fill out the following settings. Their values will automatically fill out the forms used by this application.
						<dl class="well well-sm">
							<dt>api_application.site</dt>
							<dd>Wordpress.com site to interact with. Do not include the http:// scheme.</dd>
							<dt>api_application.client_id</dt>
							<dd>The Client ID, for example <kbd>123456</kbd>.</dd>
							<dt>api_application.redirect_uri</dt>
							<dd>The Redirect URL, for example <code>#redirectUrlGuess#</code></dd>
						</dl>
					</li>
					<li><a href="https://developer.wordpress.com/docs/oauth2/">Read more on the WordPress OAuth2 Authentication</a>.</li>
				</ol>			
			</div>
			<hr>
			<a name="part2"></a>
			<h3><small>Part 2.</small></h3>
			<div class="row">
				<div class="col-md-5">
					<h3 class="recommend">Get an authentication token <small>Option A.</small></h3>
					<p>This is the preferred and recommended method of authenticating with WordPress.com's API. It requests a standard user authentication token.</p>
					<!--- POST to oauth2-authorize.cfm --->
					<form action="oauth2-authorize.cfm" method="post">
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
							<label for="response_type">Token expires <small><kbd>response_type</kbd></small></label>
							<label class="radio-inline">
								<input type="radio" name="response_type" id="responseType1" value="token" checked> After 14 days <small><kbd>token</kbd></small>
							</label>
							<label class="radio-inline">
								<input type="radio" name="response_type" id="responseType2" value="code"> Never <small><kbd>code</kbd></small>
							</label>
							<p class="help-block">response_type=token is an OAuth2 Implicit Grant, response_type=code is an OAuth2 Authorization Code Grant</p>
						</div>
						<button type="submit" class="btn btn-default" name="submit">Request token</button>
						<button type="reset" class="btn btn-default">Reset</button>
					</form>
				</div>
				<div class="col-md-1"></div>
				<div class="col-md-5">
					<h3 class="notrecommend">Get a client owner authentication token <small>Option B.</small></h3>
					<p>This is an alternative method of authenticating intended for troubleshooting and testing. Otherwise known as a Resource Owner Credential Grant it requests a client owner authentication token through the owner's login details.</p>
					<!--- POST to oauth2-grant.cfm --->
					<form action="oauth2-grant.cfm" method="post">
						<div class="form-group">
							<label for="grant_type">Grant Type <small><kbd>grant_type</kbd></small></label>
							<input type="text" class="form-control" name="grant_type" value="password" readonly>
						</div>
						<div class="form-group">
							<label for="client_id">Client ID <small><kbd>client_id</kbd></small></label>
							<input type="text" class="form-control" name="client_id" value="#api_application.client_id#">
						</div>
						<div class="form-group">
							<label for="client_secret">Client Secret <small><kbd>client_secret</kbd></small></label>
							<input type="text" class="form-control" name="client_secret" value="#api_client_owner.client_secret#">
						</div>
						<div class="form-group">
							<label for="username">WordPress.com log-in, username or email <small><kbd>username</kbd></small></label>
							<input type="text" class="form-control" name="username" value="#api_client_owner.userName#">
						</div>
						<div class="form-group">
							<label for="password">WordPress.com log-in, password <small><kbd>password</kbd></small></label>
							<input type="password" class="form-control" name="password" value='#api_client_owner.password#'>
						</div>
						<button type="submit" class="btn btn-default" name="submit">Request token</button>
						<button type="reset" class="btn btn-default">Reset</button>
					</form>
				</div>
				<div class="col-md-1"></div>
			</div>
			<hr>
			<a name="part3"></a>
			<h3><small>Part 3.</small></h3>
			<h3 class="recommend">Fetch data from the WordPress.com API <small>Make an API call</small></h3>
			<!--- POST to api-call.cfm --->
			<div class="row">
				<div class="col-md-4">
				<form action="api-call.cfm" method="post">
					<div class="form-group">
						<label for="authorization">Authentication Token <small><kbd>authorization</kbd></small></label>
						<input type="text" class="form-control" name="authorization" value='#temporaryAuthenticationToken#'>
					</div>
					<div class="form-group">
						<label for="blog">Site <small><kbd>blog</kbd></small></label>
						<input type="text" class="form-control" name="blog" value="#api_application.site#" placeholder="WordPress.com blog URL">
						<p class="help-block">Do not include the http:// scheme.</p>
					</div>
					<div class="form-group">
						<label for="resourceurl">API Call</label>
						<select name="resourceurl" class="form-control">
							<option value="https://public-api.wordpress.com/rest/v1/me?pretty=1">About yourself</option>
							<option value="https://public-api.wordpress.com/rest/v1/insights?pretty=1">API token insights</option>
							<option value="https://public-api.wordpress.com/rest/v1/sites/%site-placeholder%?pretty=1">About site</option>
							<option value="https://public-api.wordpress.com/rest/v1/sites/%site-placeholder%/posts?pretty=1&number=3">3 most recent posts</option>
							<option value="https://public-api.wordpress.com/rest/v1/sites/%site-placeholder%/stats?pretty=1">Statistics for site</option>
							<option value="https://public-api.wordpress.com/rest/v1/sites/%site-placeholder%/stats/visits?pretty=1">Visitor statistics</option>
							<option value="https://public-api.wordpress.com/rest/v1/sites/%site-placeholder%/stats/referrers?pretty=1&days=120">Referral statistics</option>
						</select>
					</div>
					<button type="submit" class="btn btn-default">Go get the data!</button>
					<button type="reset" class="btn btn-default">Reset</button>
				</form>
				</div>
			</div>
		</cfoutput>
		</main>
		<footer>
			<hr>
			The <a href="https://developer.wordpress.com/docs/api/">REST API Resources on developer.wordpress.com</a> lists all the available API interactions.
		</footer>
	</body>
</html>