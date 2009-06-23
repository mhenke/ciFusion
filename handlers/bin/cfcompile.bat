@echo off
setlocal

@rem this should point to the directory with ColdFusions lib directory.
@rem if this is blank, this is probably a J2EE deployment and this should point
@rem to the /WEB-INF/cfusion directory
set CFUSION_HOME=C:\JRun4\servers\cfusion\cfusion-ear\cfusion-war\WEB-INF\cfusion

@rem This needs to point at the jar file with the J2EE class files in it.
@rem It defaults to a value that is valid for the server install, but for
@rem a J2EE install you will need to modify it to point to the appropriate jar file.
set J2EEJAR=C:\JRun4\lib\jrun.jar

@rem This needs to point to the WEB-INF directory for ColdFusion.
set WEBINF=C:\JRun4\servers\cfusion\cfusion-ear\cfusion-war\WEB-INF


set "PATH=%PATH%;%CFUSION_HOME%\runtime\jre\bin;%CFUSION_HOME%\runtime\bin"
if "%CFUSION_HOME%"=="" goto err_cfusion_home
if "%WEBINF%"=="" goto err_webinf

CALL %CFUSION_HOME%\bin\findjava.bat

set arg1=%1
if "%arg1%"=="-deploy" goto sourceless_deploy

set webroot=%~f1
set compdir=%~f2
if "%webroot%"=="" goto err_webroot
if "%compdir%"=="" goto setcompdir

goto aftercompdir

:setcompdir
set compdir=%~f1


:aftercompdir
%JAVACMD% -cp "%J2EEJAR%;%WEBINF%\lib\cfmx_bootstrap.jar;%WEBINF%\lib\cfx.jar" -Dcoldfusion.classPath=%CFUSION_HOME%/lib/updates,%CFUSION_HOME%/lib -Dcoldfusion.libPath=%CFUSION_HOME%/lib coldfusion.tools.CommandLineInvoker Compiler -cfroot %CFUSION_HOME% -webinf %WEBINF% -webroot %webroot% %compdir%

goto end

:err_cfusion_home
echo.
echo CFUSION_HOME not set.  Please set CFUSION_HOME to your CFMX root directory
goto end

:err_webinf
echo.
echo WEBINF not set.  Please set WEBINF to your WEB-INF directory for ColdFusion.
goto end

:err_webroot
echo.
echo Webroot is not set. Please specify the location of the webroot directory
goto useage

:useage
echo.
echo To compile files into .class files
echo.
echo     "cfcompile.bat  <webroot directory>  <directory to compile>"
echo.
echo To compile files into a binary format without the need for source
echo.
echo     "cfcompile.bat -deploy <webroot directory> <directory to compile> <output directory>"
echo.
echo webroot directory - Specify the directory location of the webroot
echo.
echo directory to compile 
echo      Specify the fully qualified name of the directory where 
echo      the files are located to be compiled. This directory must be
echo      under the webroot directory.  If not specified, all ColdFusion
echo      templates in the webroot directory will be compiled.  This is 
echo      required for the -deploy option.
echo.
echo output directory
echo      Specify the directory to write the compiled deployable files to.
echo      this can not be the same directory as the source directory.
goto end
endlocal

:sourceless_deploy
set webroot=%~f2
set srcdir=%~f3
set deploydir=%~f4
if "%webroot%"=="" goto err_deploy_webroot
if "%srcdir%"=="" goto err_deploy_srcdir
if "%deploydir%"=="" goto err_deploy_dir

goto afterdeploycompdir

:afterdeploycompdir
%JAVACMD% -cp "%J2EEJAR%;%WEBINF%\lib\cfmx_bootstrap.jar;%WEBINF%\lib\cfx.jar" -Dcoldfusion.classPath=%CFUSION_HOME%/lib/updates,%CFUSION_HOME%/lib -Dcoldfusion.libPath=%CFUSION_HOME%/lib coldfusion.tools.CommandLineInvoker Compiler -webinf %WEBINF% -webroot %webroot% -cfroot %CFUSION_HOME% -d -srcdir %srcdir% -deploydir %deploydir%


goto end

:err_deploy_srcdir
echo.
echo Source directory not set.  Please specify the directory you wish to compile
goto useage

:err_deploy_dir
echo.
echo Output directory not set.  Please specify the output directory
goto useage

:err_deploy_webroot
echo.
echo Webroot is not set. Please specify the location of the webroot directory
goto useage

endlocal

:end







