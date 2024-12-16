$env = 'dev'
$domain = 'api.sof.net'
$CnPrefix = 'portal','proxy','management','api'

#Create the root certificate for the self-signed certificate

$param1 = @{
  Subject = "CN=$env.$domain, C=AU"
  KeyLength = 2048
  KeyAlgorithm = 'RSA'
  HashAlgorithm = 'SHA256'
  KeyExportPolicy = 'Exportable'
  NotAfter = (Get-Date).AddYears(5)
  CertStoreLocation = 'C:\temp'
  KeyUsage = 'CertSign','CRLSign'
}

$rootCA = New-SelfSignedCertificate @param1

# Grab the thumbprint of the root certificate
$thumb = $rootCA.Thumbprint
$root = Get-Item -Path Cert:\LocalMachine\My\$($thumb)

#This is a path you want to download the .cer of the root certificate.cert
$path = ".\rootca-$env.cer"

# Export the root certificate in a Base64 encoded X.509 to the path created above
$base64certificate = @"
-----BEGIN CERTIFICATE-----
$([Convert]::ToBase64String($root.Export('Cert'), [System.Base64FormattingOptions]::InsertLineBreaks)))
-----END CERTIFICATE-----
"@

Set-Content -Path $path -Value $base64certificate

# Import the root certificate of the self-signed certificate to the local machine trusted root store

Import-Certificate -CertStoreLocation 'Cert:\CurrentUser\My' -FilePath ".\rootca-$env.cer"

function Generate-Cert {

  param (
    [String[]]$cnPrefix
  )

  foreach ($cn in $cnPrefix) {
    $param2 = @{
      DnsName = "*.$domain"
      Subject = "$cn.$domain"
      Signer = $rootCA
      KeyLength = 2048
      KeyAlgorithm = 'RSA'
      HashAlgorithm = 'SHA256'
      KeyExportPolicy = 'Exportable'
      CertStoreLocation = 'Cert:\LocalMachine\My'
      NotAfter = (Get-date).AddYears(2)
    }
    $selfCert = New-SelfSignedCertificate @param2

    # Export the certificate in .pfx format for the application gateway listener and ASE ILB Cert.
    Export-PfxCertificate -Cert $selfCert -FilePath ".\$cn-$env-cert.pfx" -Password (ConvertTo-SecureString -AsPlainText 'password1' -Force)`
  }

}

Generate-Cert -cnPrefix $CnPrefix