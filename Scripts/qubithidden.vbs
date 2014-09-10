Option Explicit

'Declarations
Dim ObjShell
Dim OWSH
Dim WalletAdr 'Self Explanitory
Dim StrFileName
Dim Filesys
Dim objFSO
Dim ObjFSO2 ' Avoiding the certain redefinition
Dim Appdata2 ' Appdata is s system variable so it doesn't like anything else /sad
Dim strfolderpath2 'Documentation check path
Dim ObjFile 
Dim wshSystemEnv
Dim i ' File check variable
Dim Arch
Dim ArchPath
Dim Windir2
Dim OCLPath 'Where is OpenCL Located?
Dim OCL
Dim R 'Value entered for menu
Dim Q 'Quit variable
Dim R2 ' Second Menu Variable
Dim strMenu
Dim rc
Dim Cuda
Dim MSVCRx86
Dim CudaPath
Dim MSVCRx86path
Dim Electrumpresent
dim objWMIService 
Dim objItem 
Dim colItems 
Dim strComputer
Dim compModel
Dim strKeyPath
Dim strValueName
Dim strValue
Dim oReg
Dim AMD
Dim Threads
Dim CPU
Dim ThreadsPath
Dim CPUPath
Dim CPUMine
dim rc2
dim intanswer
dim objFileToWrite
dim S ' Yet another sleep variable
dim objFileToRead
dim strnumcpu 'number of host threads
dim intnumcpu
dim finalnumcpu
dim hidden
dim hiddenpath
dim qubitpool
dim qubitpath


Set Filesys = CreateObject("Scripting.FileSystemObject") 
Set objFSO = CreateObject("Scripting.FileSystemObject") 
Set objShell = CreateObject("Wscript.Shell")
Set wshSystemEnv = objShell.Environment("SYSTEM")
ThreadsPath = ".\Threads.conf"
CPUPath = ".\CPUMine.conf"
HiddenPath = ".\Hidden.conf"
QubitPath = ".\Qubit.conf"

'Begin Documentation Run Check
Appdata2=objShell.ExpandEnvironmentStrings("%Appdata%")
Strfolderpath2 = Appdata2 & "\Electrum-MYR" 
Set objShell = CreateObject("Wscript.Shell")
 If Not objFSO.FolderExists(strfolderpath2) then
  Electrumpresent =0
  CreateObject("WScript.Shell").Run "http://myriadplatform.org/mining-setup/"
  CreateObject("WScript.Shell").Run "Wallet.exe"
'One time only, Set Threads VAR to 1 less core than host system maximum to try to keep system fluidity

strnumcpu=objShell.ExpandEnvironmentStrings("%NUMBER_OF_PROCESSORS%")
intnumcpu=cint(strnumcpu)
Set objFileToWrite = CreateObject("Scripting.FileSystemObject").OpenTextFile(ThreadsPath,2,true)
finalnumcpu=intnumcpu-1
objFileToWrite.WriteLine(finalnumcpu)
objFileToWrite.Close
  
  
 End If
set objShell = CreateObject("Wscript.Shell")
 If objFSO.FolderExists(strfolderpath2) then
  Electrumpresent =1
End if
'End Documentation Check

'Are we on X86 or X64?
ArchPath= "C:\Program Files (X86)"
If objFSO.FolderExists(ArchPath) then
Arch="X64"
End If

If Not objFSO.FolderExists(ArchPath) then
Arch="X86"
End If

'Open CL Check
Windir2=objShell.ExpandEnvironmentStrings("%WinDir%")
OCLPath= Windir2 & "\System32\OpenCL.DLL"
If objFSO.FileExists(OCLPath) then
OCL=1
End If
If Not objFSO.fileExists(OCLPath) then
OCL=0
End If

'Nvidia Check
Windir2=objShell.ExpandEnvironmentStrings("%WinDir%")
CudaPath= Windir2 & "\System32\NVCuda.DLL"
If objFSO.FileExists(CudaPath) then
Cuda=1
End If
If Not objFSO.fileExists(CudaPath) then
Cuda=0
End If

'Visual Studio 2010 runtime check x86

Windir2=objShell.ExpandEnvironmentStrings("%WinDir%")
MSVCRx86Path= Windir2 & "\System32\MSVCR100.DLL"
If objFSO.FileExists(MSVCRx86path) then
MSVCRx86=1
Else MSVCRx86=0
End If

' AMD or Intel Check
const HKEY_LOCAL_MACHINE = &H80000002
strKeyPath = "SYSTEM\ControlSet001\Services\intelppm"
strValueName = "Start"
strValue = "1"
strComputer = "."
' WMI connection to Root CIM and get the computer type
set objWMIService = GetObject("winmgmts:\\" _
& strComputer & "\root\cimv2")
set colItems = objWMIService.ExecQuery(_
"Select Manufacturer from Win32_Processor")
'Loop through the results and store the type in compModel
for each objItem in colItems
compModel = objItem.Manufacturer
next
'Get a registry object
Set oReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\default:StdRegProv")
'Check the computer type. If the processor is an Intel, then re-enable the driver
if compModel = "GenuineIntel" then
AMD=0
else
AMD=1
end if


