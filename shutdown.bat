@echo off
set /p time=minutes:10
set /a time=%time%*60
shutdown /a
shutdown /s /f /t %time%