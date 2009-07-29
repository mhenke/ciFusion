<cfinclude template="process.cfm" />

<cfinclude template="udf/upDirLevel.cfm">

<cfsavecontent variable="body">
<h1>ciFusion</h1>
Location: <cfoutput>#location#&nbsp; <a href="browse.cfm?location=#URLEncodedFormat(location)#">Change Location</a></cfoutput><br>
	<ul>
		<li><a href="1.cfm">Compile Check</a></li>
		<li><a href="2.cfm">Duplication Check</a></li>
		<li><a href="3.cfm">HTML Cleaner (broken)</a></li>
	</ul>
</cfsavecontent>

<cfinclude template="layout/main.cfm" />