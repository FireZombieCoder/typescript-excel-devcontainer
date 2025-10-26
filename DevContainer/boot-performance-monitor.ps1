# Windows 11 Boot Performance Monitor
# Continuous monitoring and analysis of boot performance

param(
    [switch]$StartMonitoring,
    [switch]$StopMonitoring,
    [switch]$ShowReport,
    [int]$MonitoringInterval = 60,
    [string]$LogPath = ".\boot-performance-logs"
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

function Get-BootTime {
    try {
        $bootEvent = Get-WinEvent -FilterHashtable @{LogName='System'; ID=1073741824} | 
            Select-Object -First 1
        return $bootEvent.TimeCreated
    } catch {
        return $null
    }
}

function Get-SystemUptime {
    try {
        $os = Get-CimInstance Win32_OperatingSystem
        return (Get-Date) - $os.LastBootUpTime
    } catch {
        return $null
    }
}

function Get-StartupApplications {
    try {
        return Get-CimInstance Win32_StartupCommand | 
            Select-Object Name, Command, Location, User | 
            Sort-Object Name
    } catch {
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
                    Timestamp = Get-Date
                }
            } else {
                $impactData += [PSCustomObject]@{
                    Name = $app.Name
                    Command = $app.Command
                    Location = $app.Location
                    MemoryUsage = 0
                    CPUUsage = 0
                    Status = "Not Running"
                    Timestamp = Get-Date
                }
            }
        }
        
        return $impactData | Sort-Object MemoryUsage -Descending
    } catch {
        return @()
    }
}

function Get-SystemPerformance {
    try {
        $os = Get-CimInstance Win32_OperatingSystem
        $memory = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
        $processes = Get-Process | Measure-Object
        $cpu = Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average
        
        return [PSCustomObject]@{
            Timestamp = Get-Date
            TotalMemory = [math]::Round($memory.Sum / 1GB, 2)
            FreeMemory = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
            UsedMemory = [math]::Round(($memory.Sum - $os.FreePhysicalMemory) / 1GB, 2)
            MemoryUsagePercent = [math]::Round((($memory.Sum - $os.FreePhysicalMemory) / $memory.Sum) * 100, 2)
            RunningProcesses = $processes.Count
            CPUUsage = [math]::Round($cpu.Average, 2)
            Uptime = (Get-Date) - $os.LastBootUpTime
        }
    } catch {
        return $null
    }
}

function Get-BootPerformanceMetrics {
    try {
        $bootTime = Get-BootTime
        $uptime = Get-SystemUptime
        $startupApps = Get-StartupApplications
        $startupImpact = Get-StartupImpact
        $systemPerf = Get-SystemPerformance
        
        return [PSCustomObject]@{
            Timestamp = Get-Date
            BootTime = $bootTime
            Uptime = $uptime
            StartupAppCount = $startupApps.Count
            RunningStartupApps = ($startupImpact | Where-Object { $_.Status -eq "Running" }).Count
            TotalMemoryUsage = ($startupImpact | Measure-Object -Property MemoryUsage -Sum).Sum
            HighMemoryApps = ($startupImpact | Where-Object { $_.MemoryUsage -gt 100 }).Count
            SystemPerformance = $systemPerf
            StartupImpact = $startupImpact
        }
    } catch {
        Write-ColorOutput "Error collecting boot performance metrics: $($_.Exception.Message)" $Red
        return $null
    }
}

function Save-PerformanceData {
    param([object]$Data, [string]$LogPath)
    
    try {
        if (-not (Test-Path $LogPath)) {
            New-Item -ItemType Directory -Path $LogPath -Force | Out-Null
        }
        
        $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
        $logFile = Join-Path $LogPath "boot-performance_$timestamp.json"
        
        $Data | ConvertTo-Json -Depth 5 | Out-File -FilePath $logFile -Encoding UTF8
        
        # Also save to CSV for easy analysis
        $csvFile = Join-Path $LogPath "boot-performance_$timestamp.csv"
        $Data.StartupImpact | Export-Csv -Path $csvFile -NoTypeInformation
        
        return $logFile
    } catch {
        Write-ColorOutput "Error saving performance data: $($_.Exception.Message)" $Red
        return $null
    }
}

