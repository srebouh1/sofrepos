Enable-WindowsOptionalFeature -Online -FeatureName ServicesForNFS-ClientOnly

Enable-WindowsOptionalFeature -Online -FeatureName ClientForNFS-Infrastructure

New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\ClientForNFS\CurrentVersion\Default -Name AnonymousUid -PropertyType DWord -Value 0
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\ClientForNFS\CurrentVersion\Default -Name AnonymousGid -PropertyType DWord -Value 0