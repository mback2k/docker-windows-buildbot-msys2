# escape=`

ARG BASE_TAG=latest_1803

FROM mback2k/windows-buildbot-tools:${BASE_TAG}

SHELL ["powershell", "-command"]

ARG MSYS2_X86_64="http://repo.msys2.org/distrib/msys2-x86_64-latest.tar.xz"
ADD ${MSYS2_X86_64} C:\Windows\Temp\msys2-x86_64-latest.tar.xz

RUN Start-Process -FilePath "C:\Program` Files\7-Zip\7z.exe" -ArgumentList e, "C:\Windows\Temp\msys2-x86_64-latest.tar.xz", `-oC:\Windows\Temp\ -NoNewWindow -PassThru -Wait; `
    Start-Process -FilePath "C:\Program` Files\7-Zip\7z.exe" -ArgumentList x, "C:\Windows\Temp\msys2-x86_64-latest.tar", `-oC:\ -NoNewWindow -PassThru -Wait; `
    Remove-Item @('C:\Windows\Temp\*', 'C:\Users\*\Appdata\Local\Temp\*') -Force -Recurse;

RUN Write-Host 'Updating MSYSTEM and MSYSCON ...'; `
    [Environment]::SetEnvironmentVariable('MSYSTEM', 'MSYS2', [EnvironmentVariableTarget]::Machine); `
    [Environment]::SetEnvironmentVariable('MSYSCON', 'defterm', [EnvironmentVariableTarget]::Machine);

# For some reason bash.exe has to be called first since we are not building interactive.
RUN C:\msys64\usr\bin\bash.exe -l -c 'exit 0'; `
    C:\msys64\usr\bin\bash.exe -l -c 'echo "Now installing MSYS2..."'; `
    C:\msys64\usr\bin\bash.exe -l -c 'pacman -Syuu --needed --noconfirm --noprogressbar --ask=20'; `
    C:\msys64\usr\bin\bash.exe -l -c 'pacman -Syu  --needed --noconfirm --noprogressbar --ask=20'; `
    C:\msys64\usr\bin\bash.exe -l -c 'pacman -Su   --needed --noconfirm --noprogressbar --ask=20'; `
    C:\msys64\usr\bin\bash.exe -l -c 'echo "Successfully installed MSYS2"';

RUN C:\msys64\usr\bin\bash.exe -l -c 'exit 0'; `
    C:\msys64\usr\bin\bash.exe -l -c 'echo "Now installing MinGW-w64..."'; `
    C:\msys64\usr\bin\bash.exe -l -c 'pacman -S --needed --noconfirm --noprogressbar mingw-w64-i686-toolchain mingw-w64-x86_64-toolchain'; `
    C:\msys64\usr\bin\bash.exe -l -c 'pacman -S --needed --noconfirm --noprogressbar automake autoconf make intltool libtool zip unzip'; `
    C:\msys64\usr\bin\bash.exe -l -c 'echo "Successfully installed MinGW-w64"';
