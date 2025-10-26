# Windows 11 Boot Performance Optimizer
# Run as Administrator for full functionality

param(
    [switch]$AnalyzeOnly,
    [switch]$DisableGaming,
    [switch]$DisableMedia,
    [switch]$DisableCloud,
    [switch]$DisableCommunication,
    [switch]$All,
    [string]$OutputPath = ".\boot-optimization-results"
)

# Colors for output
$Red = "Red"
$Green = "Green"
$Yellow = "Yellow"
$Cyan = "Cyan"
$Blue = "Blue"

function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Get-BootTime {
    try {
        $bootEvent = Get-WinEvent -FilterHashtable @{LogName='System'; ID=1073741824} | 
            Select-Object -First 1
        return $bootEvent.TimeCreated
    } catch {
        Write-ColorOutput "Could not retrieve boot time information." $Yellow
        return $null
    }
}

function Get-StartupApplications {
    try {
        $startupApps = Get-CimInstance Win32_StartupCommand | 
            Select-Object Name, Command, Location, User | 
            Sort-Object Name
        return $startupApps
    } catch {
        Write-ColorOutput "Could not retrieve startup applications." $Red
        return @()
    }
}

function Get-StartupImpact {
    try {
        $startupApps = Get-StartupApplications
        $impactData = @()
        
        foreach ($app in $startupApps) {
            $process = Get-Process -Name $app.Name -ErrorAction SilentlyContinue
            if ($process) {
                $impactData += [PSCustomObject]@{
                    Name = $app.Name
                    Command = $app.Command
                    Location = $app.Location
                    MemoryUsage = [math]::Round($process.WorkingSet64 / 1MB, 2)
                    CPUUsage = $process.CPU
                    Status = "Running"
                }
            } else {
                $impactData += [PSCustomObject]@{
                    Name = $app.Name
                    Command = $app.Command
                    Location = $app.Location
                    MemoryUsage = 0
                    CPUUsage = 0
                    Status = "Not Running"
                }
            }
        }
        
        return $impactData | Sort-Object MemoryUsage -Descending
    } catch {
        Write-ColorOutput "Could not analyze startup impact." $Red
        return @()
    }
}

function Disable-StartupApplication {
    param([string]$AppName, [string]$Location)
    
    try {
        if ($Location -like "*HKEY_CURRENT_USER*") {
            $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
        } elseif ($Location -like "*HKEY_LOCAL_MACHINE*") {
            $regPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
        } else {
            Write-ColorOutput "Unknown registry location for $AppName" $Yellow
            return $false
        }
        
        $regEntry = Get-ItemProperty -Path $regPath -Name $AppName -ErrorAction SilentlyContinue
        if ($regEntry) {
            Remove-ItemProperty -Path $regPath -Name $AppName -Force
            Write-ColorOutput "Disabled startup application: $AppName" $Green
            return $true
        } else {
            Write-ColorOutput "Startup application not found in registry: $AppName" $Yellow
            return $false
        }
    } catch {
        Write-ColorOutput "Error disabling $AppName : $($_.Exception.Message)" $Red
        return $false
    }
}

function Get-SystemPerformance {
    try {
        $os = Get-CimInstance Win32_OperatingSystem
        $memory = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
        $processes = Get-Process | Measure-Object
        
        return [PSCustomObject]@{
            TotalMemory = [math]::Round($memory.Sum / 1GB, 2)
            FreeMemory = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
            UsedMemory = [math]::Round(($memory.Sum - $os.FreePhysicalMemory) / 1GB, 2)
            MemoryUsagePercent = [math]::Round((($memory.Sum - $os.FreePhysicalMemory) / $memory.Sum) * 100, 2)
            RunningProcesses = $processes.Count
            Uptime = (Get-Date) - $os.LastBootUpTime
        }
    } catch {
        Write-ColorOutput "Could not retrieve system performance data." $Red
        return $null
    }
}

function Optimize-WindowsServices {
    Write-ColorOutput "`nOptimizing Windows services..." $Cyan
    
    $servicesToDisable = @(
        @{Name="Fax"; Description="Fax Service"},
        @{Name="XblAuthManager"; Description="Xbox Live Auth Manager"},
        @{Name="XblGameSave"; Description="Xbox Live Game Save"},
        @{Name="XboxGipSvc"; Description="Xbox Accessory Management Service"},
        @{Name="XboxNetApiSvc"; Description="Xbox Live Networking Service"},
        @{Name="RemoteRegistry"; Description="Remote Registry"},
        @{Name="Telnet"; Description="Telnet"},
        @{Name="TlntSvr"; Description="Telnet Server"},
        @{Name="WSearch"; Description="Windows Search"}
    )
    
    $disabledServices = @()
    
    foreach ($service in $servicesToDisable) {
        try {
            $svc = Get-Service -Name $service.Name -ErrorAction SilentlyContinue
            if ($svc -and $svc.Status -eq "Running") {
                if (-not $AnalyzeOnly) {
                    Set-Service -Name $service.Name -StartupType Disabled -ErrorAction SilentlyContinue
                    Stop-Service -Name $service.Name -Force -ErrorAction SilentlyContinue
                }
                $disabledServices += $service
                Write-ColorOutput "Service '$($service.Name)' - $($service.Description)" $Yellow
            }
        } catch {
            Write-ColorOutput "Could not modify service: $($service.Name)" $Red
        }
    }
    
    return $disabledServices
}