function Start-PerformanceMonitoring {
    param([int]$Interval, [string]$LogPath)
    
    Write-ColorOutput "Starting boot performance monitoring..." $Green
    Write-ColorOutput "Monitoring interval: $Interval seconds" $Cyan
    Write-ColorOutput "Log path: $LogPath" $Cyan
    Write-ColorOutput "Press Ctrl+C to stop monitoring" $Yellow
    
    $monitoringCount = 0
    
    try {
        while ($true) {
            $monitoringCount++
            Write-ColorOutput "`n--- Monitoring Cycle $monitoringCount ---" $Blue
            
            $performanceData = Get-BootPerformanceMetrics
            if ($performanceData) {
                $logFile = Save-PerformanceData -Data $performanceData -LogPath $LogPath
                if ($logFile) {
                    Write-ColorOutput "Data saved to: $logFile" $Green
                }
                
                # Display current status
                Write-ColorOutput "Current Status:" $Cyan
                Write-ColorOutput "  Startup Applications: $($performanceData.StartupAppCount)" $Cyan
                Write-ColorOutput "  Running Startup Apps: $($performanceData.RunningStartupApps)" $Cyan
                Write-ColorOutput "  Total Memory Usage: $($performanceData.TotalMemoryUsage) MB" $Cyan
                Write-ColorOutput "  High Memory Apps: $($performanceData.HighMemoryApps)" $Cyan
                Write-ColorOutput "  System Uptime: $($performanceData.Uptime.Days) days, $($performanceData.Uptime.Hours) hours" $Cyan
                
                if ($performanceData.SystemPerformance) {
                    Write-ColorOutput "  Memory Usage: $($performanceData.SystemPerformance.MemoryUsagePercent)%" $Cyan
                    Write-ColorOutput "  CPU Usage: $($performanceData.SystemPerformance.CPUUsage)%" $Cyan
                }
            }
            
            Start-Sleep -Seconds $Interval
        }
    } catch {
        Write-ColorOutput "`nMonitoring stopped: $($_.Exception.Message)" $Red
    }
}

