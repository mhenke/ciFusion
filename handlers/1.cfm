<cfinclude template="process.cfm" />

<cfscript>
compileCheck = createObject("component","cfcs.compileCheck").init();
body = compileCheck.getCompileCheck(location);
</cfscript> 

<cfinclude template="layout/main.cfm" />