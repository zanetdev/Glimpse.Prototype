@echo off

del /Q /S dist
del /Q /S src\Glimpse.Common\bin\Release
del /Q /S src\Glimpse.Server\bin\Release
del /Q /S src\Glimpse.Agent.AspNet\bin\Release
del /Q /S src\Glimpse.Agent.AspNet.Mvc\bin\Release

md dist

call dotnet restore .\src\Glimpse.Common\project.json
call dotnet restore .\src\Glimpse.Server\project.json
call dotnet restore .\src\Glimpse.Agent.AspNet\project.json
call dotnet restore .\src\Glimpse.Agent.AspNet.Mvc\project.json

REM get time
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set DATE=%%c%%a%%b)
For /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set TIME=%%a%%b)

REM Trim White Space to ensure that single digit times are handled. (eg when time is 0:15)
for /f "tokens=* delims= " %%a in ("%TIME%") do set TIME=%%a


set MILESTONE=beta2-%DATE%%TIME%

call dotnet pack .\src\Glimpse.Common\project.json --configuration Release --version-suffix %MILESTONE%
call dotnet pack .\src\Glimpse.Server\project.json --configuration Release --version-suffix %MILESTONE%
call dotnet pack .\src\Glimpse.Agent.AspNet\project.json --configuration Release --version-suffix %MILESTONE%
call dotnet pack .\src\Glimpse.Agent.AspNet.Mvc\project.json --configuration Release --version-suffix %MILESTONE%

call nuget pack src\Glimpse\Glimpse.nuspec -OutputDirectory dist -version 2.0.0-%MILESTONE%

copy /Y src\Glimpse.Common\bin\Release\*.nupkg dist
copy /Y src\Glimpse.Server\bin\Release\*.nupkg dist
copy /Y src\Glimpse.Agent.AspNet\bin\Release\*.nupkg dist
copy /Y src\Glimpse.Agent.AspNet.Mvc\bin\Release\*.nupkg dist

REM I want to examine the output
pause