function Show-PerformanceReport {
    param([string]$LogPath)
    
    Write-ColorOutput "Generating boot performance report..." $Green
    
    if (-not (Test-Path $LogPath)) {
        Write-ColorOutput "No log files found in: $LogPath" $Red
        return
    }
    
    $logFiles = Get-ChildItem -Path $LogPath -Filter "boot-performance_*.json" | Sort-Object LastWriteTime -Descending
    
    if ($logFiles.Count -eq 0) {
        Write-ColorOutput "No performance log files found." $Red
        return
    }
    
    Write-ColorOutput "Found $($logFiles.Count) log files" $Cyan
    
    # Analyze latest data
    $latestLog = $logFiles[0]
    $latestData = Get-Content -Path $latestLog.FullName | ConvertFrom-Json
    
    Write-ColorOutput "`n=== BOOT PERFORMANCE REPORT ===" $Green
    Write-ColorOutput "Report Generated: $(Get-Date)" $Cyan
    Write-ColorOutput "Latest Data: $($latestLog.LastWriteTime)" $Cyan
    
    Write-ColorOutput "`n--- System Overview ---" $Yellow
    Write-ColorOutput "Startup Applications: $($latestData.StartupAppCount)" $Cyan
    Write-ColorOutput "Running Startup Apps: $($latestData.RunningStartupApps)" $Cyan
    Write-ColorOutput "Total Memory Usage: $($latestData.TotalMemoryUsage) MB" $Cyan
    Write-ColorOutput "High Memory Apps: $($latestData.HighMemoryApps)" $Cyan
    
    if ($latestData.SystemPerformance) {
        Write-ColorOutput "`n--- System Performance ---" $Yellow
        Write-ColorOutput "Total Memory: $($latestData.SystemPerformance.TotalMemory) GB" $Cyan
        Write-ColorOutput "Used Memory: $($latestData.SystemPerformance.UsedMemory) GB" $Cyan
        Write-ColorOutput "Memory Usage: $($latestData.SystemPerformance.MemoryUsagePercent)%" $Cyan
        Write-ColorOutput "CPU Usage: $($latestData.SystemPerformance.CPUUsage)%" $Cyan
        Write-ColorOutput "Running Processes: $($latestData.SystemPerformance.RunningProcesses)" $Cyan
        Write-ColorOutput "System Uptime: $($latestData.SystemPerformance.Uptime.Days) days, $($latestData.SystemPerformance.Uptime.Hours) hours" $Cyan
    }
    
    # Top memory consuming startup applications
    Write-ColorOutput "`n--- Top Memory Consuming Startup Applications ---" $Yellow
    $topMemoryApps = $latestData.StartupImpact | 
        Where-Object { $_.MemoryUsage -gt 0 } | 
        Sort-Object MemoryUsage -Descending | 
        Select-Object -First 10
    
    if ($topMemoryApps) {
        $topMemoryApps | Format-Table -AutoSize
    } else {
        Write-ColorOutput "No startup applications currently using memory." $Cyan
    }
    
    # Recommendations
    Write-ColorOutput "`n--- Recommendations ---" $Yellow
    $recommendations = @()
    
    if ($latestData.StartupAppCount -gt 20) {
        $recommendations += "High number of startup applications ($($latestData.StartupAppCount)). Consider disabling unnecessary ones."
    }
    
    if ($latestData.HighMemoryApps -gt 5) {
        $recommendations += "Many high memory usage startup applications ($($latestData.HighMemoryApps)). Review and disable if not needed."
    }
    
    if ($latestData.TotalMemoryUsage -gt 1000) {
        $recommendations += "High total memory usage from startup applications ($($latestData.TotalMemoryUsage) MB). Consider optimization."
    }
    
    if ($latestData.SystemPerformance -and $latestData.SystemPerformance.MemoryUsagePercent -gt 80) {
        $recommendations += "High system memory usage ($($latestData.SystemPerformance.MemoryUsagePercent)%). Consider closing unnecessary applications."
    }
    
    if ($recommendations.Count -eq 0) {
        $recommendations += "System performance looks good! Continue monitoring for any changes."
    }
    
    foreach ($recommendation in $recommendations) {
        Write-ColorOutput "  • $recommendation" $Cyan
    }
    
    # Historical analysis
    if ($logFiles.Count -gt 1) {
        Write-ColorOutput "`n--- Historical Analysis ---" $Yellow
        Write-ColorOutput "Analyzing $($logFiles.Count) log files for trends..." $Cyan
        
        $historicalData = @()
        foreach ($logFile in $logFiles | Select-Object -First 10) {
            try {
                $data = Get-Content -Path $logFile.FullName | ConvertFrom-Json
                $historicalData += [PSCustomObject]@{
                    Timestamp = $data.Timestamp
                    StartupAppCount = $data.StartupAppCount
                    RunningStartupApps = $data.RunningStartupApps
                    TotalMemoryUsage = $data.TotalMemoryUsage
                    HighMemoryApps = $data.HighMemoryApps
                }
            } catch {
                Write-ColorOutput "Error reading log file: $($logFile.Name)" $Red
            }
        }
        
        if ($historicalData.Count -gt 1) {
            $avgStartupApps = [math]::Round(($historicalData | Measure-Object -Property StartupAppCount -Average).Average, 2)
            $avgRunningApps = [math]::Round(($historicalData | Measure-Object -Property RunningStartupApps -Average).Average, 2)
            $avgMemoryUsage = [math]::Round(($historicalData | Measure-Object -Property TotalMemoryUsage -Average).Average, 2)
            
            Write-ColorOutput "Average Startup Applications: $avgStartupApps" $Cyan
            Write-ColorOutput "Average Running Startup Apps: $avgRunningApps" $Cyan
            Write-ColorOutput "Average Memory Usage: $avgMemoryUsage MB" $Cyan
        }
    }
    
    Write-ColorOutput "`nReport complete! Check individual log files for detailed data." $Green
}

# Main execution
Write-ColorOutput "Windows 11 Boot Performance Monitor" $Green
Write-ColorOutput "===================================" $Green

if ($StartMonitoring) {
    Start-PerformanceMonitoring -Interval $MonitoringInterval -LogPath $LogPath
} elseif ($ShowReport) {
    Show-PerformanceReport -LogPath $LogPath
} else {
    Write-ColorOutput "`nUsage:" $Yellow
    Write-ColorOutput "  -StartMonitoring    Start continuous monitoring" $Cyan
    Write-ColorOutput "  -StopMonitoring     Stop monitoring (Ctrl+C)" $Cyan
    Write-ColorOutput "  -ShowReport         Generate performance report" $Cyan
    Write-ColorOutput "  -MonitoringInterval Set monitoring interval in seconds (default: 60)" $Cyan
    Write-ColorOutput "  -LogPath            Set log file path (default: .\boot-performance-logs)" $Cyan
    Write-ColorOutput "`nExamples:" $Yellow
    Write-ColorOutput "  .\boot-performance-monitor.ps1 -StartMonitoring" $Cyan
    Write-ColorOutput "  .\boot-performance-monitor.ps1 -StartMonitoring -MonitoringInterval 30" $Cyan
    Write-ColorOutput "  .\boot-performance-monitor.ps1 -ShowReport" $Cyan
    Write-ColorOutput "  .\boot-performance-monitor.ps1 -ShowReport -LogPath C:\Logs" $Cyan
}
