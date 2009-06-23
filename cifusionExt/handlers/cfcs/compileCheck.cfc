<cfcomponent>
		<cffunction name="init" access="remote"
		output="false"
		hint="Returns an initialized Compile Checker instance.">
			<cfset variables.fileoutput = "#GetTempDirectory()#\error#dateformat(Now(),"yyyymmdd")##timeformat(Now(),"HHmmss")#.log" />
		<!--- Return This reference. --->
		<cfreturn THIS />
	</cffunction>
	
	<cffunction name="GetCompileCheck" access="public" output="true">
		<cfargument name="checkRoot" required="yes" type="string" />
		<cfset variables.location = arguments.checkRoot />
		<cfreturn formatOutput(parseFile(readFile(createFile(arguments.checkRoot)))) />
	</cffunction>
	
	<cffunction name="createFile" access="private">
	<!--- The cfcompile utility is located in the cf_root/bin (server configuration) or 
	cf_webapp_root/WEB-INF/cfusion/bin (multiserver and J2EE configuration) directory. --->
		<cfargument name="checkRoot" required="true" type="string" />
		<cfset var webRoot = ExpandPath("\") />
		<cfset var fileExt = "sh" />
		<cfset var cfcompilePath = "#GetDirectoryFromPath(ExpandPath('*'))#bin\cfcompile." />
		<cfif SERVER.OS.name CONTAINS "windows">
			<cfset fileExt = "bat" />
		</cfif>
		<cfset cfcompilePath = cfcompilePath & fileExt />
		<cfexecute name="#cfcompilePath#" arguments="#webRoot# #arguments.checkRoot# 2> #variables.fileoutput#" timeout="240" />
	</cffunction>
	
	<cffunction name="readFile" access="private">
		<!--- read duplicate log --->
		<cffile action="read" variable="tempFile" file="#variables.fileoutput#" />
		<!--- delete duplicate log 
		<cffile action="delete" file="#variables.fileoutput#" />
		--->
		<cfreturn tempFile />
	</cffunction>
	
	<cffunction name="parseFile" access="private">
		<cfargument name="tempFile" required="true" type="Any" />
		<cfscript>
			var findError = "Error (\d)+:\s";
			var findErrorFile = "([A-Z]:\\[^/:\*\?<>\|]+\.(cfc|cfm|cfml))\s";
		    var myArray = arrayNew(2);
		    var CountVar = 0;
		    var sp = 0;
		    var message = "";
		</cfscript>
		<cfif find("Errors found:",arguments.tempFile) GT 0>
		
		<!--- find error starting point --->
		<cfset errorlog = mid(arguments.tempFile,find("Errors found:",arguments.tempFile),len(arguments.tempFile)) />
		
		<!--- find file path position --->
		<cfset next = reFind(findErrorFile,errorlog,1,true) />
		
		<!--- loop until no more next file path position --->
		<cfloop condition = "next.pos[1] GT 0">
			<cfscript>
			CountVar = 1+CountVar;
			
			//find end of file
			end = next.pos[1]+next.len[1];
	
			//find file path
			filePath = mid(errorlog,next.pos[1],next.len[1]);
			myArray[CountVar][1] = filePath;
			
	        //find next file name
	        next = reFind(findErrorFile,errorlog,end,true);
	        
	     	</cfscript>
	        <cfif next.pos[1]-end GT 0>
	        	<cfset length = next.pos[1]-end />
	        <cfelse>
	        	<cfset length = len(errorlog) />
	        </cfif>
	        <!--- find and clean message --->
	        <cfset message = rereplace(mid(errorlog,end,length),"Error\s(\d*):\s","") />
	        <cfset myArray[CountVar][2] = message />
		</cfloop>
		</cfif>
		<cfreturn myArray>
	</cffunction>
	
	<cffunction name="formatOutput" access="private">
	<cfargument name="temp" required="true" type="array" />
	<cfset var htmlBody = "" />
	<cfsavecontent variable="htmlBody">
		<div><i><b>Checking</b> <cfoutput>#variables.location#</cfoutput></i></div>
		<thead>
		<tr>
			<th>File Location</th>
			<th>Error Message</th>
		</tr>
	</thead>
	<tbody>
	<cfoutput>
		<cfloop array="#temp#" index="i">
			<tr>
				<td><a href="file:///#i[1]#">#replace(i[1],variables.location,"all")#</a></td>
				<td>#i[2]#</td>
			</tr>
		</cfloop>
	</cfoutput>
	</tbody>
	<tfoot>
		<tr>
			<th>File Location</th>
			<th>Error Message</th>
		</tr>
	</tfoot>
	</cfsavecontent>
	<cfreturn htmlBody />
	</cffunction>
</cfcomponent>