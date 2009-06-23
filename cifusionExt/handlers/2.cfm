<cfinclude template="process.cfm" />

<cfscript>
compileCheck = createObject("component","cfcs.dupCheck").init();
body = compileCheck.GetDupCheck(location);
</cfscript>

<cfinclude template="layout/main.cfm" />