# DistControlUSBHub PowerShell Module

Этот проект представляет собой модуль PowerShell для управления устройством **DistControlUSBHub-lite** через веб-запросы. Модуль позволяет выполнять различные операции, такие как управление питанием USB-портов, настройка сетевых параметров и управление LED-индикаторами.

## Установка

1. Склонируйте репозиторий на свой компьютер:
   ```bash
   git clone https://gitflic.ru/initon/distcontrolusbhub-powershell-module.git
   ```

2. Импортируйте модуль в PowerShell:
   ```powershell
   Import-Module .\DistControlUSBHub.psm1
   ```

## Примеры использования

### Настройка подключения

Перед выполнением команд необходимо задать IP-адрес устройства, имя пользователя и пароль:

```powershell
$ip = "172.16.35.11"
$userName = "admin"
$password = "admin"
```

### Управление LED-индикаторами

- **Отключить светодиоды:**
  ```powershell
  Disable-LEDs -IP $ip -Username $userName -Password $password
  ```

- **Включить светодиоды:**
  ```powershell
  Enable-LEDs -IP $ip -Username $userName -Password $password
  ```

### Управление питанием USB-портов

- **Перезагрузить питание на порту:**
  ```powershell
  Reset-PowerUSBPort -IP $ip -Username $userName -Password $password -NumberPort 1 -Timeout 10
  ```

- **Подать питание на порт:**
  ```powershell
  Enable-PowerUSBPort -IP $ip -Username $userName -Password $password -NumberPort 2
  ```

- **Отключить питание на порту:**
  ```powershell
  Disable-PowerUSBPort -IP $ip -Username $userName -Password $password -NumberPort 3
  ```

### Настройки устройства

- **Установить имя устройства:**
  ```powershell
  Set-NameDevice -IP $ip -Username $userName -Password $password -Hostname "Test HostName"
  ```

- **Установить новый логин для входа:**
  ```powershell
  Set-NewLogin -IP $ip -Username $userName -Password "password" -NewLogin "admin"
  ```

- **Установить новый пароль для входа:**
  ```powershell
  Set-NewPassword -IP $ip -Username $userName -Password "password" -NewPassword "admin"
  ```

### Сетевые настройки

- **Установить новые настройки сети (требуется перезагрузка):**
  ```powershell
  Set-IPSettings -IP $ip -Username $userName -Password $password -NewIP "10.172.17.123" -NewMask "255.255.255.0" -NewIPGateway "10.172.17.1"
  ```

- **Включить DHCP (требуется перезагрузка):**
  ```powershell
  Enable-DHCPonDevice -IP $ip -Username $userName -Password $password
  ```

### Получение информации о устройстве

- **Получить статус USB порта:**
  ```powershell
  $statusPort = Get-StatusUSBPort -IP $ip -Username $userName -Password $password -NumberPort 1
  ```

- **Получить серийный номер устройства:**
  ```powershell
  $serialName = Get-SerialDevice -IP $ip -Username $userName -Password $password
  ```
