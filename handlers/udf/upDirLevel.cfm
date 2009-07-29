<cfscript>
/**
* Climbs up a given UNC Path a specified number of levels.
*
* @param currDir      The directory to use as a starting point from which to climb. (Required)
* @param upCt      Integer specifying the number of directory levels to move up. (Required)
* @return Returns a string.
* @author Joshua Miller (josh@joshuasmiller.com)
* @version 1, September 20, 2004
*/
function upDirLevel(currDir,upCt){
    var i=1;
    var currDirTemp=Reverse(currDir);
    var s=0;
    for(i=1;i LTE upCt;i=i+1){
        s=findoneof("\/",currDirTemp,1);
        if(s EQ 1){
            currDirTemp=Right(currDirTemp,val(Len(currDirTemp)-s));
            s=find("\",currDirTemp,1);
            currDirTemp=Right(currDirTemp,val(Len(currDirTemp)-s));
        }else{
            currDirTemp=Right(currDirTemp,val(Len(currDirTemp)-s));
        }
    }
    currDirTemp="#reverse(replacenocase(currDirTemp,'/','\','ALL'))#\";
    return currDirTemp;
}
</cfscript>