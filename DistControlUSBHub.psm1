# Отправка Post запроса на устройств
function Invoke-PostRequest
{
    param (
        [string]$Url,
        [string]$Username,
        [string]$Password
    )

    # Создание строки с учетными данными и кодирование в Base64
    $pair = "${Username}:${Password}"
    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($pair))

    $headers = @{
    "Accept-Encoding" = "gzip, deflate"
    "Authorization"   = "Basic $base64AuthInfo"
    }

    # Выполнение POST-запроса
    try 
    {
        $response = Invoke-WebRequest -Uri $Url -Method Post -Headers $headers
        $bytes = $response.RawContentStream.ToArray()
        $content = [System.Text.Encoding]::UTF8.GetString($bytes) 
        return $content
    } 
    catch
    {
        Write-Error "Ошибка при выполнении запроса: $_"
    }
}

# Подать питание на порт
function Enable-PowerUSBPort
{
    param (
        [string]$IP,
        [string]$Username,
        [string]$Password,
        [int]$NumberPort
    )
    Invoke-PostRequest -url "http://${IP}/GP_click?potr_sw_$NumberPort=1" -Username $Username -Password $Password
}

# Отключить питание на порту
function Disable-PowerUSBPort
{
    param (
        [string]$IP,
        [string]$Username,
        [string]$Password,
        [int]$NumberPort
    )
    Write-Output "http://${IP}/GP_click?potr_sw_$NumberPort=0"
    Invoke-PostRequest -Url "http://${IP}/GP_click?potr_sw_$NumberPort=0" -Username $Username -Password $Password
}

# Перезагрузить питание на порту
function Reset-PowerUSBPort
{
    param (
        [string]$IP,
        [string]$Username,
        [string]$Password,
        [int]$NumberPort,
        [int]$Timeout=10
    )

    Invoke-PostRequest -Url "http://${IP}/GP_click?potr_sw_$NumberPort=0" -Username $Username -Password $Password
    Start-Sleep -Seconds $Timeout
    Invoke-PostRequest -url "http://${IP}/GP_click?potr_sw_$NumberPort=1" -Username $Username -Password $Password
}

# Включить светодиоды
function Enable-LEDs
{
    param (
        [string]$IP,
        [string]$Username,
        [string]$Password
    )

    Invoke-PostRequest -Url "http://${IP}/GP_click?allLedOff=1" -Username $Username -Password $Password
}

# Отключить светодиоды
function Disable-LEDs
{
    param (
        [string]$IP,
        [string]$Username,
        [string]$Password
    )

    Invoke-PostRequest -Url "http://${IP}/GP_click?allLedOff=0" -Username $Username -Password $Password
}

# Установить имя устройства
function Set-NameDevice
{
        param (
        [string]$IP,
        [string]$Username,
        [string]$Password,
        [string]$Hostname
    )

    $encodedHostname = [System.Net.WebUtility]::UrlEncode($Hostname)
    Invoke-PostRequest -Url "http://${IP}/GP_click?hostName=$encodedHostname" -Username $Username -Password $Password
}

# Установить новый Логин для входа
function Set-NewLogin
{
    param (
        [string]$IP,
        [string]$Username,
        [string]$Password,
        [string]$NewLogin
    )

    $encodedNewLogin = [System.Net.WebUtility]::UrlEncode($NewLogin)
    Invoke-PostRequest -Url "http://${IP}/GP_click?loginGui=$encodedNewLogin" -Username $Username -Password $Password
}

# Установить новый Пароль для входа
function Set-NewPassword
{
        param (
        [string]$IP,
        [string]$Username,
        [string]$Password,
        [string]$NewPassword
    )

    $encodedNewPassword = [System.Net.WebUtility]::UrlEncode($NewPassword)
    Invoke-PostRequest -Url "http://${IP}/GP_click?passGui=$encodedNewPassword" -Username $Username -Password $Password
}

# Перезагрузить устройство
function Restart-Device
{
        param (
        [string]$IP,
        [string]$Username,
        [string]$Password
    )

    Invoke-PostRequest -Url "http://${IP}/GP_click?restart=" -Username $Username -Password $Password
}

# Установить новые настройки сети
function Set-IPSettings
{
    param (
        [string]$IP,
        [string]$Username,
        [string]$Password,
        [string]$NewIP,
        [string]$NewMask,
        [string]$NewIPGateway
    )
    Invoke-PostRequest -Url "http://${IP}/GP_click?ipLan=$NewIP" -Username $Username -Password $Password
    Invoke-PostRequest -Url "http://${IP}/GP_click?maskLan=$NewMask" -Username $Username -Password $Password
    Invoke-PostRequest -Url "http://${IP}/GP_click?gatewayLan=$NewIPGateway" -Username $Username -Password $Password
}


