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

    Invoke-PostRequest -url "http://${IP}/GP_click?potr_sw_${NumberPort}=0" -Username $Username -Password $Password
    Start-Sleep -Seconds $Timeout
    Invoke-PostRequest -Url "http://${IP}/GP_click?potr_sw_${NumberPort}=1" -Username $Username -Password $Password
}

function Get-NamePorts
{
    param (
        [string]$IP,
        [string]$Username,
        [string]$Password
    )

    $response_html = Invoke-PostRequest -Url "http://${IP}/" -Username $Username -Password $Password

    # Список названий портов
    $items = @()

     for ($i = 1; $i -lt 5; $i++)
     {
        
        if ($response_html -match "id='namePort$i'.*?value='([^']*)'")
        {
            $items += "Перезагрузить порт: " + $matches[1]
        }
     }
     return $items
}

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


### Параметры для подключения к устройству ###
$IP = "192.168.100.200"
$User = "admin"
$Password = "admin"
$Timeout = 5
##############################################


while ($true) {
    # Загружаем имена портов
    $name_ports = Get-NamePorts -IP $IP -Username $User -Password $Password
    $name_ports += "Перезагрузить все порты"
    $name_ports += "Статус"
    $name_ports += "Закрыть приложение"

    Write-Host "`nФункции:"
    for ($i = 0; $i -lt $name_ports.Count; $i++) 
    {
        Write-Host "$($i+1). $($name_ports[$i])"
    }

    $input = Read-Host "Выберите номер пункта: (1-$($name_ports.Count))"

    if ($input -notmatch '^[1-7]$')
    {
        Write-Host "Некорректный ввод. Попробуйте снова."
        continue
    }

    if ($input -match '^[1-4]$')
    {
        # Получаем номер порта
        $Index = [int]$input
        Write-Host "Перезагружаем питание USB порта №$Index"
        Write-Host "Ждем $Timeout секунд..."
        # Перезагружаем питание порта
        Reset-PowerUSBPort -IP $IP -Username $User -Password $Password -NumberPort $Index -Timeout $Timeout
        Write-Host "Обработка команды завершена!"
    }

    if ($input -eq '5') 
    {
        Write-Host "Перезагружаем питание всех портов"
        Write-Host "Ждем $($Timeout*4) секунд..."
        for ($i = 1; $i -lt 5; $i++) 
        {
            Reset-PowerUSBPort -IP $IP -Username $User -Password $Password -NumberPort $i -Timeout $Timeout
            Start-Sleep -Seconds 1
        }
        Write-Host "Обработка команды завершена!"
    }

    if ($input -eq '6') {
        Write-Host "Статус портов:"
        for ($i = 1; $i -lt 5; $i++) 
        {
            $status = Get-StatusUSBPort -IP $IP -Username $User -Password $Password -NumberPort $i
            Write-Host "$i. $($status)"
        }
        continue
    }

    if ($input -eq '7') 
    {
        Write-Host "Выход из программы."
        break
    }

    Start-Sleep -Seconds 3
    Clear-Host
}
