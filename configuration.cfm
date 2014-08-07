<!--- configuration.cfm --->
<cfscript>
	/*
		None of these settings are required. They are used as a convenience to automatically fill in the forms used in WPAPI.
	 */
	api_application = structNew();
	api_client_owner = structNew(); 
	/* 
		These settings are used by the OAuth2 authentication process.
	*/
	api_application.site = ""; // Wordpress.com site to interact with. Do not include the scheme (http://).
	// The following setting values can be fetched from https://developer.wordpress.com/apps/ under My Applications > [Application name] > OAuth Information. 
	api_application.client_id = ""; // The Client ID, ie 123456
	api_application.redirect_uri = ""; // The Redirect URL, ie http://localhost:8888/wpapi/oauth2-client.cfm
	/* 	
		These settings are used by the client owner authentication.
		Storing them here is a security risk and should not be used.
	 */
	api_client_owner.username = ""; // Username used to log in to your WordPress.com account
	api_client_owner.password = ''; // Password used to log in to your WordPress.com account
	api_client_owner.client_secret = ""; // Can be fetched from https://developer.wordpress.com/apps/ under My Applications > [Application name] > OAuth Information. 
</cfscript>