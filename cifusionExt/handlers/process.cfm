<cfif isDefined("ideeventinfo")>
	<cfset data = xmlParse(ideeventinfo) />
	<cfset resource = data.event.ide.projectview.resource />
	<cfset location = resource.xmlAttributes.path />
	<!--- folder or file --->
	<cfset type = resource.xmlAttributes.type>
</cfif>

<!--- TODO: Allow user to browse to file or directory to check --->
<cfparam name="location" default="C:\JRun4\servers\funstuff\cfusion.ear\cfusion.war\cfspec" />

<cfset location = CreateObject("java","java.io.File").init(location).getCanonicalPath() />

<cfset objRequest = GetPageContext().GetRequest() />
 <cfset strUrl = objRequest.GetRequestUrl().Append(
 "?" & objRequest.GetQueryString()
 ).ToString()
 />