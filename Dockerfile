# escape=`

ARG BASE_TAG=latest_1709

FROM mback2k/windows-buildbot-worker:${BASE_TAG}

SHELL ["powershell", "-command"]

RUN Invoke-WebRequest "http://www.7-zip.org/a/7z1604-x64.exe" -OutFile 7z1604-x64.exe; `
    Start-Process -FilePath "C:\7z1604-x64.exe" -ArgumentList /S -NoNewWindow -PassThru -Wait; `
    Remove-Item 7z1604-x64.exe;

RUN Invoke-WebRequest "http://repo.msys2.org/distrib/msys2-x86_64-latest.tar.xz" -OutFile msys2-x86_64-latest.tar.xz; `
    Start-Process -FilePath "C:\Program` Files\7-Zip\7z.exe" -ArgumentList e, msys2-x86_64-latest.tar.xz -NoNewWindow -PassThru -Wait; `
    Start-Process -FilePath "C:\Program` Files\7-Zip\7z.exe" -ArgumentList x, msys2-x86_64-latest.tar, `-oC:\ -NoNewWindow -PassThru -Wait; `
    Remove-Item msys2-x86_64-latest.tar.xz; Remove-Item msys2-x86_64-latest.tar;

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

SHELL ["C:\\msys64\\usr\\bin\\bash.exe", "-l", "-c"]

ENTRYPOINT ["C:\\msys64\\usr\\bin\\bash.exe", "-l"]
