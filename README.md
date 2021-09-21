# AMSI Logging Provider

## Overview

The intent of this project is to demonstrate that it is possible to log AMSI participating facilities such as cscript/wscript, powershell, javascript or vbscript through excel, etc.

The AmsiProvider implements the
[IAntimalwareProvider](https://msdn.microsoft.com/en-us/library/windows/desktop/dn889593(v=vs.85).aspx) interface
which receives a stream to be scanned in the form of an IAmsiStream interface.

Note that the provider is loaded as an in-process server, which means that you need to install both 32-bit and 64-bit versions in order to support both 32-bit and 64-bit applications.

## Instructions

* Build the dependent images with packer
* Build the AmsiProvider
* Deploy the dev environment with vagrant
* Register the AmsiProvider and Test

### Building and installing the AMSI provider

1. Load the Project solution.
2. Build the Project.
3. From an elevated command prompt on the *win10* desktop, go to the output directory and type `regsvr32 AmsiProvider.dll`.

If your system has other providers installed, they may take priority over the sample provider. To prevent this from happening (for testing purposes), go to the `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\AMSI\Providers` and `HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\AMSI\Providers` registry keys and temporarily rename the other providers so that the system will use the sample provider.

### Exercising the sample provider

#### Testing PowerShell

Events logged by the sample provider can be captured using ETW tools such as xperf. The log files are generated in ETL format so they can be viewed and processed by the Windows Performance Toolkit (WPT), as well as utilities such as *tracerpt.exe* or *xperf.exe*.

1. From an elevated command prompt, type `xperf.exe -start mySession -f myFile.etl -on 00604c86-2d25-46d6-b814-cd149bfdf0b3` to begin capturing events from the provider used by the sample.
2. From an unelevated command prompt, launch PowerShell with the Bypass execution policy.
The PowerShell program should be the same bitness as the project you built and installed.
   * To run 32-bit PowerShell on a 32-bit system, or 64-bit PowerShell on a 64-bit system: `powershell -ep bypass`
   * To run 32-bit PowerShell on a 64-bit system: `C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell -ep bypass`
3. Run some PowerShell commands. For example, type `calc` to launch calc.
4. Exit PowerShell.
5. From an elevated command prompt, type `xperf.exe -stop mySession` to stop capturing events.
6. View the `myFile.etl` trace graphically in WPA, or generate a text version by typing `tracerpt myFile.etl`.

#### Testing Office

Versions Supported: ? 

### Uninstalling the sample provider

1. From an elevated command prompt, go to the output directory and type `regsvr32 /u AmsiProvider.dll`.
2. If you temporarily renamed conflicting providers when you installed the sample provider, rename the keys back.

### Useful Commands

* Query Running Traces: logman query -ets
* Query Logging Providers: 
  * logman providers
  * wevtutil ep
* Query our Trace: logman query mySession -ets
* Check AMSI specific registry keys
  * Check if Authenticode signing check is disabled, Get-Item HKLM:\Software\Microsoft\AMSI
    * FeatureBits = 0x1 it is disabled
    * FeatureBits = 0x2 it is enabled.
  * List Registered AMSI Providers, Get-ChildItem -Recurse HKLM:\Software\Microsoft\AMSI\Provider

### Useful Tools

* [logman](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/logman)
* [wevtutil](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/wevtutil)
* [WEPExplorer](https://github.com/lallousx86/WinTools/tree/master/WEPExplorer) 

### Sample AMSI Triggers

Create an Excel (Macro Enabled) Worksheet and add the following VBA code.

```vba
Sub GetDomainName()
    DomainName = VBA.Interaction.Environ("UserDomain")
    Debug.Print "Domain: " & DomainName
    UserName = VBA.Interaction.Environ("Username")
    Debug.Print "Username: " & UserName
End Sub
```

## Client Software Requirements

* MS Visual C++ 2015-2019 Redistributable
* Windows Assessment and Deployment Kit 10.1.22000.1
* Windows SDK AddOn 10.1.0.0
* Windows Software Development Kit 10.0.19041.685

## References

* AMSI Explanations
  * [Blackhat Asia 2018, The Rise and Fall of AMSI @Tal_Liberman](https://i.blackhat.com/briefings/asia/2018/asia-18-Tal-Liberman-Documenting-the-Undocumented-The-Rise-and-Fall-of-AMSI.pdf)
  * [Threat Hunting with ETW events and HELK — Part 1: Installing SilkETW](https://medium.com/threat-hunters-forge/threat-hunting-with-etw-events-and-helk-part-1-installing-silketw-6eb74815e4a0)
  * [Windows Defender ATP machine learning and AMSI: Unearthing script-based attacks that ‘live off the land’](https://www.microsoft.com/security/blog/2017/12/04/windows-defender-atp-machine-learning-and-amsi-unearthing-script-based-attacks-that-live-off-the-land/)
  * [Tanium AMSI View](https://community.tanium.com/s/article/Windows-AntiMalware-Scan-Interface)
  * [Argon Systems Explanation](https://argonsys.com/microsoft-cloud/library/office-vba-amsi-parting-the-veil-on-malicious-macros/)
* Amsi Bypass Techniques
  * <https://pentestlaboratories.com/2021/06/01/threat-hunting-amsi-bypasses/>
* [Script to pull amsi events out of trace](https://gist.githubusercontent.com/mattifestation/e179218d88b5f100b0edecdec453d9be/raw/2329bda456b5b8e2f973cc5dc026b6fc221dad79/AMSIScriptContentRetrieval.ps1)
* Microsoft AMSI Documentation
  * [Official MS Docs](https://docs.microsoft.com/en-us/windows/desktop/amsi/antimalware-scan-interface-portal)
  * [Amsi Provider Sample](https://github.com/Microsoft/Windows-classic-samples/tree/main/Samples/AmsiProvider)
