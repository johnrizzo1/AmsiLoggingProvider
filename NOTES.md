# AMSI Logging Provider

## Commands

* wevtutil
* Windows Performance Analyzer (WPA)

```powershell

logman query providers
logman query providers Microsoft-Windows-Kernel-Process

# FeatureBits 
#   0x1 authenticode signing check is disabled
#   0x2 it is enabled.
Get-Item HKLM:\Software\Microsoft\AMSI
Get-ChildItem -Recurse HKLM:\Software\Microsoft\AMSI\Providers

move '.\{2781761E-28E0-4109-99FE-B9D127C57AFE}\' 'blah'
move 'blah' '.\{2781761E-28E0-4109-99FE-B9D127C57AFE}\'

regsvr32 AmsiProvider.dll

xperf.exe -start mySession -f myFile.etl -on 00604c86-2d25-46d6-b814-cd149bfdf0b3
logman -ets
logman query mySession -ets
powershell -ep bypass
xperf.exe -stop mySession

regsvr32 /u AmsiProvider.dll

wevtutil el
wevtutil 

```

The Windows Events Providers Explorer app is a convenient way to look through the various providers.  wevtutil or logman are good cli alternatives.



Plan security settings for VBA macros in Office 2016
    https://docs.microsoft.com/en-us/DeployOffice/security/plan-security-settings-for-vba-macros-in-office?redirectedfrom=MSDN#blockvba

New feature in Office 2016 can block macros and help prevent infection
    https://www.microsoft.com/security/blog/2016/03/22/new-feature-in-office-2016-can-block-macros-and-help-prevent-infection/

Set the Macro Runtime Scan Scope
    https://admx.help/?Category=Office2016&Policy=office16.Office.Microsoft.Policies.Windows::L_MacroRuntimeScanScope
