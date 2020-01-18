# escape=`

ARG BASE_TAG=latest_1803

FROM mback2k/windows-buildbot-tools:${BASE_TAG}

ARG MSYS2_X86_64="http://repo.msys2.org/distrib/x86_64/msys2-base-x86_64-20190524.tar.xz"

RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; `
    Invoke-WebRequest $env:MSYS2_X86_64 -OutFile "C:\Windows\Temp\msys2-x86_64.tar.xz"; `
    Start-Process -FilePath "C:\Program` Files\7-Zip\7z.exe" -ArgumentList e, "C:\Windows\Temp\msys2-x86_64.tar.xz", `-oC:\Windows\Temp\ -NoNewWindow -PassThru -Wait; `
    Start-Process -FilePath "C:\Program` Files\7-Zip\7z.exe" -ArgumentList x, "C:\Windows\Temp\msys2-x86_64.tar", `-oC:\ -NoNewWindow -PassThru -Wait; `
    Remove-Item @('C:\Windows\Temp\*', 'C:\Users\*\Appdata\Local\Temp\*') -Force -Recurse;

RUN Write-Host 'Updating MSYSTEM and MSYSCON ...'; `
    [Environment]::SetEnvironmentVariable('MSYSTEM', 'MSYS2', [EnvironmentVariableTarget]::Machine); `
    [Environment]::SetEnvironmentVariable('MSYSCON', 'defterm', [EnvironmentVariableTarget]::Machine);

RUN C:\msys64\usr\bin\bash.exe -l -c 'exit 0'; `
    C:\msys64\usr\bin\bash.exe -l -c 'echo "Now installing MSYS2..."'; `
    C:\msys64\usr\bin\bash.exe -l -c 'pacman -Syuu --needed --noconfirm --noprogressbar'; `
    C:\msys64\usr\bin\bash.exe -l -c 'pacman -Syu  --needed --noconfirm --noprogressbar'; `
    C:\msys64\usr\bin\bash.exe -l -c 'pacman -Su   --needed --noconfirm --noprogressbar'; `
    C:\msys64\usr\bin\bash.exe -l -c 'pacman -Scc --noconfirm'; `
    C:\msys64\usr\bin\bash.exe -l -c 'echo "Successfully installed MSYS2"'; `
    C:\msys64\usr\bin\bash.exe -l -c 'exit 0'; `
    Get-Process | Where-Object {$_.Path -Like 'C:\msys64\*'} | Stop-Process -Force -PassThru | Wait-Process; `
    Get-Process @('bash', 'dirmngr', 'gpg-agent', 'pacman') -ErrorAction SilentlyContinue | Stop-Process -Force -PassThru | Wait-Process; `
    Remove-Item @('C:\$Recycle.Bin\*') -Force -Recurse -ErrorAction Continue; `
    Write-Host 'Cleared Recycle Bin ...';

RUN C:\msys64\usr\bin\bash.exe -l -c 'exit 0'; `
    C:\msys64\usr\bin\bash.exe -l -c 'echo "Now installing MinGW-w64..."'; `
    C:\msys64\usr\bin\bash.exe -l -c 'pacman -S --needed --noconfirm --noprogressbar mingw-w64-i686-toolchain mingw-w64-x86_64-toolchain'; `
    C:\msys64\usr\bin\bash.exe -l -c 'pacman -S --needed --noconfirm --noprogressbar automake autoconf make intltool libtool zip unzip'; `
    C:\msys64\usr\bin\bash.exe -l -c 'pacman -Scc --noconfirm'; `
    C:\msys64\usr\bin\bash.exe -l -c 'echo "Successfully installed MinGW-w64"'; `
    C:\msys64\usr\bin\bash.exe -l -c 'exit 0'; `
    Get-Process | Where-Object {$_.Path -Like 'C:\msys64\*'} | Stop-Process -Force -PassThru | Wait-Process; `
    Get-Process @('bash', 'dirmngr', 'gpg-agent', 'pacman') -ErrorAction SilentlyContinue | Stop-Process -Force -PassThru | Wait-Process; `
    Remove-Item @('C:\$Recycle.Bin\*') -Force -Recurse -ErrorAction Continue; `
    Write-Host 'Cleared Recycle Bin ...';