# Включить SNMP
function Enable-SNMPonDevice
{
        param (
        [string]$IP,
        [string]$Username,
        [string]$Password
    )

    Invoke-PostRequest -Url "http://${IP}/GP_click?enableSNMP=1" -Username $Username -Password $Password
}

# Отключить SNMP
function Disable-SNMPonDevice
{
        param (
        [string]$IP,
        [string]$Username,
        [string]$Password
    )

    Invoke-PostRequest -Url "http://${IP}/GP_click?enableSNMP=0" -Username $Username -Password $Password
}

# Установить новое имя SNMP сообщества
function Set-NewSNMPCommunity
{
        param (
        [string]$IP,
        [string]$Username,
        [string]$Password,
        [string]$NewSNMPCommunity
    )

    $encodedNewSNMPCommunity = [System.Net.WebUtility]::UrlEncode($NewSNMPCommunity)
    Invoke-PostRequest -Url "http://${IP}/GP_click?community=$encodedNewSNMPCommunity" -Username $Username -Password $Password
}

# Получить статус USB порта
function Get-StatusUSBPort
{
    param (
        [string]$IP,
        [string]$Username,
        [string]$Password,
        [int]$NumberPort
    )

    $response = Invoke-PostRequest -url "http://${IP}/GP_update?plain${NumberPort}=" -Username $Username -Password $Password
    return $response
}

# Получить дату
function Get-DateDevice
{
    param (
        [string]$IP,
        [string]$Username,
        [string]$Password
    )

    $response = Invoke-PostRequest -url "http://${IP}/GP_update?date=" -Username $Username -Password $Password
    return $response
}

# Получить время
function Get-TimeDevice
{
    param (
        [string]$IP,
        [string]$Username,
        [string]$Password
    )

    $response = Invoke-PostRequest -url "http://${IP}/GP_update?time=" -Username $Username -Password $Password
    return $response
}

# Задать имя порту
function Set-NameUSBPort
{
    param (
        [string]$IP,
        [string]$Username,
        [string]$Password,
        [int]$NumberPort,
        [string]$NewName
    )

    $encodedNewName = [System.Net.WebUtility]::UrlEncode($NewName)
    Invoke-PostRequest -url "http://${IP}/GP_click?namePort${NumberPort}=$encodedNewName" -Username $Username -Password $Password
}

# Получить серийный номер
function Get-SerialDevice
{
    param (
        [string]$IP,
        [string]$Username,
        [string]$Password
    )

    $response_html = Invoke-PostRequest -Url "http://${IP}/" -Username $Username -Password $Password

    if ($response_html -match "id='serial'.*?value='([^']*)'")
    {
        $serialNumber = $matches[1]
        Write-Output "Серийный номер: $serialNumber"
    }
    else
    {
        Write-Output "Элемент не найден."
    }
}

# Получить версию прошивки
function Get-VersionDevice
{
    param (
        [string]$IP,
        [string]$Username,
        [string]$Password
    )

    $response_html = Invoke-PostRequest -Url "http://${IP}/" -Username $Username -Password $Password

    if ($response_html -match "id='version'.*?value='([^']*)'")
    {
        $Version = $matches[1]
        Write-Output "Версия: $Version"
    }
    else
    {
        Write-Output "Элемент не найден."
    }
}

# Получить имя порта
function Get-NamePort
{
    param (
        [string]$IP,
        [string]$Username,
        [string]$Password,
        [string]$NumberPort
    )

    $response_html = Invoke-PostRequest -Url "http://${IP}/" -Username $Username -Password $Password

    if ($response_html -match "id='namePort$NumberPort'.*?value='([^']*)'")
    {
        $Version = $matches[1]
        Write-Output "Имя порта: $Version"
    }
    else
    {
        Write-Output "Элемент не найден."
    }
}


# Включить DHCP
function Enable-DHCPonDevice
{
        param (
        [string]$IP,
        [string]$Username,
        [string]$Password
    )

    Invoke-PostRequest -Url "http://${IP}/GP_click?enableDhcpLan=1" -Username $Username -Password $Password
}

# Отключить DHCP
function Enable-DHCPonDevice
{
        param (
        [string]$IP,
        [string]$Username,
        [string]$Password
    )

    Invoke-PostRequest -Url "http://${IP}/GP_click?enableDhcpLan=0" -Username $Username -Password $Password
}

Export-ModuleMember -Function Enable-PowerUSBPort, Get-StatusUSBPort, Disable-PowerUSBPort, Reset-PowerUSBPort, Enable-LEDs, `
                              Disable-LEDs, Set-NameDevice, Set-NewLogin, Set-NewPassword, Restart-Device, `
                              Set-IPSettings, Enable-SNMPonDevice, Disable-SNMPonDevice, Set-NewSNMPCommunity, `
                              Set-NameUSBPort, Get-SerialDevice, Get-VersionDevice, Get-DateDevice, Get-DTimeDevice, `
                              Get-NamePort, Enable-DHCPonDevice, Enable-DHCPonDevice
