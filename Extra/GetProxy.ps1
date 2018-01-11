@{
    ProxyHost = [System.Net.WebProxy]::GetDefaultProxy().Address.Host
    ProxyPort = [System.Net.WebProxy]::GetDefaultProxy().Address.Port
}