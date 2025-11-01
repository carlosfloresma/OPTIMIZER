@echo off
title LIMPIEZA EXTREMA SEGURA PARA SSD
color 0C
echo =======================================================
echo       LIMPIEZA EXTREMA Y OPTIMIZACION PARA SSD
echo      Desarrollado por su servidor Ing. Carlos Flores
echo =======================================================
echo.

:: Verificar permisos de administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Ejecuta este archivo como administrador.
    pause
    exit
)

:: Cerrar procesos innecesarios
echo Cerrando procesos innecesarios...
taskkill /f /im OneDrive.exe >nul 2>&1
taskkill /f /im chrome.exe >nul 2>&1
taskkill /f /im msedge.exe >nul 2>&1
taskkill /f /im firefox.exe >nul 2>&1
taskkill /f /im opera.exe >nul 2>&1
taskkill /f /im steam.exe >nul 2>&1
taskkill /f /im epicgameslauncher.exe >nul 2>&1

:: Detener servicios temporales
echo Deteniendo servicios temporales...
for %%s in (wuauserv bits sysmain diagsvc diagnosticshub.standardcollector.service fax mapsbroker) do (
    net stop %%s >nul 2>&1
)

echo.
echo === LIMPIANDO ARCHIVOS TEMPORALES Y SISTEMA ===
del /s /f /q "%temp%\*" >nul 2>&1
del /s /f /q "C:\Windows\Temp\*" >nul 2>&1
del /s /f /q "C:\Windows\Prefetch\*" >nul 2>&1
del /s /f /q "%AppData%\Microsoft\Windows\Recent\*" >nul 2>&1

echo === LIMPIANDO CACHES DE NAVEGADORES ===
del /s /q "%LocalAppData%\Google\Chrome\User Data\Default\Cache\*" >nul 2>&1
del /s /q "%LocalAppData%\Google\Chrome\User Data\Default\Code Cache\*" >nul 2>&1
del /s /q "%LocalAppData%\Microsoft\Edge\User Data\Default\Cache\*" >nul 2>&1
del /s /q "%AppData%\Mozilla\Firefox\Profiles\\cache2\entries\" >nul 2>&1

echo === LIMPIANDO LOGS, DUMPS Y RESTOS DE WINDOWS ===
for %%f in ("C:\Windows\Logs\" "C:\Windows\System32\LogFiles\" "C:\Windows\Minidump\" "C:\ProgramData\Microsoft\Diagnosis\" "%LocalAppData%\CrashDumps\*") do (
    del /s /f /q %%f >nul 2>&1
)



echo === LIMPIANDO CACHES DE WINDOWS STORE ===
del /s /f /q "%LocalAppData%\Packages\Microsoft.WindowsStore*\LocalCache\*" >nul 2>&1
del /s /f /q "C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache\*" >nul 2>&1

echo === LIMPIANDO CACHES GRAFICOS Y THUMBNAILS ===
for %%g in ("%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_" "%LocalAppData%\NVIDIA\DXCache\" "%LocalAppData%\AMD\DxCache\*") do (
    del /s /f /q %%g >nul 2>&1
)

echo === VACIANDO PAPELERA DE RECICLAJE ===
rd /s /q C:\$Recycle.bin >nul 2>&1

:: Reiniciar servicios clave
echo Reiniciando servicios...
for %%s in (wuauserv bits sysmain) do (
    net start %%s >nul 2>&1
)

:: Optimización de red
echo Optimizando red y DNS...
ipconfig /flushdns >nul
netsh winsock reset >nul
netsh int ip reset >nul



color 0A
echo =================================================
echo      PART 2
echo =================================================
echo.

:: EFECTOS VISUALES
echo Ajustando efectos visuales y apariencia...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f
reg add "HKCU\Control Panel\Desktop" /v MinAnimate /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 90120080 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ComboBoxAnimation /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v MenuShowDelay /t REG_DWORD /d 0 /f
echo Efectos visuales optimizados.
echo.

:: DESACTIVAR SONIDOS
echo Desactivando sonidos del sistema...
reg add "HKCU\AppEvents\Schemes" /ve /t REG_SZ /d ".None" /f
echo Sonidos desactivados.
echo.

:: SSD OPTIMIZACIÓN
echo Optimizando SSD y prefetch...
schtasks /Change /TN "\Microsoft\Windows\Defrag\ScheduledDefrag" /Disable >nul 2>&1
fsutil behavior set DisableDeleteNotify 0 >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 3 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 3 /f
echo SSD optimizado.
echo.

:: PLAN DE ENERGIA
echo Configurando plan de energia máximo rendimiento...
powercfg -setactive SCHEME_MIN >nul 2>&1
powercfg -change -monitor-timeout-ac 0 >nul 2>&1
powercfg -change -standby-timeout-ac 0 >nul 2>&1
echo Energía ajustada.
echo.

:: OPTIMIZACIÓN FINAL
echo =================================================
echo  OPTIMIZACION COMPLETA EXITOSA
echo  REINICIA TU EQUIPO PARA APLICAR TODOS LOS CAMBIOS
echo =================================================
echo.

:: DESACTIVAR WIDGETS Y NOTICIAS
echo Desactivando noticias y widgets...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v EnableFeeds /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds" /v ShellFeedsTaskbarViewMode /t REG_DWORD /d 2 /f


echo Noticias y widgets desactivados.
echo.
pause
exit