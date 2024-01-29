@echo off
Set Version=2.2

set w=[97m
set p=[95m
set b=[96m


::Enable Restore points 

powershell -ExecutionPolicy Unrestricted -NoProfile Enable-ComputerRestore -Drive 'C:\'>nul 2>&1
Reg.exe delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "RPSessionInterval" /f  >nul 2>&1
Reg.exe delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "DisableConfig" /f >nul 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "SystemRestorePointCreationFrequency" /t REG_DWORD /d 0 /f  >nul 2>&1
%b%

:: Enable ANSI Escape Sequences
Reg.exe add "HKCU\CONSOLE" /v "VirtualTerminalLevel" /t REG_DWORD /d "1" /f  > nul

::Enable Delayed Expansion
setlocal EnableDelayedExpansion > nul
cls 

::Run as admin (this is so the tweaks apply properly)
chcp 65001 >nul 2>&1
cls 
echo.
echo. ╔════════════════════════════════════════════════════╗
echo. ║                                                    ║
echo  ║   %w% Checking for Administrative Privelages...     %b%  ║
echo. ║                                                    ║
echo. ╚════════════════════════════════════════════════════╝
timeout /t 1 /nobreak > NUL

rmdir %SystemDrive%\Windows\system32\adminrightstest >nul 2>&1
mkdir %SystemDrive%\Windows\system32\adminrightstest >nul 2>&1
if %errorlevel% neq 0 (   
cls 
echo.
echo. ╔════════════════════════════════════════════════════╗
echo. ║                                                    ║
echo  ║  %w% Running Exm Tweaking Utility as Administrator...%b% ║
echo. ║                                                    ║
echo. ╚════════════════════════════════════════════════════╝
timeout /t 1 /nobreak > NUL
chcp 437 >nul 2>&1
powershell -NoProfile -NonInteractive -Command start -verb runas "'%~s0'" >nul 2>&1
chcp 65001 >nul 2>&1

if !errorlevel! equ 0 exit /b


echo.
echo             Exm is not running as Admin!
echo     Some optimizations won't work. Continue anyway?
echo.
choice /c:"CQ" /n /m "%BS%               [C] Continue  [Q] Quit" & if !errorlevel! equ 2 exit /b
)


chcp 65001 >nul 2>&1


:restorepoint
cls
echo.
echo.
echo.                                 %p%██████╗░███████╗░██████╗████████╗░█████╗░██████╗░███████╗  ██████╗░░█████╗░██╗███╗░░██╗████████╗
echo.                                 %p%██╔══██╗██╔════╝██╔════╝╚══██╔══╝██╔══██╗██╔══██╗██╔════╝  ██╔══██╗██╔══██╗██║████╗░██║╚══██╔══╝
echo.                                 %p%██████╔╝█████╗░░╚█████╗░░░░██║░░░██║░░██║██████╔╝█████╗░░  ██████╔╝██║░░██║██║██╔██╗██║░░░██║░░░
echo.                                 %p%██╔══██╗██╔══╝░░░╚═══██╗░░░██║░░░██║░░██║██╔══██╗██╔══╝░░  ██╔═══╝░██║░░██║██║██║╚████║░░░██║░░░
echo.                                 %p%██║░░██║███████╗██████╔╝░░░██║░░░╚█████╔╝██║░░██║███████╗  ██║░░░░░╚█████╔╝██║██║░╚███║░░░██║░░░
echo.                                 %p%╚═╝░░╚═╝╚══════╝╚═════╝░░░░╚═╝░░░░╚════╝░╚═╝░░╚═╝╚══════╝  ╚═╝░░░░░░╚════╝░╚═╝╚═╝░░╚══╝░░░╚═╝░░░
echo.                       %b%╔════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗%w%
echo.                       %b%║                              %w% Do you want to Create a Restore Point?                                           %b%║
echo.                       %b%║                                                                                                                %b%║
echo.                       %b%║                                                                                                                %b%║
echo.                       %b%║             %p%[1]%w% Make A restore Point      %p%[2]%w% Skip (only do this if you already have a restore point)          %b%║
echo.                       %b%║                                                                                                                %b%║
echo.                       %b%║                                                                                                                %b%║                                                                                   
echo.                       %b%╚════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝

set /p input=:
if /i %input% == 1 goto rON
if /i %input% == 2 goto rOFF

) ELSE (
echo Invalid Input & goto MisspellRedirect

:MisspellRedirect
cls
echo Misspell Detected
timeout 2
goto RedirectMenu

:RedirectMenu
goto restorepoint

:rON
chcp 437 >nul 
powershell -ExecutionPolicy Bypass -Command "Checkpoint-Computer -Description 'Exm Free Utility Restore Point' -RestorePointType 'MODIFY_SETTINGS'" 
chcp 65001 >nul 
echo.
echo.
echo.
cls
goto :warning

:rOFF
goto warning

:warning
cls
echo.
echo.
echo.
echo.                                      %p%░██╗░░░░░░░██╗░░█████╗░░██████╗░░███╗░░██░╗██╗░███╗░░██╗░░██████╗░
echo.                                      %p%░██║░░██╗░░██║░██╔══██╗░██╔══██╗░████╗░██║░██║░████╗░██║░██╔════╝░
echo.                                      %p%░╚██╗████╗██╔╝░███████║░██████╔╝░██╔██╗██║░██║░██╔██╗██║░██║░░██╗░
echo.                                      %p%░░████╔═████║░░██╔══██║░██╔══██╗░██║╚████║░██║░██║╚████║░██║░░╚██╗
echo.                                      %p%░░╚██╔╝░╚██╔╝░░██║░░██║░██║░░██║░██║░╚███║░██║░██║░╚███║░╚██████╔╝
echo.                                      %p%░░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝░╚═╝░░╚═╝░╚═╝░░╚══╝░╚═╝░╚═╝░░╚══╝░░╚═════╝░                                         %p%
echo.                 %b%"══════════════════════════════════════════════════════════════════════════════════════════════════"%w%
echo.
echo.                    I am not responsible for any problems/Damages with your pc this may cause (this doesnt happen very often)
echo.
echo.                                               Its prohibited to ressell/skid any of my tools.
echo.
echo.                 %b%"══════════════════════════════════════════════════════════════════════════════════════════════════"%w%
echo.
echo.                                               Type numbers/letters to select your options
echo.                           Please Read All warnings, popups etc... dont just blindly press buttons without reading
echo.
echo.                 %b%"═══════════════════════════════════════════════════════════════════════════════════════════════════"
echo. 
echo.
echo.
echo.
echo.                                        %b%"I═══════════════════════════════════════════════════════I"
echo.                                                     %w%    Press any key to continue...
echo.                                        %b%"I═══════════════════════════════════════════════════════I"
pause > nul
cls

:res 
md C:\exmfree
cls
echo. %b% 
echo. ╔═════════════════════════════╗
echo. ║                             ║
echo  ║   %w% Downloading resources %b%   ║
echo. ║                             ║
echo. ╚═════════════════════════════╝
echo.

curl -g -k -L -# -o "%temp%\nvidiaProfileInspector.zip" "https://github.com/Orbmu2k/nvidiaProfileInspector/releases/latest/download/nvidiaProfileInspector.zip" >nul 2>&1
cls
chcp 437 >nul 2>&1
powershell -NoProfile Expand-Archive '%temp%\nvidiaProfileInspector.zip' -DestinationPath 'C:\Exmfree\' >nul 2>&1 
chcp 65001 >nul 2>&1
cls
echo. %b% 
echo. ╔═════════════════════════════╗
echo. ║                             ║
echo  ║   %w% Downloading resources %b%   ║
echo. ║                             ║
echo. ╚═════════════════════════════╝
echo.
curl -g -k -L -# -o "C:\exmfree\Exm_Free_Power_Plan_V2.pow" "https://cdn.discordapp.com/attachments/1178453345048997899/1196832416061464707/Exm_Free_Power_Plan_V2.pow?ex=65b9100c&is=65a69b0c&hm=babee40afcc4cf9770038077fb7a71ec2babb3029b6500e9a35e1d80aa5431ed&"

timeout /t 1 /nobreak > NUL
cls
echo. %b% 
echo. ╔═════════════════════════════╗
echo. ║                             ║
echo  ║   %w% Downloading resources %b%   ║
echo. ║                             ║
echo. ╚═════════════════════════════╝
echo.
curl -g -k -L -# -o "C:\exmfree\Exm_Free_Settings_V4.nip" "https://cdn.discordapp.com/attachments/1178453345048997899/1196830496504696842/Free_Profile.nip?ex=65b90e42&is=65a69942&hm=de818f02759c1718b6e45ec3478dbb4d6f6e9fd526d7d86333ce88698804a124&" 
timeout /t 1 /nobreak > NUL
cls
echo. %b% 
echo. ╔═════════════════════════════╗
echo. ║                             ║
echo  ║   %w% Downloading resources %b%   ║
echo. ║                             ║
echo. ╚═════════════════════════════╝
echo.
curl -g -k -L -# -o "C:\exmfree\autoruns.exe" "https://cdn.discordapp.com/attachments/1178453345048997899/1196830552939044965/autoruns.exe?ex=65b90e4f&is=65a6994f&hm=6c60a8109f26664d031d4a1c30ee93833a07f87393613f6af7ccbce96c70c1be&"
timeout /t 1 /nobreak > NUL
cls
echo. %b% 
echo. ╔═════════════════════════════╗
echo. ║                             ║
echo  ║   %w% Downloading resources %b%   ║
echo. ║                             ║
echo. ╚═════════════════════════════╝
echo.
curl -g -k -L -# -o "C:\exmfree\Update_Blocker.exe" "https://cdn.discordapp.com/attachments/1178453345048997899/1196830552939044965/autoruns.exe?ex=65b90e4f&is=65a6994f&hm=6c60a8109f26664d031d4a1c30ee93833a07f87393613f6af7ccbce96c70c1be&"
timeout /t 1 /nobreak > NUL
cls
goto menu


:restore
cls
rstrui.exe
echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls


:Menu
chcp 65001 >nul 2>&1
cls
echo.
echo.
echo.
echo.
echo.       %b%╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗              
echo.       %b%║%p% ███████╗██╗░░██╗███╗░░░███╗░░███████╗██████╗░███████╗███████╗░██╗░░░██╗████████╗██╗██╗░░░░░██╗████████╗██╗░░░██╗ %b%║
echo.       %b%║%p% ██╔════╝╚██╗██╔╝████╗░████║░░██╔════╝██╔══██╗██╔════╝██╔════╝░██║░░░██║╚══██╔══╝██║██║░░░░░██║╚══██╔══╝╚██╗░██╔╝ %b%║
echo.       %b%║%p% █████╗░░░╚███╔╝░██╔████╔██║░░█████╗░░██████╔╝█████╗░░█████╗░░░██║░░░██║░░░██║░░░██║██║░░░░░██║░░░██║░░░░╚████╔╝░ %b%║
echo.       %b%║%p% ██╔══╝░░░██╔██╗░██║╚██╔╝██║░░██╔══╝░░██╔══██╗██╔══╝░░██╔══╝░░░██║░░░██║░░░██║░░░██║██║░░░░░██║░░░██║░░░░░╚██╔╝░░ %b%║
echo.       %b%║%p% ███████╗██╔╝╚██╗██║░╚═╝░██║░░██║░░░░░██║░░██║███████╗███████╗░╚██████╔╝░░░██║░░░██║███████╗██║░░░██║░░░░░░██║░░░ %b%║
echo.       %b%║%p% ╚══════╝╚═╝░░╚═╝╚═╝░░░░░╚═╝░░╚═╝░░░░░╚═╝░░╚═╝╚══════╝╚══════╝░░╚═════╝░░░░╚═╝░░░╚═╝╚══════╝╚═╝░░░╚═╝░░░░░░╚═╝░░░ %b%║
echo.       %b%║══════════════════════════════════════════════════════════════════════════════════════════════════════════════════%b%║
echo.       %b%║%w%                                                                                                                  %b%║
echo.       %b%║%w%                                    Updated 19th January  *  Version 2.2                                          %b%║
echo.       %b%║%w%                                                                                                                  %b%║
echo.       %b%║══════════════════════════════════════════════════════════════════════════════════════════════════════════════════%b%║
echo.       %b%║%w%                                                                                                                  %b%║
echo.       %b%║%w%                      %p%[1]%w% General Performance/Latency Tweaks       %p%[2]%w% Power Tweaks                               %b%║        
echo.       %b%║%w%                                                                                                                  %b%║
echo.       %b%║%w%                      %p%[3]%w% Windows and Debloat                      %p%[4]%w% Clean                                      %b%║             
echo.       %b%║%w%                                                                                                                  %b%║
echo.       %b%║%w%                      %p%[5]%w% Ram Tweaks                               %p%[6]%w% Autoruns App                               %b%║             
echo.       %b%║%w%                                                                                                                  %b%║
echo.       %b%║%w%                      %p%[7]%w% Gpu Tweaks                               %p%[8]%w% Cpu Tweaks                                 %b%║             
echo.       %b%║%w%                                                                                                                  %b%║
echo.       %b%║%w%                      %p%[9]%w% Usb Tweaks                               %p%[10]%w% Mouse and Keyboard                        %b%║    
echo.       %b%║%w%                                                                                                                  %b%║    
echo.       %b%║══════════════════════════════════════════════════════════════════════════════════════════════════════════════════%b%║   
echo.       %b%║%w%                                                                                                                  %b%║    
echo.       %b%║%w%                      %p%[E]%w% Reverts                                  %p%[R]%w% Use Restore Point                          %b%║                   
echo.       %b%║%w%                                                                                                                  %b%║
echo.       %b%║%w%                                                %p%[W]%w% Better Tweaks                                                 %b%║ 
echo.       %b%║%w%                                                                                                                  %b%║                        
echo.       %b%║%w%                                                                                                                  %b%║         
echo.       %b%║%w%                                            Made by EXM * Discord.gg/exm                                          %b%║
echo.       %b%║%w%                                                                                                                  %b%║
echo.       %b%╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝




set /p input=:
if /i %input% == 1 goto 1
if /i %input% == 2 goto 2war
if /i %input% == 3 goto 3
if /i %input% == 4 goto 4
if /i %input% == 5 goto 5
if /i %input% == 6 goto 6
if /i %input% == 7 goto 7
if /i %input% == 8 goto 8
if /i %input% == 9 goto 9
if /i %input% == 10 goto 10

if /i %input% == E goto :e
if /i %input% == R goto Restore
if /i %input% == W start https://exmtweaks.com 


) ELSE (
echo Invalid Input & goto MisspellRedirect

:MisspellRedirect
cls
echo Misspell Detected
timeout 2 
goto RedirectMenu

:RedirectMenu
cls
goto :menu

:3
:windows
cls
echo.
echo.
echo.                                       %p%   ░██╗░░░░░░░██╗██╗███╗░░██╗██████╗░░█████╗░░██╗░░░░░░░██╗░██████╗      
echo.                                       %p%   ░██║░░██╗░░██║██║████╗░██║██╔══██╗██╔══██╗░██║░░██╗░░██║██╔════╝      
echo.                                       %p%   ░╚██╗████╗██╔╝██║██╔██╗██║██║░░██║██║░░██║░╚██╗████╗██╔╝╚█████╗░     
echo.                                       %p%   ░░████╔═████║░██║██║╚████║██║░░██║██║░░██║░░████╔═████║░░╚═══██╗      
echo.                                       %p%   ░░╚██╔╝░╚██╔╝░██║██║░╚███║██████╔╝╚█████╔╝░░╚██╔╝░╚██╔╝░██████╔╝      
echo.                                       %p%   ░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░╚══╝╚═════╝░░╚════╝░░░░╚═╝░░░╚═╝░░╚═════╝░      
echo.                        %b%╔══════════════════════════════════════════════════════════════════════════════════════════════╗%w%
echo.                        %b%║                          %w% Optimize Windows, remove useless bloat                             %b%║        
echo.                        %b%║                                                                                              %b%║
echo.                        %b%║                                                                                              %b%║
echo.                        %b%║                %p%[1]%w% Optimize Windows          %p%[2]%w% Disable Notifications                       %b%║
echo.                        %b%║                                                                                              %b%║
echo.                        %b%║                %p%[3]%w% Disable XBOX Services     %p%[4]%w% Uninstall Useless Windows Apps              %b%║
echo.                        %b%║                                                                                              %b%║
echo.                        %b%║                %p%[5]%w% Disable GameDVR           %p%[6]%w% Disable Useless Animations                  %b%║
echo.                        %b%║                                                                                              %b%║          
echo.                        %b%║                %p%[7]%w% Disable Bluetooth         %p%[8]%w% Windows Update Blocker                      %b%║
echo.                        %b%║                                                                                              %b%║          
echo.                        %b%║                %p%[9]%w% Disable Cortana           %p%[10]%w% Disable Telemetry                          %b%║
echo.                        %b%║                                                                                              %b%║          
echo.                        %b%║                %p%[11]%w% Disable Error Reporting  %p%[12]%w% Disable Setting Synchronization            %b%║
echo.                        %b%║                                                                                              %b%║          
echo.                        %b%║                                                                                              %b%║          
echo.                        %b%║                                    %p%[M]%w% Back to menu                                          %b%║
echo.                        %b%║                                                                                              %b%║
echo.                        %b%╚══════════════════════════════════════════════════════════════════════════════════════════════╝
echo.

set /p input=:
if /i %input% == 1 goto w1
if /i %input% == 2 goto w2
if /i %input% == 3 goto w3
if /i %input% == 4 goto w4
if /i %input% == 5 goto w5
if /i %input% == 6 goto w6
if /i %input% == 7 goto w7
if /i %input% == 8 goto w8
if /i %input% == 9 goto w9
if /i %input% == 10 goto w10
if /i %input% == 11 goto w11
if /i %input% == 12 goto w12

if /i %input% == M cls & goto menu

) ELSE (
echo Invalid Input & goto MisspellRedirect

:MisspellRedirect
cls
echo Misspell Detected
timeout 2
goto RedirectMenu

:RedirectMenu
goto :3

:w12
echo %w% - Disabling Setting Synchronization%b%
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" /v "Enabled" /t REG_DWORD /d "0" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\AppSync" /v "Enabled" /t REG_DWORD /d "0" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" /v "Enabled" /t REG_DWORD /d "0" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "Enabled" /t REG_DWORD /d "0" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\DesktopTheme" /v "Enabled" /t REG_DWORD /d "0" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" /v "Enabled" /t REG_DWORD /d "0" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\PackageState" /v "Enabled" /t REG_DWORD /d "0" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" /v "Enabled" /t REG_DWORD /d "0" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\StartLayout" /v "Enabled" /t REG_DWORD /d "0" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" /v "Enabled" /t REG_DWORD /d "0" /f 
echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :windows

:w11
echo %w% - Disabling Windows Error Reporting%b%
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "DoReport" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting" /v "DoReport" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f 
echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :menu

:w7
CLS
echo %w% - Disable Bluetooth%b%
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\BTAGService" /v "Start" /t REG_DWORD /d "4" /f
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\bthserv" /v "Start" /t REG_DWORD /d "4" /f
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\BthAvctpSvc" /v "Start" /t REG_DWORD /d "4" /f
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\BluetoothUserService" /v "Start" /t REG_DWORD /d "4" /f
echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :windows

:w5
cls
echo %w% - Disable GameDVR%b%
Reg.exe add "HKCU\Software\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\Microsoft\GameBar" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AudioCaptureEnabled" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "CursorCaptureEnabled" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "HistoricalCaptureEnabled" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\GameDVR" /v "AllowgameDVR" /t REG_DWORD /d "0" /f
echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :windows

:w2
cls
echo %w% - Disable Notifications%b%
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "0" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_NOTIFICATION_SOUND" /t REG_DWORD /d "0" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK" /t REG_DWORD /d "0" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\QuietHours" /v "Enabled" /t REG_DWORD /d "0" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel" /v "Enabled" /t REG_DWORD /d "0" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.AutoPlay" /v "Enabled" /t REG_DWORD /d "0" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.LowDisk" /v "Enabled" /t REG_DWORD /d "0" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.Print.Notification" /v "Enabled" /t REG_DWORD /d "0" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance" /v "Enabled" /t REG_DWORD /d "0" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.WiFiNetworkManager" /v "Enabled" /t REG_DWORD /d "0" /f 
Reg.exe add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "1" /f
echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :windows

:w3
cls
echo %w% - Disable Xbox Services%b%
sc config xbgm start= disabled >nul 2>&1
sc config XblAuthManager start= disabled
sc config XblGameSave start= disabled
sc config XboxGipSvc start= disabled
sc config XboxNetApiSvc start= disabled
echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :windows

:w9
cls
echo %w% - Disabling Cortana%b%
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCloudSearch" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortanaAboveLock" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWebOverMeteredConnections" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d "0" /f 


chcp 437 >nul 
timeout /t 1 /nobreak > NUL
Powershell -Command "Get-appxpackage -allusers *Microsoft.549981C3F5F10* | Remove-AppxPackage" 
timeout /t 1 /nobreak > NUL
chcp 65001 >nul 
echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :windows

:w8
cls
chcp 437 > nul

powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Select disable updates in wub, press ok to open it', 'Exm Tweaking Utility', 'Ok', [System.Windows.Forms.MessageBoxIcon]::Information);}"
chcp 65001 > nul

start C:\exmfree\Update_Blocker.exe
echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :windows



:w6
cls 
%windir%\system32\SystemPropertiesPerformance.exe
echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :windows

:w1
cls
echo %w% - Disable Customer Experience Improvement Program%b%
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" > nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /disable > nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\BthSQM" > nul 2>&1 
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\BthSQM" /disable > nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" > nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /disable > nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" > nul 2>&1 
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /disable > nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\Uploader" > nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\Uploader" /disable > nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" > nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /disable > nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Application Experience\ProgramDataUpdater" > nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /disable > nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Application Experience\StartupAppTask" > nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Shell\FamilySafetyMonitor" > nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Shell\FamilySafetyMonitor" /disable > nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Shell\FamilySafetyRefresh" > nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Shell\FamilySafetyRefresh" /disable > nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Shell\FamilySafetyUpload" > nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Shell\FamilySafetyUpload" /disable > nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Maintenance\WinSAT" > nul 2>&1

echo %w% - Disabling Automatic Maintenance%b%
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "MaintenanceDisabled" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Disable Transparency%b%
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "0" /f
timeout /t 1 /nobreak > NUL

echo %w% - Disable Activity feed%b%
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v "EnableFeeds" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft" /v "AllowNewsAndInterests" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Control Panel\International\User Profile" /v "HttpAcceptLanguageOptOut" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d "0" /f
timeout /t 1 /nobreak > NUL

echo %w% - Disable Popups, baloon tips etc%b%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisallowShaking" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "EnableBalloonTips" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" /v "Value" /t REG_SZ /d "Deny" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d "1" /f
timeout /t 1 /nobreak > NUL


echo %w% - Enabling GameMode%b%
Reg.exe add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d "1" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Disabling Windows Insider Experiments%b%
Reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\System" /v "AllowExperimentation" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\System\AllowExperimentation" /v "value" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL




echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :windows

:w10
cls

echo %w% - Disabling Telemetry Through Task Scheduler%b%
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" 
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /disable 
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\BthSQM" 
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\BthSQM" /disable 
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" 
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /disable 
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" 
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /disable 
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\Uploader" 
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\Uploader" /disable 
schtasks /end /tn "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" 
schtasks /change /tn "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /disable 
schtasks /end /tn "\Microsoft\Windows\Application Experience\ProgramDataUpdater" 
schtasks /change /tn "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /disable 
schtasks /end /tn "\Microsoft\Windows\Application Experience\StartupAppTask" 
schtasks /change /tn "\Microsoft\Windows\Application Experience\StartupAppTask" /disable 
schtasks /end /tn "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" 
schtasks /change /tn "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /disable 
schtasks /end /tn "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticResolver" 
schtasks /change /tn "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticResolver" /disable 
schtasks /end /tn "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" 
schtasks /change /tn "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /disable 
schtasks /end /tn "\Microsoft\Windows\Shell\FamilySafetyMonitor" 
schtasks /change /tn "\Microsoft\Windows\Shell\FamilySafetyMonitor" /disable 
schtasks /end /tn "\Microsoft\Windows\Shell\FamilySafetyRefresh" 
schtasks /change /tn "\Microsoft\Windows\Shell\FamilySafetyRefresh" /disable 
schtasks /end /tn "\Microsoft\Windows\Shell\FamilySafetyUpload" 
schtasks /change /tn "\Microsoft\Windows\Shell\FamilySafetyUpload" /disable 
schtasks /end /tn "\Microsoft\Windows\Autochk\Proxy" 
schtasks /change /tn "\Microsoft\Windows\Autochk\Proxy" /disable 
schtasks /end /tn "\Microsoft\Windows\Maintenance\WinSAT" 
schtasks /change /tn "\Microsoft\Windows\Maintenance\WinSAT" /disable 
schtasks /end /tn "\Microsoft\Windows\Application Experience\AitAgent" 
schtasks /change /tn "\Microsoft\Windows\Application Experience\AitAgent" /disable 
schtasks /end /tn "\Microsoft\Windows\Windows Error Reporting\QueueReporting" 
schtasks /change /tn "\Microsoft\Windows\Windows Error Reporting\QueueReporting" /disable 
schtasks /end /tn "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" 
schtasks /change /tn "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" /disable 
schtasks /end /tn "\Microsoft\Windows\DiskFootprint\Diagnostics" 
schtasks /change /tn "\Microsoft\Windows\DiskFootprint\Diagnostics" /disable 
schtasks /end /tn "\Microsoft\Windows\PI\Sqm-Tasks" 
schtasks /change /tn "\Microsoft\Windows\PI\Sqm-Tasks" /disable 
schtasks /end /tn "\Microsoft\Windows\NetTrace\GatherNetworkInfo" 
schtasks /change /tn "\Microsoft\Windows\NetTrace\GatherNetworkInfo" /disable 
schtasks /end /tn "\Microsoft\Windows\AppID\SmartScreenSpecific" 
schtasks /change /tn "\Microsoft\Windows\AppID\SmartScreenSpecific" /disable 
schtasks /end /tn "\Microsoft\Office\OfficeTelemetryAgentFallBack2016" 
schtasks /change /tn "\Microsoft\Office\OfficeTelemetryAgentFallBack2016" /disable 
schtasks /end /tn "\Microsoft\Office\OfficeTelemetryAgentLogOn2016" 
schtasks /change /tn "\Microsoft\Office\OfficeTelemetryAgentLogOn2016" /disable 
schtasks /end /tn "\Microsoft\Office\OfficeTelemetryAgentLogOn" 
schtasks /change /TN "\Microsoft\Office\OfficeTelemetryAgentLogOn" /disable 
schtasks /end /tn "\Microsoftd\Office\OfficeTelemetryAgentFallBack" 
schtasks /change /TN "\Microsoftd\Office\OfficeTelemetryAgentFallBack" /disable 
schtasks /end /tn "\Microsoft\Office\Office 15 Subscription Heartbeat" 
schtasks /change /TN "\Microsoft\Office\Office 15 Subscription Heartbeat" /disable 
schtasks /end /tn "\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime" 
schtasks /change /TN "\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime" /disable 
schtasks /end /tn "\Microsoft\Windows\Time Synchronization\SynchronizeTime" 
schtasks /change /TN "\Microsoft\Windows\Time Synchronization\SynchronizeTime" /disable 
schtasks /end /tn "\Microsoft\Windows\WindowsUpdate\Automatic App Update" 
schtasks /change /TN "\Microsoft\Windows\WindowsUpdate\Automatic App Update" /disable 
schtasks /end /tn "\Microsoft\Windows\Device Information\Device" 
schtasks /change /TN "\Microsoft\Windows\Device Information\Device" /disable 
timeout /t 1 /nobreak > NUL


echo %w% - Disabling Telemetry Services%b%
sc stop DiagTrack 
sc config DiagTrack start= disabled 
sc stop dmwappushservice 
sc config dmwappushservice start= disabled 
sc stop diagnosticshub.standardcollector.service 
sc config diagnosticshub.standardcollector.service start= disabled 
timeout /t 1 /nobreak > NUL
echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :windows


:w4
cls
chcp 437 > nul
echo %w% - Removing Unnecessary Powershell Packages %b%
PowerShell -Command "Get-AppxPackage -allusers *3DBuilder* | Remove-AppxPackage" 
PowerShell -Command "Get-AppxPackage -allusers *bing* | Remove-AppxPackage" 
PowerShell -Command "Get-AppxPackage -allusers *bingfinance* | Remove-AppxPackage" 
PowerShell -Command "Get-AppxPackage -allusers *bingsports* | Remove-AppxPackage" 
PowerShell -Command "Get-AppxPackage -allusers *BingWeather* | Remove-AppxPackage" 
PowerShell -Command "Get-AppxPackage -allusers *CommsPhone* | Remove-AppxPackage" 
PowerShell -Command "Get-AppxPackage -allusers *Drawboard PDF* | Remove-AppxPackage" 
PowerShell -Command "Get-AppxPackage -allusers *Facebook* | Remove-AppxPackage" 
PowerShell -Command "Get-AppxPackage -allusers *Getstarted* | Remove-AppxPackage" 
PowerShell -Command "Get-AppxPackage -allusers *Microsoft.Messaging* | Remove-AppxPackage" 
PowerShell -Command "Get-AppxPackage -allusers *MicrosoftOfficeHub* | Remove-AppxPackage" 
PowerShell -Command "Get-AppxPackage -allusers *Office.OneNote* | Remove-AppxPackage" 
PowerShell -Command "Get-AppxPackage -allusers *OneNote* | Remove-AppxPackage" 
PowerShell -Command "Get-AppxPackage -allusers *SkypeApp* | Remove-AppxPackage" 
PowerShell -Command "Get-AppxPackage -allusers *solit* | Remove-AppxPackage" 
PowerShell -Command "Get-AppxPackage -allusers *Sway* | Remove-AppxPackage" 
PowerShell -Command "Get-AppxPackage -allusers *Twitter* | Remove-AppxPackage" 
PowerShell -Command "Get-AppxPackage -allusers *WindowsAlarms* | Remove-AppxPackage" 
PowerShell -Command "Get-AppxPackage -allusers *WindowsPhone* | Remove-AppxPackage" 
PowerShell -Command "Get-AppxPackage -allusers *WindowsMaps* | Remove-AppxPackage" 
PowerShell -Command "Get-AppxPackage -allusers *WindowsFeedbackHub* | Remove-AppxPackage" 
PowerShell -Command "Get-AppxPackage -allusers *WindowsSoundRecorder* | Remove-AppxPackage" 
PowerShell -Command "Get-AppxPackage -allusers *windowscommunicationsapps* | Remove-AppxPackage" 
PowerShell -Command "Get-AppxPackage -allusers *zune* | Remove-AppxPackage" 
timeout /t 1 /nobreak > NUL
chcp 65001 > nul
echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :windows



:e
cls
echo.
echo.
echo.                                    %p%          ██████╗░███████╗██╗░░░██╗███████╗██████╗░████████╗
echo.                                    %p%          ██╔══██╗██╔════╝██║░░░██║██╔════╝██╔══██╗╚══██╔══╝
echo.                                    %p%          ██████╔╝█████╗░░╚██╗░██╔╝█████╗░░██████╔╝░░░██║░░░
echo.                                    %p%          ██╔══██╗██╔══╝░░░╚████╔╝░██╔══╝░░██╔══██╗░░░██║░░░
echo.                                    %p%          ██║░░██║███████╗░░╚██╔╝░░███████╗██║░░██║░░░██║░░░
echo.                                    %p%          ╚═╝░░╚═╝╚══════╝░░░╚═╝░░░╚══════╝╚═╝░░╚═╝░░░╚═╝░░░
echo.                        %b%╔══════════════════════════════════════════════════════════════════════════════════════════════╗%w%
echo.                        %b%║              %w% If you want to revert some settings without using a restore point,             %b%║        
echo.                        %b%║                                                                                              %b%║
echo.                        %b%║                                                                                              %b%║
echo.                        %b%║                           %p%[1]%w% Bring back default power plans                                 %b%║
echo.                        %b%║                                                                                              %b%║
echo.                        %b%║                           %p%[2]%w% Reinstall default windows apps                                 %b%║
echo.                        %b%║                                                                                              %b%║
echo.                        %b%║                           %p%[3]%w% Enable XBOX Services                                           %b%║
echo.                        %b%║                                                                                              %b%║
echo.                        %b%║                           %p%[4]%w% Enable GameDVR                                                 %b%║
echo.                        %b%║                                                                                              %b%║
echo.                        %b%║                           %p%[5]%w% Enable Notifications                                           %b%║
echo.                        %b%║                                                                                              %b%║ 
echo.                        %b%║                           %p%[6]%w% Enable Bluetooth                                               %b%║
echo.                        %b%║                                                                                              %b%║ 
echo.                        %b%║                                                                                              %b%║ 
echo.                        %b%║                                     %p%[M]%w% Back to menu                                         %b%║
echo.                        %b%║                                                                                              %b%║
echo.                        %b%╚══════════════════════════════════════════════════════════════════════════════════════════════╝
echo.

set /p input=:
if /i %input% == 1 goto r1
if /i %input% == 2 goto r2
if /i %input% == 3 goto r3
if /i %input% == 4 goto r4
if /i %input% == 5 goto r5
if /i %input% == 6 goto r6
if /i %input% == M cls & goto menu

) ELSE (
echo Invalid Input & goto MisspellRedirect

:MisspellRedirect
cls
echo Misspell Detected
timeout 2
goto RedirectMenu


:RedirectMenu
cls
goto :e

:r6
echo %w% - Enable Bluetooth%b%
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\BTAGService" /v "Start" /t REG_DWORD /d "2" /f
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\bthserv" /v "Start" /t REG_DWORD /d "2" /f
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\BthAvctpSvc" /v "Start" /t REG_DWORD /d "2" /f
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\BluetoothUserService" /v "Start" /t REG_DWORD /d "2" /f
echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :menu

:r5
cls
echo %w% - Enable Notifications%b%
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "1" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_NOTIFICATION_SOUND" /t REG_DWORD /d "1" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK" /t REG_DWORD /d "1" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\QuietHours" /v "Enabled" /t REG_DWORD /d "1" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel" /v "Enabled" /t REG_DWORD /d "1" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.AutoPlay" /v "Enabled" /t REG_DWORD /d "1" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.LowDisk" /v "Enabled" /t REG_DWORD /d "1" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.Print.Notification" /v "Enabled" /t REG_DWORD /d "1" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance" /v "Enabled" /t REG_DWORD /d "1" /f 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.WiFiNetworkManager" /v "Enabled" /t REG_DWORD /d "1" /f 
Reg.exe add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "0" /f
echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :menu

:r4
echo %w% - Enabling Gamedvr Services%b%
Reg.exe add "HKCU\Software\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\Software\Microsoft\GameBar" /v "GameDVR_Enabled" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AudioCaptureEnabled" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "CursorCaptureEnabled" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "HistoricalCaptureEnabled" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\GameDVR" /v "AllowgameDVR" /t REG_DWORD /d "1" /f
echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :menu

:r3
echo %w% - Enabling Xbox Services%b%
sc config xbgm start= demand
sc config XblAuthManager start= demand
sc config XblGameSave start= demand
sc config XboxGipSvc start= demand
sc config XboxNetApiSvc start= demand
echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :menu

:r2
echo %w% - Redownloading default windows apps%b%
Powershell -Command "Get-AppxPackage -allusers | foreach {Add-AppxPackage -register “$($_.InstallLocation)\appxmanifest.xml” -DisableDevelopmentMode}"
echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :menu

:r1
echo %w% - Resetting power plans%b%
powercfg –restoredefaultschemes
echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :menu



:exit
cls
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║   %w%RESTART YOUR PC, THE TWEAKS WONT WORK WITHOUT IT!    %b%║
echo.                                              %b%║═══════════════════════════════════════════════════════║  
echo.                                              %b%║  %w%             Press any key to exit...                %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
exit







:8
cls
echo %w%- CPU Cooling Tweaks %b%
powercfg /setACvalueindex scheme_current SUB_PROCESSOR SYSCOOLPOL 1
powercfg /setDCvalueindex scheme_current SUB_PROCESSOR SYSCOOLPOL 1
powercfg /setactive SCHEME_CURRENT

echo %w%- Enable All Logical Processors %b%
bcdedit /set {current} numproc %NUMBER_OF_PROCESSORS% 

echo %w% - Disable C-States%b%
powercfg -setacvalueindex scheme_current SUB_SLEEP AWAYMODE 0
powercfg /setactive SCHEME_CURRENT
powercfg -setacvalueindex scheme_current SUB_SLEEP ALLOWSTANDBY 0
powercfg /setactive SCHEME_CURRENT
powercfg -setacvalueindex scheme_current SUB_SLEEP HYBRIDSLEEP 0
powercfg /setactive SCHEME_CURRENT
powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100
powercfg /setactive SCHEME_CURRENT
timeout /t 1 /nobreak > NUL

echo %w%- Use Higher P-States on Lower C-States And Viseversa %b%
powercfg -setacvalueindex scheme_current sub_processor IDLESCALING 1
powercfg /setactive SCHEME_CURRENT

echo %w% - Disable Core Parking%b%
powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 100
powercfg /setactive SCHEME_CURRENT
timeout /t 1 /nobreak > NUL

echo %w% - Disable Throttle States%b%
powercfg -setacvalueindex scheme_current sub_processor THROTTLING 0
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMin" /t REG_DWORD /d "0" /f
echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :menu



:7
:gpu
cls
echo.
echo.
echo.                                           %p%  ░██████╗░██████╗░██╗░░░██╗         
echo.                                           %p%  ██╔════╝░██╔══██╗██║░░░██║        
echo.                                           %p%  ██║░░██╗░██████╔╝██║░░░██         
echo.                                           %p%  ██║░░╚██╗██╔═══╝░██║░░░██║        
echo.                                           %p%  ╚██████╔╝██║░░░░░╚██████╔╝        
echo.                                           %p%  ░╚═════╝░╚═╝░░░░░░╚═════╝░        
echo.                        %b%╔══════════════════════════════════════════════════════════════════╗%w%
echo.                        %b%║  %w% Optimize 3d settings, disable useless features and more        %b%║        
echo.                        %b%║                                                                  %b%║
echo.                        %b%║                                                                  %b%║
echo.                        %b%║                  %p%[1]%w% NVIDIA GPU Tweaks                           %b%║
echo.                        %b%║                                                                  %b%║
echo.                        %b%║                  %p%[2]%w% AMD GPU Tweaks                              %b%║
echo.                        %b%║                                                                  %b%║
echo.                        %b%║                  %p%[3]%w% Intel GPU Tweaks                            %b%║
echo.                        %b%║                                                                  %b%║ 
echo.                        %b%║                                                                  %b%║ 
echo.                        %b%║                    %p%[M]%w% Back to menu                              %b%║
echo.                        %b%║                                                                  %b%║
echo.                        %b%╚══════════════════════════════════════════════════════════════════╝
echo.

set /p input=:
if /i %input% == 1 goto g1
if /i %input% == 2 goto g2
if /i %input% == 3 goto g3
if /i %input% == M cls & goto menu

) ELSE (
echo Invalid Input & goto MisspellRedirect

:MisspellRedirect
cls
echo Misspell Detected
timeout 2
goto RedirectMenu


:RedirectMenu
cls
goto :e


:g3
cls
echo %w% - Intel Gpu Tweaks%b%
for /f %%t in ('Reg query "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" /t REG_SZ /s /e /f "Intel" ^| findstr "HKEY"') do (

	Reg.exe add "%%t" /v "Disable_OverlayDSQualityEnhancement" /t REG_DWORD /d "1" /f
    Reg.exe add "%%t" /v "IncreaseFixedSegment" /t REG_DWORD /d "1" /f
    Reg.exe add "%%t" /v "AdaptiveVsyncEnable" /t REG_DWORD /d "0" /f
    Reg.exe add "%%t" /v "DisablePFonDP" /t REG_DWORD /d "1" /f
    Reg.exe add "%%t" /v "EnableCompensationForDVI" /t REG_DWORD /d "1" /f
    Reg.exe add "%%t" /v "NoFastLinkTrainingForeDP" /t REG_DWORD /d "0" /f
    Reg.exe add "%%t" /v "ACPowerPolicyVersion" /t REG_DWORD /d "16898" /f
    Reg.exe add "%%t" /v "DCPowerPolicyVersion" /t REG_DWORD /d "16642" /f
)


Reg.exe add "HKLM\Software\Intel\GMM" /v "DedicatedSegmentSize" /t REG_DWORD /d "512" /f
echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :menu




:1
cls
echo.
echo.
echo.                                         %p%   ░██████╗░███████╗███╗░░██╗███████╗██████╗░░█████╗░██╗░░░░░     
echo.                                         %p%   ██╔════╝░██╔════╝████╗░██║██╔════╝██╔══██╗██╔══██╗██║░░░░░     
echo.                                         %p%   ██║░░██╗░█████╗░░██╔██╗██║█████╗░░██████╔╝███████║██║░░░░░    
echo.                                         %p%   ██║░░╚██╗██╔══╝░░██║╚████║██╔══╝░░██╔══██╗██╔══██║██║░░░░░      
echo.                                         %p%   ╚██████╔╝███████╗██║░╚███║███████╗██║░░██║██║░░██║███████╗     
echo.                                         %p%   ░╚═════╝░╚══════╝╚═╝░░╚══╝╚══════╝╚═╝░░╚═╝╚═╝░░╚═╝╚══════╝    
echo.                        %b%╔══════════════════════════════════════════════════════════════════════════════════════════════╗%w%
echo.                        %b%║                             %w% General Performance Optimizations                               %b%║        
echo.                        %b%║  %w% if you want more info about the specific tweaks, Use google to search up the names         %b%║
echo.                        %b%║                                                                                              %b%║
echo.                        %b%║                                                                                              %b%║
echo.                        %b%║           %p%[1]%w% General Performance Tweaks  %p%[2]%w% Setting Win32Priority (26HEX)                  %b%║
echo.                        %b%║                                                                                              %b%║
echo.                        %b%║           %p%[3]%w% Basic BCDedit Tweaks        %p%[4]%w% NFTS Tweaks                                    %b%║
echo.                        %b%║                                                                                              %b%║
echo.                        %b%║           %p%[5]%w% MMCSS Priority Tweaks       %p%[6]%w% Disable Mitigations                            %b%║
echo.                        %b%║                                                                                              %b%║          
echo.                        %b%║           %p%[7]%w% Set IRQ8 + IRQ16 Priority   %p%[8]%w% Disable Fast Startup, Hibernation...           %b%║
echo.                        %b%║                                                                                              %b%║          
echo.                        %b%║           %p%[9]%w% Set System Responsiveness   %p%[10]%w% Optimize Network Throttoling Index            %b%║
echo.                        %b%║                                                                                              %b%║         
echo.                        %b%║                                                                                              %b%║          
echo.                        %b%║                                    %p%[M]%w% Back to menu                                          %b%║
echo.                        %b%║                                                                                              %b%║
echo.                        %b%╚══════════════════════════════════════════════════════════════════════════════════════════════╝
echo.

set /p input=:
if /i %input% == 1 goto p1
if /i %input% == 2 goto p2
if /i %input% == 3 goto p3
if /i %input% == 4 goto p4
if /i %input% == 5 goto p5
if /i %input% == 6 goto p6
if /i %input% == 7 goto p7
if /i %input% == 8 goto p8
if /i %input% == 9 goto p9
if /i %input% == 10 goto p10
if /i %input% == M cls & goto menu

) ELSE (
echo Invalid Input & goto MisspellRedirect

:MisspellRedirect
cls
echo Misspell Detected
timeout 2
goto RedirectMenu

:RedirectMenu
goto :1


:P8
echo %w% - Disabling Fast Startup%b%
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Disabling Hibernation%b%
powercfg /h off
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabled" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "SleepReliabilityDetailedDiagnostics" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Disabling Sleep Study%b%
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "SleepStudyDisabled" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL

echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :1

:p3
echo %w% - Disable Dynamic Tick%b%
bcdedit /set disabledynamictick yes >nul 2>&1
timeout /t 1 /nobreak > NUL

echo %w% - Disable High Precision Event Timer (HPET)%b%
bcdedit /deletevalue useplatformclock  >nul 2>&1
timeout /t 1 /nobreak > NUL

echo %w% - Disable Synthetic Timers%b%
bcdedit /set useplatformtick yes  >nul 2>&1
timeout /t 1 /nobreak > NUL

echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :1

:p4
echo %w% - NFTS Tweaks%b%
fsutil behavior set memoryusage 2 >nul 2>&1
fsutil behavior set mftzone 4 >nul 2>&1
fsutil behavior set disablelastaccess 1 >nul 2>&1
fsutil behavior set disabledeletenotify 0 >nul 2>&1
fsutil behavior set encryptpagingfile 0 >nul 2>&1
timeout /t 1 /nobreak > nul

echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :1

:p10
echo %w% - Network Throttoling Index%b%
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "4294967295" /f
echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :menu

:P5
echo %w% - MMCSS Priority For Low Latency%b%
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Low Latency" /v "Affinity" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Low Latency" /v "Background Only" /t REG_SZ /d "False" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Low Latency" /v "BackgroundPriority" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Low Latency" /v "Clock Rate" /t REG_DWORD /d "10000" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Low Latency" /v "GPU Priority" /t REG_DWORD /d "8" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Low Latency" /v "Priority" /t REG_DWORD /d "2" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Low Latency" /v "Scheduling Category" /t REG_SZ /d "Medium" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Low Latency" /v "SFIO Priority" /t REG_SZ /d "High" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Low Latency" /v "Latency Sensitive" /t REG_SZ /d "True" /f
timeout /t 1 /nobreak > nul

echo %w% - MMCSS Priority For Games%b%
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Affinity" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Background Only" /t REG_SZ /d "False" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "BackgroundPriority" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Clock Rate" /t REG_DWORD /d "10000" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d "18" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d "2" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d "True" /f
timeout /t 1 /nobreak > nul

echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :1

:p2
echo %w% - Setting Win32Priority%b%
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "38" /f 

echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :1



:p6
echo %w% - Disabling VirtualizationBasedSecurity%b%
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL
echo %w% - Disabling HVCIMATRequired%b%
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HVCIMATRequired" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL
echo %w% - Disabling ExceptionChainValidation%b%
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DisableExceptionChainValidation" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL
echo %w% - Disabling Sehop%b%
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "KernelSEHOPEnabled" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL
echo %w% - Disabling CFG%b%
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableCfg" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL
echo %w% - Disabling Protection Mode%b%
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "ProtectionMode" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL
echo %w% - Disabling Spectre And Meltdown%b%
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettings" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "3" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Disabling Other Mitigations%b%
chcp 437 >nul 
timeout /t 1 /nobreak > NUL
powershell "Remove-Item -Path \"HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\*\" -Recurse -ErrorAction SilentlyContinue"
timeout /t 1 /nobreak > NUL
chcp 65001 >nul  
timeout /t 1 /nobreak > NUL

echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :1

:p7
echo %w% - IRQ8 Priority %b%
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "IRQ8Priority" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SYSTEM\ControlSet001\Control\PriorityControl" /v "IRQ8Priority" /t REG_DWORD /d "1" /f
timeout /t 1 /nobreak > NUL

echo %w% - IRQ16 Priority %b%
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "IRQ16Priority" /t REG_DWORD /d "2" /f
Reg.exe add "HKLM\SYSTEM\ControlSet001\Control\PriorityControl" /v "IRQ16Priority" /t REG_DWORD /d "2" /f
timeout /t 1 /nobreak > NUL

echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :1




:p1
echo %w% - Enabling Large System Cache%b%
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL


echo %w% - Disabling Paging Executive%b%
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DpiMapIommuContiguous" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Disabling Address Space Layout Randomization%b%
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "MoveImages" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NULw


echo %w% - SVC split host%b%
for /f "skip=1" %%i in ('wmic os get TotalVisibleMemorySize') do if not defined TOTAL_MEMORY set "TOTAL_MEMORY=%%i" & set /a SVCHOST=%%i+1024000
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "!SVCHOST!" /f 
timeout /t 1 /nobreak > NUL


echo %w% - Disable Prefetch and superfetch%b%
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d "0" /f
timeout /t 1 /nobreak > NUL

echo %w% - Decrease processes kill time and menu show delay%b%
Reg.exe add "HKCU\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f
Reg.exe add "HKCU\Control Panel\Desktop" /v "HungAppTimeout" /t REG_SZ /d "1000" /f
Reg.exe add "HKCU\Control Panel\Desktop" /v "WaitToKillAppTimeout" /t REG_SZ /d "2000" /f
Reg.exe add "HKCU\Control Panel\Desktop" /v "LowLevelHooksTimeout" /t REG_SZ /d "1000" /f
Reg.exe add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_SZ /d "2000" /f
timeout /t 1 /nobreak > NUL


echo %w% - Setting Time Stamp%b%
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability" /v "TimeStampInterval" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability" /v "IoPriority" /t REG_DWORD /d "3" /f 
timeout /t 1 /nobreak > NUL


echo %w% - Setting CSRSS to Realtime%b%
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Setting Latency Tolerance%b%
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorLatencyTolerance" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ExitLatency" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ExitLatencyCheckEnabled" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "Latency" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceDefault" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceFSVP" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyTolerancePerfOverride" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceScreenOffIR" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceVSyncEnabled" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "RtlCapabilityCheckLatency" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyActivelyUsed" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleLongTime" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleMonitorOff" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleNoContext" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleShortTime" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleVeryLongTime" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle0" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle0MonitorOff" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle1" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle1MonitorOff" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceMemory" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceNoContext" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceNoContextMonitorOff" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceOther" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceTimerPeriod" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultMemoryRefreshLatencyToleranceActivelyUsed" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultMemoryRefreshLatencyToleranceMonitorOff" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultMemoryRefreshLatencyToleranceNoContext" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "Latency" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MaxIAverageGraphicsLatencyInOneBucket" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MiracastPerfTrackGraphicsLatency" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MonitorLatencyTolerance" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "TransitionLatency" /t REG_DWORD /d "1" /f 
echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :1

:p9
echo %w% - Setting System Responsiveness%b%
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "0" /f 


echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :1



:2war
chcp 437 >nul 2>&1
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Do NOT do these if your pc has bad overheating issues', 'Exm Tweaking Utility', 'Ok', [System.Windows.Forms.MessageBoxIcon]::Information);}"
timeout /t 1 /nobreak > nul
chcp 65001 >nul 2>&1
:2

:power
cls
echo.
echo.
echo.                                    %p%██████╗░░█████╗░░██╗░░░░░░░██╗███████╗██████╗░     
echo.                                    %p%██╔══██╗██╔══██╗░██║░░██╗░░██║██╔════╝██╔══██╗ 
echo.                                    %p%██████╔╝██║░░██║░╚██╗████╗██╔╝█████╗░░██████╔╝        
echo.                                    %p%██╔═══╝░██║░░██║░░████╔═████║░██╔══╝░░██╔══██   
echo.                                    %p%██║░░░░░╚█████╔╝░░╚██╔╝░╚██╔╝░███████╗██║░░██║      
echo.                                    %p%╚═╝░░░░░░╚════╝░░░░╚═╝░░░╚═╝░░╚══════╝╚═╝░░╚═╝      
echo.                        %b%╔══════════════════════════════════════════════════════════════════╗%w%
echo.                        %b%║          %w% Might increase temps on poorly cooled pcs              %b%║        
echo.                        %b%║                                                                  %b%║
echo.                        %b%║                                                                  %b%║
echo.                        %b%║                   %p%[1]%w% Apply Exm Free Power Plan V2               %b%║
echo.                        %b%║                                                                  %b%║ 
echo.                        %b%║                   %p%[2]%w% Power Tweaks                               %b%║
echo.                        %b%║                                                                  %b%║ 
echo.                        %b%║                                                                  %b%║ 
echo.                        %b%║                   %p%[M]%w% Back to menu                               %b%║
echo.                        %b%║                                                                  %b%║
echo.                        %b%╚══════════════════════════════════════════════════════════════════╝
echo.

set /p input=:
if /i %input% == 1 goto p1
if /i %input% == 2 goto p2
if /i %input% == M cls & goto menu

) ELSE (
echo Invalid Input & goto MisspellRedirect

:MisspellRedirect
cls
echo Misspell Detected
timeout 2
goto RedirectMenu


:RedirectMenu
cls
goto :power


:p1
cls
echo %w% Import Exm Free Power Plan V2%b%

powercfg -import "C:\exmfree\Exm_Free_Power_Plan_V2.pow"
powercfg.cpl
timeout /t 1 /nobreak > NUL

echo %w% - Deleting useless power plans%b%
powercfg -delete 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg -delete 381b4222-f694-41f0-9685-ff5bb260df2e
powercfg -delete a1841308-3541-4fab-bc81-f71556f20b4a

echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :power

:P2
cls
echo %w%- Disable Idle Power Managment %b%
for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum" /s /f "StorPort"^| findstr "StorPort"') do Reg.exe add "%%i" /v "EnableIdlePowerManagement" /t REG_DWORD /d "0" /f
    for %%i in (EnableHIPM EnableDIPM EnableHDDParking) do for /f %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /f "%%i" ^| findstr "HKEY"') do Reg.exe add "%%a" /v "%%i" /t REG_DWORD /d "0" /f 
    )

echo %w%- Disable Link State Power Managment %b%
FOR /F "eol=E" %%a in ('REG QUERY "HKLM\System\CurrentControlSet\Services" /s "EnableHIPM"^| FINDSTR /V "EnableHIPM"') DO (
Reg.exe add "%%a" /v "EnableHIPM" /t REG_DWORD /d "0" /f  > nul 
Reg.exe add "%%a" /v "EnableDIPM" /t REG_DWORD /d "0" /f > nul 
FOR /F "tokens=*" %%z IN ("%%a") DO (
SET STR=%%z
SET STR=!STR:HKLM\System\CurrentControlSet\Services\=!
) > nul 
)
	
	
echo %w% - Disabling GPU Energy Driver%b%
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t REG_DWORD /d "4" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDr" /v "Start" /t REG_DWORD /d "4" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Disabling Energy Logging%b%
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "DisableTaggedEnergyLogging" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxApplication" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxTagPerApplication" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Disabling CoalescingTimerInterval%b%
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\ModernSleep" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PlatformAoAcOverride" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EnergyEstimationEnabled" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EventProcessorEnabled" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CsEnabled" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Disabling Power Throttling%b%
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL

echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :menu




:5
cls
echo %w% - Disabling Memory Compression%b%
chcp 437 > nul
PowerShell -Command "Disable-MMAgent -MemoryCompression" > nul 2>&1
chcp 65001 > nul
timeout /t 1 /nobreak > NUL

echo %w% - Disabling Paging Executive%b%
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DpiMapIommuContiguous" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL

echo %w% - SVC split host%b%
for /f "skip=1" %%i in ('wmic os get TotalVisibleMemorySize') do if not defined TOTAL_MEMORY set "TOTAL_MEMORY=%%i" & set /a SVCHOST=%%i+1024000
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "!SVCHOST!" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Disabling Prefetch and superfetch%b%
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d "0" /f
timeout /t 1 /nobreak > NUL


echo %w% - More Memory Managment Tweaks%b%
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ClearPageFileAtShutdown" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "NonPagedPoolQuota" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "NonPagedPoolSize" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PagedPoolQuota" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PagedPoolSize" /t REG_DWORD /d "192" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "SecondLevelDataCache" /t REG_DWORD /d "1024" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "SessionPoolSize" /t REG_DWORD /d "192" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "SessionViewSize" /t REG_DWORD /d "192" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "SystemPages" /t REG_DWORD /d "4294967295" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PhysicalAddressExtension" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettings" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "3" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IoPageLockLimit" /t REG_DWORD /d "16710656" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PoolUsageMaximum" /t REG_DWORD /d "96" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "Start" /t REG_DWORD /d "4" /f


echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :menu




:g1
cls

echo %w% - Applying Nvidia Profile Inspector Profile%b%
start "" /wait "C:\Exmfree\NvidiaProfileInspector.exe" "C:\exmfree\Exm_Free_Settings_V4.nip" 

echo %w% - Enabling MSI Mode%b%
for /f %%g in ('wmic path win32_videocontroller get PNPDeviceID ^| findstr /L "VEN_"') do (
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%g\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f  
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%g\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t REG_DWORD /d "0" /f 
)
timeout /t 1 /nobreak > NUL

echo %w% - Setting NVIDIA Latency Tolerance%b%
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "D3PCLatency" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "F1TransitionLatency" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "LOWLATENCY" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "Node3DLowLatency" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PciLatencyTimerControl" /t REG_DWORD /d "20" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMDeepL1EntryLatencyUsec" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmGspcMaxFtuS" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmGspcMinFtuS" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmGspcPerioduS" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMLpwrEiIdleThresholdUs" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMLpwrGrIdleThresholdUs" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMLpwrGrRgIdleThresholdUs" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMLpwrMsIdleThresholdUs" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "VRDirectFlipDPCDelayUs" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "VRDirectFlipTimingMarginUs" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "VRDirectJITFlipMsHybridFlipDelayUs" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "vrrCursorMarginUs" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "vrrDeflickerMarginUs" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "vrrDeflickerMaxUs" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Disabling NVIDIA Telemetry%b%
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "NvBackend" /f 
Reg.exe add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID66610" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID64640" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID44231" /t REG_DWORD /d "0" /f 
schtasks /change /disable /tn "NvTmRep_CrashReport1_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" 
schtasks /change /disable /tn "NvTmRep_CrashReport2_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" 
schtasks /change /disable /tn "NvTmRep_CrashReport3_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" 
schtasks /change /disable /tn "NvTmRep_CrashReport4_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" 
schtasks /change /disable /tn "NvDriverUpdateCheckDaily_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" 
schtasks /change /disable /tn "NVIDIA GeForce Experience SelfUpdate_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" 
schtasks /change /disable /tn "NvTmMon_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" 
timeout /t 1 /nobreak > NUL

echo %w% - Disabling Write Combining%b%
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisableWriteCombining" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Disabling Preemption%b%
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisablePreemption" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisableCudaContextPreemption" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "EnableCEPreemption" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisablePreemptionOnS3S4" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "ComputePreemption" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL
echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :menu


:g2
cls
echo %w% -  Enabling MSI Mode %b%
for /f %%g in ('wmic path win32_videocontroller get PNPDeviceID ^| findstr /L "VEN_"') do (
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%g\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f  
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%g\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t REG_DWORD /d "0" /f 
)
timeout /t 1 /nobreak > NUL


echo %w% - Disabling Display Refresh Rate Override%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "3D_Refresh_Rate_Override_DEF" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL


echo %w% - Disabling SnapShot%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSnapshot" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Disabling Anti Aliasing%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AAF_NA" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AntiAlias_NA" /t REG_SZ /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "ASTT_NA" /t REG_SZ /d "0" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Disabling Subscriptions%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSubscription" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Disabling Anisotropic Filtering%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AreaAniso_NA" /t REG_SZ /d "0" /f 
timeout /t 1 /nobreak > NUL


echo %w% - Disabling Radeon Overlay%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowRSOverlay" /t REG_SZ /d "false" /f  
timeout /t 1 /nobreak > NUL

echo Enabling Adaptive DeInterlacing%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "Adaptive De-interlacing" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL


echo %w% - Disabling Skins%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSkins" /t REG_SZ /d "false" /f  
timeout /t 1 /nobreak > NUL

echo %w% - Disabling Automatic Color Depth Reduction%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AutoColorDepthReduction_NA" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL


echo %w% - Disabling Power Gating%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableSAMUPowerGating" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableUVDPowerGatingDynamic" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableVCEPowerGating" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisablePowerGating" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDrmdmaPowerGating" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL


echo %w% - Disabling Clock Gating%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableVceSwClockGating" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUvdClockGating" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Disabling Active State Power Management%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableAspmL0s" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableAspmL1" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL


echo %w% - Disabling Ultra Low Power States%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUlps" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUlps_NA" /t REG_SZ /d "0" /f 
timeout /t 1 /nobreak > NUL


echo %w% - Enabling De-Lag%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_DeLagEnabled" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Disabling Frame Rate Target%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_FRTEnabled" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Disabling DMA%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDMACopy" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Enable BlockWrite%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableBlockWrite" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Disabling Stutter Mode%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "StutterMode" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Disabling GPU Memory Clock Sleep State%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_SclkDeepSleepDisable" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Disabling Thermal Throttling%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_ThermalAutoThrottlingEnable" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Disabling Preemption%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableComputePreemption" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Setting Main3D%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Main3D_DEF" /t REG_SZ /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Main3D" /t REG_BINARY /d "3100" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Setting FlipQueueSize%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "FlipQueueSize" /t REG_BINARY /d "3100" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Setting Shader Cache Size%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "ShaderCache" /t REG_BINARY /d "3200" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Configuring TFQ%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "TFQ" /t REG_BINARY /d "3200" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Disabling High-Bandwidth Digital Content Protection%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\\DAL2_DATA__2_0\DisplayPath_4\EDID_D109_78E9\Option" /v "ProtectionControl" /t REG_BINARY /d "0100000001000000" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Disabling GPU Power Down%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_GPUPowerDownEnabled" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Disabling AMD Logging%b%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\amdlog" /v "Start" /t REG_DWORD /d "4" /f 
timeout /t 1 /nobreak > NUL

echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :menu



:9
cls
echo %w% - Disabling USB PowerSavings%b%
for /f %%i in ('wmic path Win32_USBController get PNPDeviceID^| findstr /l "PCI\VEN_"') do (
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "AllowIdleIrpInD3" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "D3ColdSupported" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "DeviceSelectiveSuspended" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnableSelectiveSuspend" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnhancedPowerManagementEnabled" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendEnabled" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendOn" /t REG_DWORD /d "0" /f 
)
timeout /t 1 /nobreak > NUL

echo %w% - Thread Priority%b%
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\usbxhci\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\USBHUB3\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\NDIS\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f
timeout /t 1 /nobreak > NUL

echo %w% - Disabling USB Selective Suspend%b%
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\USB" /v "DisableSelectiveSuspend" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL

echo %w% - Enabing MSI mode on usb%b%
for /f %%i in ('wmic path Win32_USBController get PNPDeviceID') do set "str=%%i" & (
echo.DEL USB Device Priority %b%
Reg.exe add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f
echo.Enable MSI Mode on USB %b%
Reg.exe add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
)

echo %w% - USB Msi Priority%b%
for /f %%i in ('wmic path Win32_IDEController get PNPDeviceID 2^>nul') do set "str=%%i" & if "!str:PCI\VEN_=!" neq "!str!" (
echo %w%- DEL Sata controllers Device Priority %b%
Reg.exe add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f
)

echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :menu

:10
cls
echo %w% - Disabling Filter Keys (the filterkeys app is completely useless, dont use it)%b%
Reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_SZ /d "122" /f
timeout /t 1 /nobreak > NUL
echo %w% - Disabling Toggle Keys%b%
Reg.exe add "HKCU\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_SZ /d "58" /f
timeout /t 1 /nobreak > NUL
echo %w% - Disabling Sticky Keys%b%
Reg.exe add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_SZ /d "506" /f
timeout /t 1 /nobreak > NUL
echo %w% - Disabling Mouse Keys%b%
Reg.exe add "HKCU\Control Panel\Accessibility\MouseKeys" /v "Flags" /t REG_SZ /d "0" /f

echo %w% - Disabling Mouse Acceleration%b%
Reg.exe add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f
Reg.exe add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f
Reg.exe add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f
timeout /t 1 /nobreak > NUL

echo %w% - Enabling 1:1 Pixel Mouse Movements%b%
Reg.exe add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t REG_SZ /d "10" /f
timeout /t 1 /nobreak > NUL

echo %w% - Reducing Keyboard Repeat Delay%b%
Reg.exe add "HKCU\Control Panel\Keyboard" /v "KeyboardDelay" /t REG_SZ /d "0" /f
timeout /t 1 /nobreak > NUL

echo %w% - Increasing Keyboard Repeat Rate%b%
Reg.exe add "HKCU\Control Panel\Keyboard" /v "KeyboardSpeed" /t REG_SZ /d "31" /f
timeout /t 1 /nobreak > NUL

echo %w% - Setting CSRSS to Realtime%b%
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f 
timeout /t 1 /nobreak > NUL 
cls 
echo.
echo.
echo.

echo.                                                          %p% ██╗░░██╗██████╗░███╗░░░███╗
echo.                                                          %p% ██║░██╔╝██╔══██╗████╗░████║
echo.                                                          %p% █████═╝░██████╦╝██╔████╔██║
echo.                                                          %p% ██╔═██╗░██╔══██╗██║╚██╔╝██║
echo.                                                          %p% ██║░╚██╗██████╦╝██║░╚═╝░██║
echo.                                                          %p% ╚═╝░░╚═╝╚═════╝░╚═╝░░░░░╚═╝
echo.                        %b%╔══════════════════════════════════════════════════════════════════════════════════════════════╗
echo.                        %b%║                      %w% Low mouse data queue size lowers peripheral latency (input delay),     %b%║
echo.                        %b%║                     %w% but it may cause mouse and kb lag on low end CPUs                       %b%║        
echo.                        %b%║                                                                                              %b%║
echo.                        %b%║                                                                                              %b%║
echo.                        %b%║           %p%[1]%w% High End CPU        %p%[2]%w% Mid end CPU          %p%[3]%w% Low end CPU                   %b%║
echo.                        %b%║                                                                                              %b%║
echo.                        %b%║                                                                                              %b%║
echo.                        %b%║                   %p%[R]%w% Revert Mouse and keyboard data queue size to default                   %b%║
echo.                        %b%║                                                                                              %b%║
echo.                        %b%║                                                                                              %b%║
echo.                        %b%╚══════════════════════════════════════════════════════════════════════════════════════════════╝
echo.


set /p input=: 
if /i %input% == 1 goto 14v
if /i %input% == 2 goto 17v
if /i %input% == 3 goto 20v
if /i %input% == R goto Revert
if /i %input% == X cls & goto mouse

) ELSE (
echo Invalid Input & goto MisspellRedirect

:MisspellRedirect
cls
echo Misspell Detected
timeout 2 
goto Redirectmouse


:Redirectmouse
cls
goto :mouse

:14v
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d "20" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t REG_DWORD /d "20" /f

echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :menu

:17v
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d "23" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t REG_DWORD /d "23" /f

echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :menu


:20v
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d "32" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t REG_DWORD /d "32" /f
echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :menu







:6
cls
chcp 437 > nul

powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('After you press ok it will open an app, Go to the LOGON section, disable all services except: antivirus, cmd.exe, and the n/a services', 'Exm Tweaking Utility', 'Ok', [System.Windows.Forms.MessageBoxIcon]::Information);}"
chcp 65001 > nul

start C:\exmfree\autoruns.exe
echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :menu





:4
cls
echo %w% -  Cleaning Useless Device Data...%b%
chcp 437 > nul
@echo on
POWERSHELL "$Devices = Get-PnpDevice | ? Status -eq Unknown;foreach ($Device in $Devices) { &\"pnputil\" /remove-device $Device.InstanceId }"
@echo off
chcp 65001 > nul
timeout /t 1 /nobreak > NUL
echo.
echo %w% -  Using Windows Clean Manager To fully clean...%b%
start "" /wait "C:\Windows\System32\cleanmgr.exe" /sagerun:50 
echo.
echo.
echo.
echo.                                              %b%╔═══════════════════════════════════════════════════════╗
echo.                                              %b%║  %w%  Operation Completed, Press any key to continue...  %b%║
echo.                                              %b%╚═══════════════════════════════════════════════════════╝
pause > nul
cls
goto :menu