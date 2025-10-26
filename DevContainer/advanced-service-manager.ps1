# Advanced Windows Service Manager Console Application
# Provides detailed service management with safety checks and impact analysis

param(
    [switch]$ListAll,
    [switch]$ListSafeToDisable,
    [switch]$ListEssential,
    [switch]$AnalyzeImpact,
    [switch]$OptimizePerformance,
    [switch]$RestoreServices,
    [switch]$MonitorServices,
    [string]$ServiceName,
    [string]$Action,
    [switch]$Help
)

# Colors for console output
$Red = "Red"
$Green = "Green"
$Yellow = "Yellow"
$Cyan = "Cyan"
$Blue = "Blue"
$Magenta = "Magenta"

function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Write-Header {
    param([string]$Title)
    Write-ColorOutput "`n" + "="*70 $Cyan
    Write-ColorOutput " $Title" $Cyan
    Write-ColorOutput "="*70 $Cyan
}

function Write-Section {
    param([string]$Title)
    Write-ColorOutput "`n--- $Title ---" $Yellow
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Get-ServiceDatabase {
    try {
        $jsonPath = ".\windows-services-database.json"
        if (Test-Path $jsonPath) {
            $jsonContent = Get-Content -Path $jsonPath -Raw
            return $jsonContent | ConvertFrom-Json
        } else {
            Write-ColorOutput "Service database not found. Creating default database..." $Yellow
            return Get-DefaultServiceDatabase
        }
    } catch {
        Write-ColorOutput "Error loading service database: $($_.Exception.Message)" $Red
        return Get-DefaultServiceDatabase
    }
}

function Get-DefaultServiceDatabase {
    return @{
        services = @{
            safeToDisable = @(
                @{name="Fax"; displayName="Fax Service"; category="Communication"; impact="None"},
                @{name="XblAuthManager"; displayName="Xbox Live Auth Manager"; category="Gaming"; impact="Low"},
                @{name="XblGameSave"; displayName="Xbox Live Game Save"; category="Gaming"; impact="Low"},
                @{name="XboxGipSvc"; displayName="Xbox Accessory Management Service"; category="Gaming"; impact="Low"},
                @{name="XboxNetApiSvc"; displayName="Xbox Live Networking Service"; category="Gaming"; impact="Low"},
                @{name="RemoteRegistry"; displayName="Remote Registry"; category="System"; impact="None"},
                @{name="Telnet"; displayName="Telnet"; category="Communication"; impact="None"},
                @{name="TlntSvr"; displayName="Telnet Server"; category="Communication"; impact="None"},
                @{name="WSearch"; displayName="Windows Search"; category="System"; impact="High"},
                @{name="TabletInputService"; displayName="Touch Keyboard and Handwriting Panel Service"; category="Input"; impact="Low"}
            )
            essential = @(
                @{name="AudioSrv"; displayName="Windows Audio"; category="Hardware"; impact="Critical"},
                @{name="BITS"; displayName="Background Intelligent Transfer Service"; category="System"; impact="High"},
                @{name="CryptSvc"; displayName="Cryptographic Services"; category="Security"; impact="Critical"},
                @{name="DcomLaunch"; displayName="DCOM Server Process Launcher"; category="System"; impact="Critical"},
                @{name="Dhcp"; displayName="DHCP Client"; category="Network"; impact="High"},
                @{name="Dnscache"; displayName="DNS Client"; category="Network"; impact="High"},
                @{name="EventLog"; displayName="Windows Event Log"; category="System"; impact="High"},
                @{name="PlugPlay"; displayName="Plug and Play"; category="Hardware"; impact="Critical"},
                @{name="Power"; displayName="Power"; category="System"; impact="Critical"},
                @{name="RpcSs"; displayName="Remote Procedure Call (RPC)"; category="System"; impact="Critical"}
            )
        }
    }
}

function Get-ServiceDetails {
    param([string]$ServiceName)
    
    try {
        $service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
        if ($service) {
            $process = Get-Process -Name $ServiceName -ErrorAction SilentlyContinue
            $memoryUsage = if ($process) { [math]::Round($process.WorkingSet64 / 1MB, 2) } else { 0 }
            
            return [PSCustomObject]@{
                Name = $service.Name
                DisplayName = $service.DisplayName
                Status = $service.Status
                StartType = $service.StartType
                CanStop = $service.CanStop
                CanPauseAndContinue = $service.CanPauseAndContinue
                MemoryUsage = $memoryUsage
                CPUUsage = if ($process) { $process.CPU } else { 0 }
                Description = $service.Description
            }
        } else {
            return $null
        }
    } catch {
        Write-ColorOutput "Error getting service details: $($_.Exception.Message)" $Red
        return $null
    }
}

function Get-ServiceImpact {
    param([string]$ServiceName)
    
    $service = Get-ServiceDetails -ServiceName $ServiceName
    if (-not $service) {
        return $null
    }
    
    $impact = "Low"
    $memoryImpact = "Low"
    $cpuImpact = "Low"
    
    # Determine impact based on memory usage
    if ($service.MemoryUsage -gt 100) {
        $memoryImpact = "High"
        $impact = "High"
    } elseif ($service.MemoryUsage -gt 50) {
        $memoryImpact = "Medium"
        $impact = "Medium"
    }
    
    # Determine impact based on CPU usage
    if ($service.CPUUsage -gt 10) {
        $cpuImpact = "High"
        $impact = "High"
    } elseif ($service.CPUUsage -gt 5) {
        $cpuImpact = "Medium"
        if ($impact -eq "Low") { $impact = "Medium" }
    }
    
    # Determine impact based on service type
    if ($service.StartType -eq "Automatic" -and $service.Status -eq "Running") {
        if ($impact -eq "Low") { $impact = "Medium" }
    }
    
    return [PSCustomObject]@{
        ServiceName = $ServiceName
        OverallImpact = $impact
        MemoryImpact = $memoryImpact
        CPUImpact = $cpuImpact
        MemoryUsage = $service.MemoryUsage
        CPUUsage = $service.CPUUsage
        Status = $service.Status
        StartType = $service.StartType
    }
}

function Show-ServiceList {
    param([string]$Category = "All")
    
    Write-Header "Windows Services Analysis"
    
    $database = Get-ServiceDatabase
    $allServices = @()
    
    # Get all running services
    $runningServices = Get-Service | Where-Object { $_.Status -eq "Running" }
    
    foreach ($service in $runningServices) {
        $details = Get-ServiceDetails -ServiceName $service.Name
        if ($details) {
            $impact = Get-ServiceImpact -ServiceName $service.Name
            $allServices += [PSCustomObject]@{
                Name = $service.Name
                DisplayName = $service.DisplayName
                Status = $service.Status
                StartType = $service.StartType
                MemoryUsage = $details.MemoryUsage
                CPUUsage = $details.CPUUsage
                Impact = $impact.OverallImpact
                Category = "Unknown"
            }
        }
    }
    
    # Categorize services
    foreach ($service in $allServices) {
        $safeToDisable = $database.services.safeToDisable | Where-Object { $_.name -eq $service.Name }
        $essential = $database.services.essential | Where-Object { $_.name -eq $service.Name }
        
        if ($safeToDisable) {
            $service.Category = "Safe to Disable"
        } elseif ($essential) {
            $service.Category = "Essential"
        } else {
            $service.Category = "Unknown"
        }
    }
    
    # Filter by category
    if ($Category -ne "All") {
        $allServices = $allServices | Where-Object { $_.Category -eq $Category }
    }
    
    # Sort by impact and memory usage
    $allServices = $allServices | Sort-Object @{Expression={$_.Impact}; Descending=$true}, @{Expression={$_.MemoryUsage}; Descending=$true}
    
    Write-ColorOutput "`nFound $($allServices.Count) services in category: $Category" $Cyan
    
    if ($allServices.Count -gt 0) {
        $allServices | Format-Table -AutoSize
    } else {
        Write-ColorOutput "No services found in the specified category." $Yellow
    }
}

function Show-SafeToDisableServices {
    Write-Header "Services Safe to Disable"
    
    $database = Get-ServiceDatabase
    $safeServices = @()
    
    foreach ($serviceInfo in $database.services.safeToDisable) {
        $service = Get-ServiceDetails -ServiceName $serviceInfo.name
        if ($service) {
            $impact = Get-ServiceImpact -ServiceName $serviceInfo.name
            $safeServices += [PSCustomObject]@{
                Name = $service.Name
                DisplayName = $service.DisplayName
                Description = $service.Description
                Status = $service.Status
                StartType = $service.StartType
                MemoryUsage = $service.MemoryUsage
                CPUUsage = $service.CPUUsage
                Impact = $impact.OverallImpact
                Category = $serviceInfo.category
                Recommendation = "Safe to disable"
            }
        }
    }
    
    if ($safeServices.Count -gt 0) {
        Write-ColorOutput "`nFound $($safeServices.Count) services that are safe to disable:" $Cyan
        $safeServices | Format-Table -AutoSize
    } else {
        Write-ColorOutput "No safe-to-disable services found." $Yellow
    }
}

function Show-EssentialServices {
    Write-Header "Essential Services (Never Disable)"
    
    $database = Get-ServiceDatabase
    $essentialServices = @()
    
    foreach ($serviceInfo in $database.services.essential) {
        $service = Get-ServiceDetails -ServiceName $serviceInfo.name
        if ($service) {
            $impact = Get-ServiceImpact -ServiceName $serviceInfo.name
            $essentialServices += [PSCustomObject]@{
                Name = $service.Name
                DisplayName = $service.DisplayName
                Description = $service.Description
                Status = $service.Status
                StartType = $service.StartType
                MemoryUsage = $service.MemoryUsage
                CPUUsage = $service.CPUUsage
                Impact = $impact.OverallImpact
                Category = $serviceInfo.category
                Recommendation = "Keep enabled"
            }
        }
    }
    
    if ($essentialServices.Count -gt 0) {
        Write-ColorOutput "`nFound $($essentialServices.Count) essential services:" $Cyan
        $essentialServices | Format-Table -AutoSize
    } else {
        Write-ColorOutput "No essential services found." $Yellow
    }
}

function Analyze-ServiceImpact {
    Write-Header "Service Impact Analysis"
    
    $database = Get-ServiceDatabase
    $highImpactServices = @()
    $mediumImpactServices = @()
    $lowImpactServices = @()
    
    # Analyze all running services
    $runningServices = Get-Service | Where-Object { $_.Status -eq "Running" }
    
    foreach ($service in $runningServices) {
        $impact = Get-ServiceImpact -ServiceName $service.Name
        if ($impact) {
            $serviceInfo = [PSCustomObject]@{
                Name = $service.Name
                DisplayName = $service.DisplayName
                Status = $service.Status
                StartType = $service.StartType
                MemoryUsage = $impact.MemoryUsage
                CPUUsage = $impact.CPUUsage
                OverallImpact = $impact.OverallImpact
                MemoryImpact = $impact.MemoryImpact
                CPUImpact = $impact.CPUImpact
            }
            
            switch ($impact.OverallImpact) {
                "High" { $highImpactServices += $serviceInfo }
                "Medium" { $mediumImpactServices += $serviceInfo }
                "Low" { $lowImpactServices += $serviceInfo }
            }
        }
    }
    
    Write-ColorOutput "`nHigh Impact Services ($($highImpactServices.Count)):" $Red
    if ($highImpactServices.Count -gt 0) {
        $highImpactServices | Sort-Object MemoryUsage -Descending | Format-Table -AutoSize
    } else {
        Write-ColorOutput "None found." $Yellow
    }
    
    Write-ColorOutput "`nMedium Impact Services ($($mediumImpactServices.Count)):" $Yellow
    if ($mediumImpactServices.Count -gt 0) {
        $mediumImpactServices | Sort-Object MemoryUsage -Descending | Format-Table -AutoSize
    } else {
        Write-ColorOutput "None found." $Yellow
    }
    
    Write-ColorOutput "`nLow Impact Services ($($lowImpactServices.Count)):" $Green
    if ($lowImpactServices.Count -gt 0) {
        $lowImpactServices | Sort-Object MemoryUsage -Descending | Format-Table -AutoSize
    } else {
        Write-ColorOutput "None found." $Yellow
    }
    
    # Summary
    $totalMemory = ($highImpactServices + $mediumImpactServices + $lowImpactServices | Measure-Object -Property MemoryUsage -Sum).Sum
    $totalCPU = ($highImpactServices + $mediumImpactServices + $lowImpactServices | Measure-Object -Property CPUUsage -Sum).Sum
    
    Write-ColorOutput "`nSummary:" $Cyan
    Write-ColorOutput "Total Memory Usage: $([math]::Round($totalMemory, 2)) MB" $Cyan
    Write-ColorOutput "Total CPU Usage: $([math]::Round($totalCPU, 2))" $Cyan
    Write-ColorOutput "High Impact Services: $($highImpactServices.Count)" $Red
    Write-ColorOutput "Medium Impact Services: $($mediumImpactServices.Count)" $Yellow
    Write-ColorOutput "Low Impact Services: $($lowImpactServices.Count)" $Green
}

function Optimize-ServicesForPerformance {
    Write-Header "Service Performance Optimization"
    
    if (-not (Test-Administrator)) {
        Write-ColorOutput "Administrator privileges required for service optimization." $Red
        Write-ColorOutput "Please run as Administrator." $Yellow
        return
    }
    
    $database = Get-ServiceDatabase
    $optimizedCount = 0
    $skippedCount = 0
    
    Write-ColorOutput "`nOptimizing services for maximum performance..." $Cyan
    
    foreach ($serviceInfo in $database.services.safeToDisable) {
        $service = Get-ServiceDetails -ServiceName $serviceInfo.name
        if ($service -and $service.Status -eq "Running") {
            Write-ColorOutput "`nOptimizing: $($service.DisplayName)" $Cyan
            
            try {
                # Stop the service
                if ($service.CanStop) {
                    Stop-Service -Name $service.Name -Force -ErrorAction Stop
                    Write-ColorOutput "  ✓ Service stopped" $Green
                }
                
                # Set startup type to disabled
                Set-Service -Name $service.Name -StartupType Disabled -ErrorAction Stop
                Write-ColorOutput "  ✓ Startup type set to Disabled" $Green
                
                $optimizedCount++
                Write-ColorOutput "  ✓ Service optimized successfully" $Green
                
            } catch {
                Write-ColorOutput "  ✗ Error optimizing service: $($_.Exception.Message)" $Red
                $skippedCount++
            }
        } else {
            Write-ColorOutput "Skipping: $($serviceInfo.displayName) (not running)" $Yellow
            $skippedCount++
        }
    }
    
    Write-ColorOutput "`nOptimization complete!" $Green
    Write-ColorOutput "Services optimized: $optimizedCount" $Green
    Write-ColorOutput "Services skipped: $skippedCount" $Yellow
    Write-ColorOutput "`nRestart recommended for full effect." $Cyan
}

function Restore-ServicesToDefault {
    Write-Header "Restoring Services to Default"
    
    if (-not (Test-Administrator)) {
        Write-ColorOutput "Administrator privileges required for service restoration." $Red
        Write-ColorOutput "Please run as Administrator." $Yellow
        return
    }
    
    $database = Get-ServiceDatabase
    $restoredCount = 0
    
    Write-ColorOutput "`nRestoring services to default settings..." $Cyan
    
    foreach ($serviceInfo in $database.services.safeToDisable) {
        $service = Get-ServiceDetails -ServiceName $serviceInfo.name
        if ($service) {
            Write-ColorOutput "`nRestoring: $($service.DisplayName)" $Cyan
            
            try {
                # Set startup type to manual
                Set-Service -Name $service.Name -StartupType Manual -ErrorAction Stop
                Write-ColorOutput "  ✓ Startup type set to Manual" $Green
                
                $restoredCount++
                Write-ColorOutput "  ✓ Service restored successfully" $Green
                
            } catch {
                Write-ColorOutput "  ✗ Error restoring service: $($_.Exception.Message)" $Red
            }
        }
    }
    
    Write-ColorOutput "`nRestoration complete!" $Green
    Write-ColorOutput "Services restored: $restoredCount" $Green
    Write-ColorOutput "`nRestart recommended for full effect." $Cyan
}

function Monitor-Services {
    Write-Header "Service Performance Monitor"
    
    Write-ColorOutput "Monitoring service performance... (Press Ctrl+C to stop)" $Cyan
    
    try {
        while ($true) {
            Clear-Host
            Write-Header "Service Performance Monitor"
            
            $runningServices = Get-Service | Where-Object { $_.Status -eq "Running" }
            $totalMemory = 0
            $totalCPU = 0
            $highImpactCount = 0
            
            foreach ($service in $runningServices) {
                $impact = Get-ServiceImpact -ServiceName $service.Name
                if ($impact) {
                    $totalMemory += $impact.MemoryUsage
                    $totalCPU += $impact.CPUUsage
                    if ($impact.OverallImpact -eq "High") {
                        $highImpactCount++
                    }
                }
            }
            
            Write-ColorOutput "`nSystem Overview:" $Cyan
            Write-ColorOutput "Running Services: $($runningServices.Count)" $Cyan
            Write-ColorOutput "Total Memory Usage: $([math]::Round($totalMemory, 2)) MB" $Cyan
            Write-ColorOutput "Total CPU Usage: $([math]::Round($totalCPU, 2))" $Cyan
            Write-ColorOutput "High Impact Services: $highImpactCount" $Red
            
            # Show top 5 memory consuming services
            $topServices = $runningServices | ForEach-Object {
                $impact = Get-ServiceImpact -ServiceName $_.Name
                if ($impact) {
                    [PSCustomObject]@{
                        Name = $_.Name
                        DisplayName = $_.DisplayName
                        MemoryUsage = $impact.MemoryUsage
                        CPUUsage = $impact.CPUUsage
                        Impact = $impact.OverallImpact
                    }
                }
            } | Sort-Object MemoryUsage -Descending | Select-Object -First 5
            
            if ($topServices) {
                Write-ColorOutput "`nTop 5 Memory Consuming Services:" $Yellow
                $topServices | Format-Table -AutoSize
            }
            
            Start-Sleep -Seconds 10
        }
    } catch {
        Write-ColorOutput "`nMonitoring stopped." $Yellow
    }
}

function Show-Help {
    Write-Header "Advanced Windows Service Manager - Help"
    
    Write-ColorOutput "`nUSAGE:" $Yellow
    Write-ColorOutput "  .\advanced-service-manager.ps1 [OPTIONS]" $Cyan
    
    Write-ColorOutput "`nOPTIONS:" $Yellow
    Write-ColorOutput "  -ListAll              List all running services with impact analysis" $Cyan
    Write-ColorOutput "  -ListSafeToDisable    List services that are safe to disable" $Cyan
    Write-ColorOutput "  -ListEssential        List essential services (never disable)" $Cyan
    Write-ColorOutput "  -AnalyzeImpact        Analyze service performance impact" $Cyan
    Write-ColorOutput "  -OptimizePerformance  Optimize services for maximum performance" $Cyan
    Write-ColorOutput "  -RestoreServices      Restore services to default settings" $Cyan
    Write-ColorOutput "  -MonitorServices      Monitor service performance in real-time" $Cyan
    Write-ColorOutput "  -Help                 Show this help message" $Cyan
    
    Write-ColorOutput "`nEXAMPLES:" $Yellow
    Write-ColorOutput "  .\advanced-service-manager.ps1 -ListAll" $Cyan
    Write-ColorOutput "  .\advanced-service-manager.ps1 -AnalyzeImpact" $Cyan
    Write-ColorOutput "  .\advanced-service-manager.ps1 -OptimizePerformance" $Cyan
    Write-ColorOutput "  .\advanced-service-manager.ps1 -MonitorServices" $Cyan
    
    Write-ColorOutput "`nNOTES:" $Yellow
    Write-ColorOutput "  • Service optimization requires Administrator privileges" $Cyan
    Write-ColorOutput "  • All changes are reversible using -RestoreServices" $Cyan
    Write-ColorOutput "  • Restart recommended after optimization for full effect" $Cyan
    Write-ColorOutput "  • Monitor services to track performance improvements" $Cyan
}

# Main execution
if ($Help) {
    Show-Help
} elseif ($ListAll) {
    Show-ServiceList -Category "All"
} elseif ($ListSafeToDisable) {
    Show-SafeToDisableServices
} elseif ($ListEssential) {
    Show-EssentialServices
} elseif ($AnalyzeImpact) {
    Analyze-ServiceImpact
} elseif ($OptimizePerformance) {
    Optimize-ServicesForPerformance
} elseif ($RestoreServices) {
    Restore-ServicesToDefault
} elseif ($MonitorServices) {
    Monitor-Services
} else {
    # Interactive mode
    Write-Header "Advanced Windows Service Manager"
    
    Write-ColorOutput "`nSelect an option:" $Yellow
    Write-ColorOutput "1. List all services with impact analysis" $Cyan
    Write-ColorOutput "2. List services safe to disable" $Cyan
    Write-ColorOutput "3. List essential services" $Cyan
    Write-ColorOutput "4. Analyze service performance impact" $Cyan
    Write-ColorOutput "5. Optimize services for performance (requires admin)" $Cyan
    Write-ColorOutput "6. Restore services to default (requires admin)" $Cyan
    Write-ColorOutput "7. Monitor service performance" $Cyan
    Write-ColorOutput "8. Show help" $Cyan
    Write-ColorOutput "9. Exit" $Cyan
    
    $choice = Read-Host "`nEnter your choice (1-9)"
    
    switch ($choice) {
        "1" { Show-ServiceList -Category "All" }
        "2" { Show-SafeToDisableServices }
        "3" { Show-EssentialServices }
        "4" { Analyze-ServiceImpact }
        "5" { Optimize-ServicesForPerformance }
        "6" { Restore-ServicesToDefault }
        "7" { Monitor-Services }
        "8" { Show-Help }
        "9" { Write-ColorOutput "Goodbye!" $Green; exit }
        default { Write-ColorOutput "Invalid choice. Please run the script again." $Red }
    }
}
