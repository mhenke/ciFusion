<cfif isDefined("url.set")>
	<cfcookie name="location">
	<cfset cookie.location = URLDecode(url.location)>
	<cfset cookie.location = CreateObject("java","java.io.File").init(cookie.location).getCanonicalPath() />
	<cflocation url="index.cfm">
</cfif>

<cfinclude template="process.cfm">

<cfinclude template="udf/upDirLevel.cfm">

<cfset variables.location = URLDecode(url.location)>
<cfset variables.location = CreateObject("java","java.io.File").init(variables.location).getCanonicalPath() />

<cfdirectory directory="#variables.location#" action="list" name="dirList">

<cfsavecontent variable="body">
<h1>Choose Location</h1>
<cfoutput>
	<a href="browse.cfm?location=#URLEncodedFormat(upDirLevel(variables.location, 1))#">Up</a><br>
	Location: #variables.location# &nbsp; <a href="browse.cfm?set=1&location=#URLEncodedFormat(variables.location)#">Choose This Location</a><br>
</cfoutput>
<table>
	<tr><th>Item</th></tr>
	<cfoutput query="dirList">
	<tr>
	<td><cfif type EQ "dir">
		<a href="browse.cfm?location=#URLEncodedFormat(directory & '/' & name)#">#name#</a>
	<cfelse>
		#name#
	</cfif></td>
	</tr>
	</cfoutput>
</table>
</cfsavecontent>

<cfinclude template="layout/main.cfm" />