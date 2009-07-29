<cfif isDefined("ideeventinfo")>
	<cfset data = xmlParse(ideeventinfo) />
	<cfset resource = data.event.ide.projectview.resource />
	<cfset location = resource.xmlAttributes.path />
	<!--- folder or file --->
	<cfset type = resource.xmlAttributes.type>
</cfif>

<cfif NOT isDefined("cookie.location")>
<!--- TODO: Allow user to browse to file or directory to check --->
<cfcookie name="location">

<cfparam name="cookie.location" default="C:\JRun4\servers\funstuff\cfusion.ear\cfusion.war\cfspec" />

<cfset cookie.location = CreateObject("java","java.io.File").init(location).getCanonicalPath() />
</cfif>

<cfset objRequest = GetPageContext().GetRequest() />
 <cfset strUrl = objRequest.GetRequestUrl().Append(
 "?" & objRequest.GetQueryString()
 ).ToString()
 />