function Optimize-StartupPrograms {
    param([string]$Category)
    
    $programsToDisable = @{}
    
    if ($Category -eq "Gaming" -or $All) {
        $programsToDisable["Gaming"] = @(
            "Steam", "Epic Games Launcher", "Origin", "Battle.net", "Discord",
            "Riot Games", "Ubisoft Connect", "EA Desktop", "GOG Galaxy"
        )
    }
    
    if ($Category -eq "Media" -or $All) {
        $programsToDisable["Media"] = @(
            "Spotify", "iTunes", "VLC", "Winamp", "MediaMonkey",
            "Adobe Creative Cloud", "Adobe Acrobat", "Adobe Reader"
        )
    }
    
    if ($Category -eq "Cloud" -or $All) {
        $programsToDisable["Cloud"] = @(
            "Dropbox", "OneDrive", "Google Drive", "iCloud", "Box Sync",
            "SugarSync", "SpiderOak", "Mega Sync"
        )
    }
    
    if ($Category -eq "Communication" -or $All) {
        $programsToDisable["Communication"] = @(
            "Skype", "Zoom", "Microsoft Teams", "Slack", "Discord",
            "WhatsApp", "Telegram", "Signal"
        )
    }
    
    $disabledCount = 0
    
    foreach ($category in $programsToDisable.Keys) {
        Write-ColorOutput "`nProcessing $category applications..." $Cyan
        
        foreach ($program in $programsToDisable[$category]) {
            $startupApps = Get-StartupApplications
            $foundApp = $startupApps | Where-Object { $_.Name -like "*$program*" }
            
            if ($foundApp) {
                foreach ($app in $foundApp) {
                    if (-not $AnalyzeOnly) {
                        $result = Disable-StartupApplication -AppName $app.Name -Location $app.Location
                        if ($result) { $disabledCount++ }
                    } else {
                        Write-ColorOutput "Would disable: $($app.Name)" $Yellow
                        $disabledCount++
                    }
                }
            }
        }
    }
    
    return $disabledCount
}

function Generate-Report {
    param([string]$OutputPath)
    
    $report = @{
        Timestamp = Get-Date
        BootTime = Get-BootTime
        SystemPerformance = Get-SystemPerformance
        StartupApplications = Get-StartupApplications
        StartupImpact = Get-StartupImpact
        Recommendations = @()
    }
    
    # Generate recommendations
    $startupCount = $report.StartupApplications.Count
    if ($startupCount -gt 20) {
        $report.Recommendations += "High number of startup applications ($startupCount). Consider disabling unnecessary ones."
    }
    
    $highMemoryApps = $report.StartupImpact | Where-Object { $_.MemoryUsage -gt 100 }
    if ($highMemoryApps) {
        $report.Recommendations += "High memory usage startup applications detected. Review and disable if not needed."
    }
    
    $gamingApps = $report.StartupApplications | Where-Object { 
        $_.Name -match "Steam|Epic|Origin|Battle|Discord|Riot|Ubisoft" 
    }
    if ($gamingApps) {
        $report.Recommendations += "Gaming applications found in startup. Consider disabling if not needed immediately."
    }
    
    # Save report
    if (-not (Test-Path $OutputPath)) {
        New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    }
    
    $reportPath = Join-Path $OutputPath "boot-optimization-report.json"
    $report | ConvertTo-Json -Depth 5 | Out-File -FilePath $reportPath -Encoding UTF8
    
    $csvPath = Join-Path $OutputPath "startup-applications.csv"
    $report.StartupApplications | Export-Csv -Path $csvPath -NoTypeInformation
    
    $impactPath = Join-Path $OutputPath "startup-impact.csv"
    $report.StartupImpact | Export-Csv -Path $impactPath -NoTypeInformation
    
    Write-ColorOutput "`nReport saved to: $OutputPath" $Green
    Write-ColorOutput "  - boot-optimization-report.json (Full report)" $Cyan
    Write-ColorOutput "  - startup-applications.csv (Startup apps list)" $Cyan
    Write-ColorOutput "  - startup-impact.csv (Memory/CPU usage)" $Cyan
    
    return $report
}

# Main execution
Write-ColorOutput "Windows 11 Boot Performance Optimizer" $Green
Write-ColorOutput "=====================================" $Green