'Did we create the folder but not the wallet aka did our setup get borked, WE MAKE DAMN SURE THE WALLET EXISTS
If Not objFSO.fileExists(strfolderpath2 & "\wallets\default_wallet") then
i=0
elseif objFSO.fileExists(strfolderpath2 & "\wallets\default_wallet") then
i=1
end if
If i=0 and Electrumpresent=1 then
CreateObject("WScript.Shell").Run "Wallet.exe"
end if

'Sleep loop
Do until i=1
If Not objFSO.fileExists(strfolderpath2 & "\wallets\default_wallet") then
i=0
elseif objFSO.fileExists(strfolderpath2 & "\wallets\default_wallet") then
i=1
end if
loop

'Parse Wallet with a horrendously coded hack
If i=1 then
StrFileName = Appdata2 & "\Electrum-MYR\wallets\default_wallet"
Set objFile = objFSO.OpenTextFile(StrFileName) 
Set ObjFso2 = CreateObject("Scripting.FileSystemObject")
ObjFile.Skip(19)  
WalletADR = ObjFile.Read(34)
End If

'Read Variables from files
Set objFileToRead = CreateObject("Scripting.FileSystemObject").OpenTextFile(".\CPUMine.conf",1)
Set ObjFso2 = CreateObject("Scripting.FileSystemObject")
CPUMine = objFileToRead.ReadAll()
objFileToRead.Close
Set objFileToRead = Nothing

Set objFileToRead = CreateObject("Scripting.FileSystemObject").OpenTextFile(".\Threads.conf",1)
Set ObjFso2 = CreateObject("Scripting.FileSystemObject")
Threads = objFileToRead.ReadAll()
objFileToRead.Close
Set objFileToRead = Nothing

Set objFileToRead = CreateObject("Scripting.FileSystemObject").OpenTextFile(".\Hidden.conf",1)
Set ObjFso2 = CreateObject("Scripting.FileSystemObject")
Hidden = objFileToRead.ReadAll()
objFileToRead.Close
Set objFileToRead = Nothing

Set objFileToRead = CreateObject("Scripting.FileSystemObject").OpenTextFile(".\Qubit.conf",1)
Set ObjFso2 = CreateObject("Scripting.FileSystemObject")
QubitPool = objFileToRead.ReadAll()
objFileToRead.Close
Set objFileToRead = Nothing

'Qubit Mining - CPU and GPU
If Arch="X86" Then
objShell.CurrentDirectory = ".\Qubit\Qubit32"
end if
If CPUMine=1 and Arch="X86" Then
objshell.run "Quiet.exe" & " " & "QubitCPU32.EXE" & " " & "-a qubit -o" & " " &  QubitPool & " " & "-u" & " " & WalletADR & " " & "-p 912837465" & " " & "--threads" & " " & threads
End If
If Arch="X64" Then
objShell.CurrentDirectory = ".\Qubit\"
End If
If CPUmine=1 and Arch="X64" Then
objshell.run "Quiet.exe" & " " & "QubitCPU64.EXE" & " " & "-a qubit -o" & " " &  QubitPool & " " & "-u" & " " & WalletADR & " " & "-p 912837465" & " " & "--threads" & " " & threads
End If
If OCL=1 and Cuda = 0 Then
objShell.CurrentDirectory = ".\QubitGPU"
objshell.run "Quiet.exe" & " " & "QubitGPU.EXE" & " " & "--kernel qubitcoin --intensity D -o" & " " &  QubitPool & " " & "-u" & " " & WalletADR & " " & "-p 912837465"
End If
If OCL=1 and Cuda = 1 Then 
objShell.CurrentDirectory = ".\QubitGPU"
 objShell.run "Quiet.exe" & " " & "NVGPU.EXE" & " " & "--algo=qubit -o" & " " &  QubitPool & " " & "-u" & " " & WalletADR & " " & "-p 912837465"
End If
If AMD=1 And Arch="X64"  And CpuMine=1 Then
objShell.CurrentDirectory = ".\Qubit\"
objshell.run "Quiet.exe" & " " & "AMDCPU64.EXE" & " " & "-a qubit -o" & " " &  QubitPool & " " & "-u" & " " & WalletADR & " " & "-p 912837465" & " " & "--threads" & " " & threads 
End IF
If AMD=1 And Arch="X86"Then
Wscript.echo ("Unable to do qubit CPU mining on AMD cpu's with a 32 bit OS at this time. Please upgrade to 64 bit and try again")
End If

