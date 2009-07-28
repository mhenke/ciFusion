<cfinclude template="process.cfm" />

<cfsavecontent variable="body">
Location: <cfoutput>#location#</cfoutput><br>
	<ul>
		<li><a href="1.cfm">Compile Check</a></li>
		<li><a href="2.cfm">Duplication Check</a></li>
		<li><a href="3.cfm">HTML Cleaner (broken)</a></li>
	</ul>
</cfsavecontent>

<cfinclude template="layout/main.cfm" />