# Check if running as administrator
if (-not (Test-Administrator)) {
    Write-ColorOutput "`nWARNING: This script requires Administrator privileges for full functionality." $Yellow
    Write-ColorOutput "Some features may not work properly without elevated permissions." $Yellow
    Write-ColorOutput "`nTo run as Administrator:" $Cyan
    Write-ColorOutput "1. Right-click PowerShell" $Cyan
    Write-ColorOutput "2. Select 'Run as Administrator'" $Cyan
    Write-ColorOutput "3. Run this script again" $Cyan
}

# Get current system information
Write-ColorOutput "`n1. Analyzing current system..." $Cyan
$bootTime = Get-BootTime
if ($bootTime) {
    Write-ColorOutput "Last boot time: $bootTime" $Green
}

$systemPerf = Get-SystemPerformance
if ($systemPerf) {
    Write-ColorOutput "System Performance:" $Green
    Write-ColorOutput "  Total Memory: $($systemPerf.TotalMemory) GB" $Cyan
    Write-ColorOutput "  Used Memory: $($systemPerf.UsedMemory) GB ($($systemPerf.MemoryUsagePercent)%)" $Cyan
    Write-ColorOutput "  Running Processes: $($systemPerf.RunningProcesses)" $Cyan
    Write-ColorOutput "  System Uptime: $($systemPerf.Uptime.Days) days, $($systemPerf.Uptime.Hours) hours" $Cyan
}

# Analyze startup applications
Write-ColorOutput "`n2. Analyzing startup applications..." $Cyan
$startupApps = Get-StartupApplications
Write-ColorOutput "Found $($startupApps.Count) startup applications" $Green

$startupImpact = Get-StartupImpact
$highMemoryApps = $startupImpact | Where-Object { $_.MemoryUsage -gt 50 }
if ($highMemoryApps) {
    Write-ColorOutput "`nHigh memory usage startup applications:" $Yellow
    $highMemoryApps | Format-Table -AutoSize
}

# Optimize based on parameters
$totalDisabled = 0

if ($DisableGaming -or $All) {
    Write-ColorOutput "`n3. Disabling gaming applications..." $Cyan
    $disabled = Optimize-StartupPrograms -Category "Gaming"
    $totalDisabled += $disabled
    Write-ColorOutput "Disabled $disabled gaming applications" $Green
}

if ($DisableMedia -or $All) {
    Write-ColorOutput "`n4. Disabling media applications..." $Cyan
    $disabled = Optimize-StartupPrograms -Category "Media"
    $totalDisabled += $disabled
    Write-ColorOutput "Disabled $disabled media applications" $Green
}

if ($DisableCloud -or $All) {
    Write-ColorOutput "`n5. Disabling cloud storage applications..." $Cyan
    $disabled = Optimize-StartupPrograms -Category "Cloud"
    $totalDisabled += $disabled
    Write-ColorOutput "Disabled $disabled cloud applications" $Green
}

if ($DisableCommunication -or $All) {
    Write-ColorOutput "`n6. Disabling communication applications..." $Cyan
    $disabled = Optimize-StartupPrograms -Category "Communication"
    $totalDisabled += $disabled
    Write-ColorOutput "Disabled $disabled communication applications" $Green
}

# Optimize Windows services
Write-ColorOutput "`n7. Optimizing Windows services..." $Cyan
$disabledServices = Optimize-WindowsServices
Write-ColorOutput "Found $($disabledServices.Count) services that could be disabled" $Yellow

# Generate report
Write-ColorOutput "`n8. Generating optimization report..." $Cyan
$report = Generate-Report -OutputPath $OutputPath

# Display summary
Write-ColorOutput "`n" + "="*50 $Green
Write-ColorOutput "OPTIMIZATION SUMMARY" $Green
Write-ColorOutput "="*50 $Green

if ($AnalyzeOnly) {
    Write-ColorOutput "ANALYSIS MODE - No changes were made" $Yellow
} else {
    Write-ColorOutput "Total applications disabled: $totalDisabled" $Green
    Write-ColorOutput "Services reviewed: $($disabledServices.Count)" $Green
}

Write-ColorOutput "`nRecommendations:" $Cyan
foreach ($recommendation in $report.Recommendations) {
    Write-ColorOutput "  • $recommendation" $Yellow
}

Write-ColorOutput "`nNext steps:" $Cyan
Write-ColorOutput "  1. Restart your computer to see the improvements" $Cyan
Write-ColorOutput "  2. Monitor boot time and system performance" $Cyan
Write-ColorOutput "  3. Re-enable any essential applications if needed" $Cyan
Write-ColorOutput "  4. Review the generated reports for detailed analysis" $Cyan

Write-ColorOutput "`nBoot optimization complete!" $Green
