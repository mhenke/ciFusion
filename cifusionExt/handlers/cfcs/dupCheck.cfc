<cfcomponent>
	<cffunction name="init" access="remote"
		output="false"
		hint="Returns an initialized Duplicate Checker instance.">
		<cfset variables.fileoutput = "#GetTempDirectory()#\error#dateformat(Now(),"yyyymmdd")##timeformat(Now(),"HHmmss")#.xml" />
		<!--- Return This reference. --->
		<cfreturn THIS />
	</cffunction>
	
	<cffunction name="GetDupCheck" access="public">
		<cfargument name="checkRoot" required="yes" type="string" />
		<cfset variables.location = arguments.checkRoot />
		<cfreturn formatOutput(parseFile(readFile(createFile(arguments.checkRoot)))) />
	</cffunction>
	
	<cffunction name="createFile" access="private" >
		<cfargument name="checkRoot" required="yes" type="string" />
		<cfexecute name="cmd.exe" arguments="/c java -jar #GetDirectoryFromPath(ExpandPath("*.*"))#lib/checkstyle-all-5.0.jar \ -f xml -c #GetDirectoryFromPath(ExpandPath("*.*"))#config/cf_checks_dups.xml -r #arguments.checkRoot# -o #variables.fileoutput#" 
		timeout="6000" outputfile="#variables.fileoutput#" />
		<!---<cfoutput>java -jar #GetDirectoryFromPath(ExpandPath("*.*"))#lib\checkstyle-all-5.0.jar \ -f xml -c #GetDirectoryFromPath(ExpandPath("*.*"))#config\cf_checks_dups.xml -r #arguments.checkRoot# -o #variables.fileoutput#</cfoutput>--->
	</cffunction>
	
	<cffunction name="readFile" access="private" >
		<!--- read duplicate log --->
		<cffile action="read" variable="tempFile" file="#variables.fileoutput#" />
		<!--- delete duplicate log --->
		<cffile action="delete" file="#variables.fileoutput#" />
		<cfreturn tempFile />
	</cffunction>
	
	<cffunction name="parseFile" access="private" >
		<cfargument name="tempFile" type="Any" />
		
		<cfset var myxmldoc = XmlParse(arguments.tempFile) />
		<!--- get all files nodes --->
		<cfset var selectedElements = XmlSearch(myxmldoc,"/checkstyle/file") />
		<cfset var size = ArrayLen(selectedElements) />
		<cfset var i = "" />
		<cfset var xFile = "" />

		<!--- step backwards and delete any matches --->
		<cfloop index="i" to = "1" from = #size# step="-1" >
			<cfset xFile = selectedElements[i].XmlChildren />
			<cfif ArrayIsEmpty(xFile)>
				<cfset ArrayDeleteAt(selectedElements, i) />
			</cfif>
		</cfloop>
		
		<!--- array of xml elements --->
		<cfreturn selectedElements />
	</cffunction>
	
		<cffunction name="formatOutput" access="private">
	<cfargument name="temp" required="true" type="array" />
		<cfset var htmlBody = "" />
		<cfset var i = "" />
		<cfset var ii = "" />
		<cfset var duplines = "" />
		<cfset var file2 = "" />
		<cfset var file2line = "" />
		<cfset var file1path = "" />
		<cfset var file2path = "" />
		<cfset var fileExt = "cfm,cfml,cfc" />
		
	<cfsavecontent variable="htmlBody">
	<div><i><b>Checking</b> <cfoutput>#variables.location#</cfoutput></i></div>
<thead>
	<tr>
		<th>Lines</th>
		<th>File 1</th>
		<th>On</th>
		<th>File 2</th>
		<th>On</th>
	</tr>
</thead>
<tbody>
<cfoutput>
	<cfloop array="#temp#" index="i">
		<cfloop array="#i.XmlChildren#" index="ii">
				<!--- REFind(reg_expression, string [, start, returnsubexpressions ] ) --->
		<cfset duplines = refind("[0-9]+(?=[\slines\sin])",ii.XmlAttributes.message,0,"true") />
		<cfset file2 = refind("([A-Z]:\\[^/:\*\?<>\|]+\.(cfc|cfm|cfml))(?=,\sstarting)",ii.XmlAttributes.message,0,"true") />
		<cfset file2line = refind('(from\sline\s)[0-9]+',ii.XmlAttributes.message,0,"true") />
		
		<cfif duplines.pos[1] GT 0>
			<cfset file1path = replace(i.XmlAttributes.name,variables.location,"all") />
		</cfif>
		
		<cfif file2.pos[1] GT 0>
			<cfset file2path =  replace(Mid(ii.XmlAttributes.message, file2.pos[1], file2.len[1]),variables.location,"all")/>
		</cfif>
		
		<!--- show only coldfusion files and not svn --->
		<cfif (ListContains(fileExt,listLast(file1path,".")) and
		ListContains(fileExt,listLast(file2path,"."))) and not (file1path contains ".svn" or file2path contains ".svn") >
		<tr> 
			<td>
			<cfif duplines.pos[1] GT 0>
				#Mid(ii.XmlAttributes.message, duplines.pos[1], duplines.len[1])#
			</cfif>
			</td>
			<td>#file1path#</td>
			<td>#ii.XmlAttributes.line#</td>
			<td>#file2path#</td>
			<td>
				#replace(Mid(ii.XmlAttributes.message, file2line.pos[1], file2line.len[1]),"from line","","all")#
			</td>
		</tr>
		</cfif>
		</cfloop>
	</cfloop>
</cfoutput>
</tbody>
<tfoot>
	<th>Lines</th>
	<th>File 1</th>
	<th>On</th>
	<th>File 2</th>
	<th>On</th>
</tfoot>
		</cfsavecontent>
	<cfreturn htmlBody />
	</cffunction>
</cfcomponent>