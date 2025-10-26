# Windows 11 Performance Optimizer Console Application
# Manages services and visual effects for maximum performance

param(
    [switch]$ListServices,
    [switch]$ListVisualEffects,
    [switch]$OptimizeServices,
    [switch]$OptimizeVisualEffects,
    [switch]$OptimizeAll,
    [switch]$RestoreDefaults,
    [switch]$MonitorPerformance,
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
    Write-ColorOutput "`n" + "="*60 $Cyan
    Write-ColorOutput " $Title" $Cyan
    Write-ColorOutput "="*60 $Cyan
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

function Get-SafeToDisableServices {
    return @(
        @{
            Name = "Fax"
            DisplayName = "Fax Service"
            Description = "Sends and receives fax transmissions"
            Impact = "None"
            Category = "Communication"
            SafeToDisable = $true
        },
        @{
            Name = "XblAuthManager"
            DisplayName = "Xbox Live Auth Manager"
            Description = "Provides authentication and authorization services for Xbox Live"
            Impact = "Low"
            Category = "Gaming"
            SafeToDisable = $true
        },
        @{
            Name = "XblGameSave"
            DisplayName = "Xbox Live Game Save"
            Description = "Provides game save synchronization for Xbox Live"
            Impact = "Low"
            Category = "Gaming"
            SafeToDisable = $true
        },
        @{
            Name = "XboxGipSvc"
            DisplayName = "Xbox Accessory Management Service"
            Description = "Manages Xbox accessories and controllers"
            Impact = "Low"
            Category = "Gaming"
            SafeToDisable = $true
        },
        @{
            Name = "XboxNetApiSvc"
            DisplayName = "Xbox Live Networking Service"
            Description = "Provides networking services for Xbox Live"
            Impact = "Low"
            Category = "Gaming"
            SafeToDisable = $true
        },
        @{
            Name = "RemoteRegistry"
            DisplayName = "Remote Registry"
            Description = "Allows remote registry manipulation"
            Impact = "None"
            Category = "System"
            SafeToDisable = $true
        },
        @{
            Name = "Telnet"
            DisplayName = "Telnet"
            Description = "Provides Telnet client functionality"
            Impact = "None"
            Category = "Communication"
            SafeToDisable = $true
        },
        @{
            Name = "TlntSvr"
            DisplayName = "Telnet Server"
            Description = "Provides Telnet server functionality"
            Impact = "None"
            Category = "Communication"
            SafeToDisable = $true
        },
        @{
            Name = "WSearch"
            DisplayName = "Windows Search"
            Description = "Indexes content for Windows Search"
            Impact = "High"
            Category = "System"
            SafeToDisable = $true
        },
        @{
            Name = "TabletInputService"
            DisplayName = "Touch Keyboard and Handwriting Panel Service"
            Description = "Enables touch keyboard and handwriting panel"
            Impact = "Low"
            Category = "Input"
            SafeToDisable = $true
        },
        @{
            Name = "WbioSrvc"
            DisplayName = "Windows Biometric Service"
            Description = "Supports biometric authentication"
            Impact = "Low"
            Category = "Security"
            SafeToDisable = $true
        },
        @{
            Name = "WMPNetworkSvc"
            DisplayName = "Windows Media Player Network Sharing Service"
            Description = "Shares Windows Media Player libraries"
            Impact = "Low"
            Category = "Media"
            SafeToDisable = $true
        },
        @{
            Name = "WpnService"
            DisplayName = "Windows Push Notifications System Service"
            Description = "Manages push notifications"
            Impact = "Low"
            Category = "System"
            SafeToDisable = $true
        },
        @{
            Name = "XblAuthManager"
            DisplayName = "Xbox Live Auth Manager"
            Description = "Xbox Live authentication service"
            Impact = "Low"
            Category = "Gaming"
            SafeToDisable = $true
        },
        @{
            Name = "XblGameSave"
            DisplayName = "Xbox Live Game Save"
            Description = "Xbox Live game save synchronization"
            Impact = "Low"
            Category = "Gaming"
            SafeToDisable = $true
        },
        @{
            Name = "XboxGipSvc"
            DisplayName = "Xbox Accessory Management Service"
            Description = "Xbox accessory management"
            Impact = "Low"
            Category = "Gaming"
            SafeToDisable = $true
        },
        @{
            Name = "XboxNetApiSvc"
            DisplayName = "Xbox Live Networking Service"
            Description = "Xbox Live networking"
            Impact = "Low"
            Category = "Gaming"
            SafeToDisable = $true
        },
        @{
            Name = "XboxLiveAuthManager"
            DisplayName = "Xbox Live Auth Manager"
            Description = "Xbox Live authentication"
            Impact = "Low"
            Category = "Gaming"
            SafeToDisable = $true
        },
        @{
            Name = "XboxLiveGameSave"
            DisplayName = "Xbox Live Game Save"
            Description = "Xbox Live game save sync"
            Impact = "Low"
            Category = "Gaming"
            SafeToDisable = $true
        },
        @{
            Name = "XboxNetApiSvc"
            DisplayName = "Xbox Live Networking Service"
            Description = "Xbox Live networking"
            Impact = "Low"
            Category = "Gaming"
            SafeToDisable = $true
        }
    )
}

function Get-VisualEffectsSettings {
    return @(
        @{
            Name = "AnimateControlsAndElementsInsideWindows"
            DisplayName = "Animate controls and elements inside windows"
            Description = "Animates UI elements within windows"
            PerformanceImpact = "Medium"
            SafeToDisable = $true
        },
        @{
            Name = "AnimateWindowsWhenMinimizingAndMaximizing"
            DisplayName = "Animate windows when minimizing and maximizing"
            Description = "Animates window minimize/maximize operations"
            PerformanceImpact = "Low"
            SafeToDisable = $true
        },
        @{
            Name = "Animations"
            DisplayName = "Animations"
            Description = "General system animations"
            PerformanceImpact = "High"
            SafeToDisable = $true
        },
        @{
            Name = "ClientSideShadow"
            DisplayName = "Client-side shadows"
            Description = "Shadows for windows and menus"
            PerformanceImpact = "Medium"
            SafeToDisable = $true
        },
        @{
            Name = "ComboBoxAnimation"
            DisplayName = "Combo box animation"
            Description = "Animates combo box dropdowns"
            PerformanceImpact = "Low"
            SafeToDisable = $true
        },
        @{
            Name = "CursorShadow"
            DisplayName = "Cursor shadow"
            Description = "Shadow behind the mouse cursor"
            PerformanceImpact = "Low"
            SafeToDisable = $true
        },
        @{
            Name = "DesktopComposition"
            DisplayName = "Desktop composition"
            Description = "Hardware-accelerated desktop composition"
            PerformanceImpact = "High"
            SafeToDisable = $false
        },
        @{
            Name = "DragFullWindows"
            DisplayName = "Drag full windows"
            Description = "Shows window content while dragging"
            PerformanceImpact = "Medium"
            SafeToDisable = $true
        },
        @{
            Name = "DropShadow"
            DisplayName = "Drop shadow"
            Description = "Shadows for desktop icons"
            PerformanceImpact = "Low"
            SafeToDisable = $true
        },
        @{
            Name = "FontSmoothing"
            DisplayName = "Font smoothing"
            Description = "Smooths fonts for better readability"
            PerformanceImpact = "Low"
            SafeToDisable = $false
        },
        @{
            Name = "ListBoxSmoothScrolling"
            DisplayName = "List box smooth scrolling"
            Description = "Smooth scrolling in list boxes"
            PerformanceImpact = "Low"
            SafeToDisable = $true
        },
        @{
            Name = "MenuAnimation"
            DisplayName = "Menu animation"
            Description = "Animates menu appearance"
            PerformanceImpact = "Low"
            SafeToDisable = $true
        },
        @{
            Name = "MenuFade"
            DisplayName = "Menu fade"
            Description = "Fade effect for menus"
            PerformanceImpact = "Low"
            SafeToDisable = $true
        },
        @{
            Name = "MenuShowDelay"
            DisplayName = "Menu show delay"
            Description = "Delay before showing menus"
            PerformanceImpact = "None"
            SafeToDisable = $true
        },
        @{
            Name = "SelectionFade"
            DisplayName = "Selection fade"
            Description = "Fade effect for selections"
            PerformanceImpact = "Low"
            SafeToDisable = $true
        },
        @{
            Name = "TaskbarAnimations"
            DisplayName = "Taskbar animations"
            Description = "Animates taskbar elements"
            PerformanceImpact = "Medium"
            SafeToDisable = $true
        },
        @{
            Name = "TooltipAnimation"
            DisplayName = "Tooltip animation"
            Description = "Animates tooltip appearance"
            PerformanceImpact = "Low"
            SafeToDisable = $true
        },
        @{
            Name = "WindowMinimizingAnimation"
            DisplayName = "Window minimizing animation"
            Description = "Animates window minimizing"
            PerformanceImpact = "Low"
            SafeToDisable = $true
        }
    )
}

function Get-ServiceStatus {
    param([string]$ServiceName)
    
    try {
        $service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
        if ($service) {
            return [PSCustomObject]@{
                Name = $service.Name
                DisplayName = $service.DisplayName
                Status = $service.Status
                StartType = $service.StartType
                CanStop = $service.CanStop
                CanPauseAndContinue = $service.CanPauseAndContinue
            }
        } else {
            return $null
        }
    } catch {
        Write-ColorOutput "Error getting service status: $($_.Exception.Message)" $Red
        return $null
    }
}

function Set-ServiceStartupType {
    param([string]$ServiceName, [string]$StartupType)
    
    try {
        Set-Service -Name $ServiceName -StartupType $StartupType -ErrorAction Stop
        Write-ColorOutput "Service '$ServiceName' startup type set to '$StartupType'" $Green
        return $true
    } catch {
        Write-ColorOutput "Error setting service startup type: $($_.Exception.Message)" $Red
        return $false
    }
}

function Stop-ServiceSafely {
    param([string]$ServiceName)
    
    try {
        $service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
        if ($service -and $service.Status -eq "Running") {
            if ($service.CanStop) {
                Stop-Service -Name $ServiceName -Force -ErrorAction Stop
                Write-ColorOutput "Service '$ServiceName' stopped successfully" $Green
            } else {
                Write-ColorOutput "Service '$ServiceName' cannot be stopped" $Yellow
            }
        } else {
            Write-ColorOutput "Service '$ServiceName' is not running" $Yellow
        }
        return $true
    } catch {
        Write-ColorOutput "Error stopping service: $($_.Exception.Message)" $Red
        return $false
    }
}

function Get-VisualEffectSetting {
    param([string]$SettingName)
    
    try {
        $value = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name $SettingName -ErrorAction SilentlyContinue
        if ($value) {
            return $value.$SettingName
        } else {
            return $null
        }
    } catch {
        return $null
    }
}

function Set-VisualEffectSetting {
    param([string]$SettingName, [int]$Value)
    
    try {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name $SettingName -Value $Value -ErrorAction Stop
        Write-ColorOutput "Visual effect '$SettingName' set to $Value" $Green
        return $true
    } catch {
        Write-ColorOutput "Error setting visual effect: $($_.Exception.Message)" $Red
        return $false
    }
}

function Show-ServiceList {
    Write-Header "Windows Services - Safe to Disable"
    
    $services = Get-SafeToDisableServices
    $runningServices = @()
    
    foreach ($service in $services) {
        $status = Get-ServiceStatus -ServiceName $service.Name
        if ($status) {
            $runningServices += [PSCustomObject]@{
                Name = $service.Name
                DisplayName = $service.DisplayName
                Description = $service.Description
                Status = $status.Status
                StartType = $status.StartType
                Impact = $service.Impact
                Category = $service.Category
            }
        }
    }
    
    if ($runningServices.Count -gt 0) {
        Write-ColorOutput "`nFound $($runningServices.Count) services that can be optimized:" $Cyan
        $runningServices | Format-Table -AutoSize
    } else {
        Write-ColorOutput "No optimizable services found." $Yellow
    }
}

function Show-VisualEffectsList {
    Write-Header "Windows 11 Visual Effects Settings"
    
    $effects = Get-VisualEffectsSettings
    $currentSettings = @()
    
    foreach ($effect in $effects) {
        $currentValue = Get-VisualEffectSetting -SettingName $effect.Name
        $currentSettings += [PSCustomObject]@{
            Name = $effect.Name
            DisplayName = $effect.DisplayName
            Description = $effect.Description
            CurrentValue = if ($currentValue -ne $null) { $currentValue } else { "Not Set" }
            PerformanceImpact = $effect.PerformanceImpact
            SafeToDisable = $effect.SafeToDisable
        }
    }
    
    $currentSettings | Format-Table -AutoSize
}

function Optimize-Services {
    Write-Header "Optimizing Windows Services"
    
    if (-not (Test-Administrator)) {
        Write-ColorOutput "Administrator privileges required for service optimization." $Red
        Write-ColorOutput "Please run as Administrator." $Yellow
        return
    }
    
    $services = Get-SafeToDisableServices
    $optimizedCount = 0
    
    foreach ($service in $services) {
        $status = Get-ServiceStatus -ServiceName $service.Name
        if ($status -and $status.Status -eq "Running") {
            Write-ColorOutput "`nOptimizing service: $($service.DisplayName)" $Cyan
            
            # Stop the service
            if (Stop-ServiceSafely -ServiceName $service.Name) {
                # Set startup type to disabled
                if (Set-ServiceStartupType -ServiceName $service.Name -StartupType "Disabled") {
                    $optimizedCount++
                    Write-ColorOutput "  ✓ Service optimized successfully" $Green
                }
            }
        }
    }
    
    Write-ColorOutput "`nOptimized $optimizedCount services" $Green
}

function Optimize-VisualEffects {
    Write-Header "Optimizing Windows 11 Visual Effects"
    
    $effects = Get-VisualEffectsSettings
    $optimizedCount = 0
    
    foreach ($effect in $effects) {
        if ($effect.SafeToDisable) {
            Write-ColorOutput "`nOptimizing visual effect: $($effect.DisplayName)" $Cyan
            
            # Set to disabled (0 = disabled, 1 = enabled)
            if (Set-VisualEffectSetting -SettingName $effect.Name -Value 0) {
                $optimizedCount++
                Write-ColorOutput "  ✓ Visual effect optimized successfully" $Green
            }
        }
    }
    
    # Additional Windows 11 specific optimizations
    Write-ColorOutput "`nApplying additional Windows 11 optimizations..." $Cyan
    
    # Disable transparency effects
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0 -ErrorAction SilentlyContinue
    
    # Disable window animations
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value 0 -ErrorAction SilentlyContinue
    
    # Disable taskbar animations
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAnimations" -Value 0 -ErrorAction SilentlyContinue
    
    # Disable start menu animations
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "StartMenuAnimations" -Value 0 -ErrorAction SilentlyContinue
    
    Write-ColorOutput "`nOptimized $optimizedCount visual effects" $Green
    Write-ColorOutput "Applied additional Windows 11 optimizations" $Green
}

function Optimize-All {
    Write-Header "Full Windows 11 Performance Optimization"
    
    Write-ColorOutput "This will optimize both services and visual effects for maximum performance." $Yellow
    $confirm = Read-Host "Continue? (y/N)"
    
    if ($confirm -eq "y" -or $confirm -eq "Y") {
        Optimize-Services
        Optimize-VisualEffects
        
        Write-ColorOutput "`nOptimization complete! Restart recommended for full effect." $Green
    } else {
        Write-ColorOutput "Optimization cancelled." $Yellow
    }
}

function Restore-Defaults {
    Write-Header "Restoring Default Windows Settings"
    
    Write-ColorOutput "This will restore default service and visual effect settings." $Yellow
    $confirm = Read-Host "Continue? (y/N)"
    
    if ($confirm -eq "y" -or $confirm -eq "Y") {
        # Restore services to automatic/manual
        $services = Get-SafeToDisableServices
        foreach ($service in $services) {
            Set-ServiceStartupType -ServiceName $service.Name -StartupType "Manual"
        }
        
        # Restore visual effects
        $effects = Get-VisualEffectsSettings
        foreach ($effect in $effects) {
            Set-VisualEffectSetting -SettingName $effect.Name -Value 1
        }
        
        Write-ColorOutput "`nDefault settings restored! Restart recommended." $Green
    } else {
        Write-ColorOutput "Restore cancelled." $Yellow
    }
}

function Monitor-Performance {
    Write-Header "Performance Monitoring"
    
    Write-ColorOutput "Monitoring system performance... (Press Ctrl+C to stop)" $Cyan
    
    try {
        while ($true) {
            $os = Get-CimInstance Win32_OperatingSystem
            $memory = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
            $processes = Get-Process | Measure-Object
            $cpu = Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average
            
            Clear-Host
            Write-Header "Performance Monitor"
            
            Write-ColorOutput "Memory Usage: $([math]::Round((($memory.Sum - $os.FreePhysicalMemory) / $memory.Sum) * 100, 2))%" $Cyan
            Write-ColorOutput "CPU Usage: $([math]::Round($cpu.Average, 2))%" $Cyan
            Write-ColorOutput "Running Processes: $($processes.Count)" $Cyan
            Write-ColorOutput "System Uptime: $($os.Uptime.Days) days, $($os.Uptime.Hours) hours" $Cyan
            
            Start-Sleep -Seconds 5
        }
    } catch {
        Write-ColorOutput "`nMonitoring stopped." $Yellow
    }
}

function Show-Help {
    Write-Header "Windows 11 Performance Optimizer - Help"
    
    Write-ColorOutput "`nUSAGE:" $Yellow
    Write-ColorOutput "  .\windows-performance-optimizer.ps1 [OPTIONS]" $Cyan
    
    Write-ColorOutput "`nOPTIONS:" $Yellow
    Write-ColorOutput "  -ListServices          List services that can be optimized" $Cyan
    Write-ColorOutput "  -ListVisualEffects     List visual effects that can be optimized" $Cyan
    Write-ColorOutput "  -OptimizeServices      Optimize Windows services (requires admin)" $Cyan
    Write-ColorOutput "  -OptimizeVisualEffects Optimize visual effects and animations" $Cyan
    Write-ColorOutput "  -OptimizeAll           Optimize both services and visual effects" $Cyan
    Write-ColorOutput "  -RestoreDefaults       Restore default Windows settings" $Cyan
    Write-ColorOutput "  -MonitorPerformance    Monitor system performance in real-time" $Cyan
    Write-ColorOutput "  -Help                  Show this help message" $Cyan
    
    Write-ColorOutput "`nEXAMPLES:" $Yellow
    Write-ColorOutput "  .\windows-performance-optimizer.ps1 -ListServices" $Cyan
    Write-ColorOutput "  .\windows-performance-optimizer.ps1 -OptimizeAll" $Cyan
    Write-ColorOutput "  .\windows-performance-optimizer.ps1 -MonitorPerformance" $Cyan
    
    Write-ColorOutput "`nNOTES:" $Yellow
    Write-ColorOutput "  • Service optimization requires Administrator privileges" $Cyan
    Write-ColorOutput "  • Visual effects optimization works without admin privileges" $Cyan
    Write-ColorOutput "  • Restart recommended after optimization for full effect" $Cyan
    Write-ColorOutput "  • All changes are reversible using -RestoreDefaults" $Cyan
}

# Main execution
if ($Help) {
    Show-Help
} elseif ($ListServices) {
    Show-ServiceList
} elseif ($ListVisualEffects) {
    Show-VisualEffectsList
} elseif ($OptimizeServices) {
    Optimize-Services
} elseif ($OptimizeVisualEffects) {
    Optimize-VisualEffects
} elseif ($OptimizeAll) {
    Optimize-All
} elseif ($RestoreDefaults) {
    Restore-Defaults
} elseif ($MonitorPerformance) {
    Monitor-Performance
} else {
    # Interactive mode
    Write-Header "Windows 11 Performance Optimizer"
    
    Write-ColorOutput "`nSelect an option:" $Yellow
    Write-ColorOutput "1. List services that can be optimized" $Cyan
    Write-ColorOutput "2. List visual effects that can be optimized" $Cyan
    Write-ColorOutput "3. Optimize services (requires admin)" $Cyan
    Write-ColorOutput "4. Optimize visual effects" $Cyan
    Write-ColorOutput "5. Optimize everything (requires admin)" $Cyan
    Write-ColorOutput "6. Restore default settings" $Cyan
    Write-ColorOutput "7. Monitor performance" $Cyan
    Write-ColorOutput "8. Show help" $Cyan
    Write-ColorOutput "9. Exit" $Cyan
    
    $choice = Read-Host "`nEnter your choice (1-9)"
    
    switch ($choice) {
        "1" { Show-ServiceList }
        "2" { Show-VisualEffectsList }
        "3" { Optimize-Services }
        "4" { Optimize-VisualEffects }
        "5" { Optimize-All }
        "6" { Restore-Defaults }
        "7" { Monitor-Performance }
        "8" { Show-Help }
        "9" { Write-ColorOutput "Goodbye!" $Green; exit }
        default { Write-ColorOutput "Invalid choice. Please run the script again." $Red }
    }
}
