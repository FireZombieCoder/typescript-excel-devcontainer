# Windows 11 Visual Effects Optimizer Console Application
# Manages visual effects, animations, and rendering for maximum performance

param(
    [switch]$ListEffects,
    [switch]$AnalyzePerformance,
    [switch]$OptimizeForPerformance,
    [switch]$OptimizeForAppearance,
    [switch]$RestoreDefaults,
    [switch]$MonitorPerformance,
    [string]$EffectName,
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

function Get-VisualEffectsDatabase {
    return @{
        highImpact = @(
            @{
                name = "Animations"
                displayName = "Animations"
                description = "General system animations"
                registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
                registryValue = "VisualFXSetting"
                defaultValue = 2
                performanceValue = 0
                performanceImpact = "High"
                memoryUsage = "High"
                cpuUsage = "High"
            },
            @{
                name = "DragFullWindows"
                displayName = "Drag full windows"
                description = "Shows window content while dragging"
                registryPath = "HKCU:\Control Panel\Desktop"
                registryValue = "DragFullWindows"
                defaultValue = "1"
                performanceValue = "0"
                performanceImpact = "High"
                memoryUsage = "High"
                cpuUsage = "High"
            },
            @{
                name = "AnimateControlsAndElementsInsideWindows"
                displayName = "Animate controls and elements inside windows"
                description = "Animates UI elements within windows"
                registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
                registryValue = "AnimateControlsAndElementsInsideWindows"
                defaultValue = 1
                performanceValue = 0
                performanceImpact = "High"
                memoryUsage = "High"
                cpuUsage = "High"
            },
            @{
                name = "AnimateWindowsWhenMinimizingAndMaximizing"
                displayName = "Animate windows when minimizing and maximizing"
                description = "Animates window minimize/maximize operations"
                registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
                registryValue = "AnimateWindowsWhenMinimizingAndMaximizing"
                defaultValue = 1
                performanceValue = 0
                performanceImpact = "High"
                memoryUsage = "High"
                cpuUsage = "High"
            }
        ),
        mediumImpact = @(
            @{
                name = "ClientSideShadow"
                displayName = "Client-side shadows"
                description = "Shadows for windows and menus"
                registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
                registryValue = "ClientSideShadow"
                defaultValue = 1
                performanceValue = 0
                performanceImpact = "Medium"
                memoryUsage = "Medium"
                cpuUsage = "Medium"
            },
            @{
                name = "TaskbarAnimations"
                displayName = "Taskbar animations"
                description = "Animates taskbar elements"
                registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
                registryValue = "TaskbarAnimations"
                defaultValue = 1
                performanceValue = 0
                performanceImpact = "Medium"
                memoryUsage = "Medium"
                cpuUsage = "Medium"
            },
            @{
                name = "StartMenuAnimations"
                displayName = "Start menu animations"
                description = "Animates start menu elements"
                registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
                registryValue = "StartMenuAnimations"
                defaultValue = 1
                performanceValue = 0
                performanceImpact = "Medium"
                memoryUsage = "Medium"
                cpuUsage = "Medium"
            },
            @{
                name = "WindowMinimizingAnimation"
                displayName = "Window minimizing animation"
                description = "Animates window minimizing"
                registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
                registryValue = "WindowMinimizingAnimation"
                defaultValue = 1
                performanceValue = 0
                performanceImpact = "Medium"
                memoryUsage = "Medium"
                cpuUsage = "Medium"
            }
        ),
        lowImpact = @(
            @{
                name = "ComboBoxAnimation"
                displayName = "Combo box animation"
                description = "Animates combo box dropdowns"
                registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
                registryValue = "ComboBoxAnimation"
                defaultValue = 1
                performanceValue = 0
                performanceImpact = "Low"
                memoryUsage = "Low"
                cpuUsage = "Low"
            },
            @{
                name = "CursorShadow"
                displayName = "Cursor shadow"
                description = "Shadow behind the mouse cursor"
                registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
                registryValue = "CursorShadow"
                defaultValue = 1
                performanceValue = 0
                performanceImpact = "Low"
                memoryUsage = "Low"
                cpuUsage = "Low"
            },
            @{
                name = "DropShadow"
                displayName = "Drop shadow"
                description = "Shadows for desktop icons"
                registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
                registryValue = "DropShadow"
                defaultValue = 1
                performanceValue = 0
                performanceImpact = "Low"
                memoryUsage = "Low"
                cpuUsage = "Low"
            },
            @{
                name = "ListBoxSmoothScrolling"
                displayName = "List box smooth scrolling"
                description = "Smooth scrolling in list boxes"
                registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
                registryValue = "ListBoxSmoothScrolling"
                defaultValue = 1
                performanceValue = 0
                performanceImpact = "Low"
                memoryUsage = "Low"
                cpuUsage = "Low"
            },
            @{
                name = "MenuAnimation"
                displayName = "Menu animation"
                description = "Animates menu appearance"
                registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
                registryValue = "MenuAnimation"
                defaultValue = 1
                performanceValue = 0
                performanceImpact = "Low"
                memoryUsage = "Low"
                cpuUsage = "Low"
            },
            @{
                name = "MenuFade"
                displayName = "Menu fade"
                description = "Fade effect for menus"
                registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
                registryValue = "MenuFade"
                defaultValue = 1
                performanceValue = 0
                performanceImpact = "Low"
                memoryUsage = "Low"
                cpuUsage = "Low"
            },
            @{
                name = "SelectionFade"
                displayName = "Selection fade"
                description = "Fade effect for selections"
                registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
                registryValue = "SelectionFade"
                defaultValue = 1
                performanceValue = 0
                performanceImpact = "Low"
                memoryUsage = "Low"
                cpuUsage = "Low"
            },
            @{
                name = "TooltipAnimation"
                displayName = "Tooltip animation"
                description = "Animates tooltip appearance"
                registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
                registryValue = "TooltipAnimation"
                defaultValue = 1
                performanceValue = 0
                performanceImpact = "Low"
                memoryUsage = "Low"
                cpuUsage = "Low"
            }
        )
    }
}

function Get-VisualEffectValue {
    param([string]$RegistryPath, [string]$ValueName)
    
    try {
        $value = Get-ItemProperty -Path $RegistryPath -Name $ValueName -ErrorAction SilentlyContinue
        if ($value) {
            return $value.$ValueName
        } else {
            return $null
        }
    } catch {
        return $null
    }
}

function Set-VisualEffectValue {
    param([string]$RegistryPath, [string]$ValueName, [object]$Value)
    
    try {
        # Ensure the registry path exists
        if (-not (Test-Path $RegistryPath)) {
            New-Item -Path $RegistryPath -Force | Out-Null
        }
        
        Set-ItemProperty -Path $RegistryPath -Name $ValueName -Value $Value -ErrorAction Stop
        return $true
    } catch {
        Write-ColorOutput "Error setting visual effect: $($_.Exception.Message)" $Red
        return $false
    }
}

function Show-VisualEffectsList {
    Write-Header "Windows 11 Visual Effects Analysis"
    
    $database = Get-VisualEffectsDatabase
    $allEffects = @()
    
    # Get all effects
    $allEffects += $database.highImpact
    $allEffects += $database.mediumImpact
    $allEffects += $database.lowImpact
    
    Write-ColorOutput "`nAnalyzing visual effects..." $Cyan
    
    foreach ($effect in $allEffects) {
        $currentValue = Get-VisualEffectValue -RegistryPath $effect.registryPath -ValueName $effect.registryValue
        $status = if ($currentValue -eq $effect.performanceValue) { "Optimized" } else { "Not Optimized" }
        $statusColor = if ($status -eq "Optimized") { $Green } else { $Yellow }
        
        $allEffects += [PSCustomObject]@{
            Name = $effect.name
            DisplayName = $effect.displayName
            Description = $effect.description
            CurrentValue = if ($currentValue -ne $null) { $currentValue } else { "Not Set" }
            PerformanceValue = $effect.performanceValue
            Status = $status
            PerformanceImpact = $effect.performanceImpact
            MemoryUsage = $effect.memoryUsage
            CPUUsage = $effect.cpuUsage
        }
    }
    
    # Remove duplicates (the original array items)
    $allEffects = $allEffects | Where-Object { $_.Name -ne $null }
    
    # Sort by performance impact
    $allEffects = $allEffects | Sort-Object @{Expression={$_.PerformanceImpact}; Descending=$true}
    
    Write-ColorOutput "`nFound $($allEffects.Count) visual effects:" $Cyan
    $allEffects | Format-Table -AutoSize
}

function Analyze-VisualEffectsPerformance {
    Write-Header "Visual Effects Performance Analysis"
    
    $database = Get-VisualEffectsDatabase
    $highImpactEffects = @()
    $mediumImpactEffects = @()
    $lowImpactEffects = @()
    $optimizedCount = 0
    $notOptimizedCount = 0
    
    # Analyze high impact effects
    foreach ($effect in $database.highImpact) {
        $currentValue = Get-VisualEffectValue -RegistryPath $effect.registryPath -ValueName $effect.registryValue
        $isOptimized = $currentValue -eq $effect.performanceValue
        
        if ($isOptimized) { $optimizedCount++ } else { $notOptimizedCount++ }
        
        $highImpactEffects += [PSCustomObject]@{
            Name = $effect.name
            DisplayName = $effect.displayName
            CurrentValue = if ($currentValue -ne $null) { $currentValue } else { "Not Set" }
            PerformanceValue = $effect.performanceValue
            IsOptimized = $isOptimized
            PerformanceImpact = $effect.performanceImpact
            MemoryUsage = $effect.memoryUsage
            CPUUsage = $effect.cpuUsage
        }
    }
    
    # Analyze medium impact effects
    foreach ($effect in $database.mediumImpact) {
        $currentValue = Get-VisualEffectValue -RegistryPath $effect.registryPath -ValueName $effect.registryValue
        $isOptimized = $currentValue -eq $effect.performanceValue
        
        if ($isOptimized) { $optimizedCount++ } else { $notOptimizedCount++ }
        
        $mediumImpactEffects += [PSCustomObject]@{
            Name = $effect.name
            DisplayName = $effect.displayName
            CurrentValue = if ($currentValue -ne $null) { $currentValue } else { "Not Set" }
            PerformanceValue = $effect.performanceValue
            IsOptimized = $isOptimized
            PerformanceImpact = $effect.performanceImpact
            MemoryUsage = $effect.memoryUsage
            CPUUsage = $effect.cpuUsage
        }
    }
    
    # Analyze low impact effects
    foreach ($effect in $database.lowImpact) {
        $currentValue = Get-VisualEffectValue -RegistryPath $effect.registryPath -ValueName $effect.registryValue
        $isOptimized = $currentValue -eq $effect.performanceValue
        
        if ($isOptimized) { $optimizedCount++ } else { $notOptimizedCount++ }
        
        $lowImpactEffects += [PSCustomObject]@{
            Name = $effect.name
            DisplayName = $effect.displayName
            CurrentValue = if ($currentValue -ne $null) { $currentValue } else { "Not Set" }
            PerformanceValue = $effect.performanceValue
            IsOptimized = $isOptimized
            PerformanceImpact = $effect.performanceImpact
            MemoryUsage = $effect.memoryUsage
            CPUUsage = $effect.cpuUsage
        }
    }
    
    Write-ColorOutput "`nHigh Impact Effects ($($highImpactEffects.Count)):" $Red
    if ($highImpactEffects.Count -gt 0) {
        $highImpactEffects | Format-Table -AutoSize
    } else {
        Write-ColorOutput "None found." $Yellow
    }
    
    Write-ColorOutput "`nMedium Impact Effects ($($mediumImpactEffects.Count)):" $Yellow
    if ($mediumImpactEffects.Count -gt 0) {
        $mediumImpactEffects | Format-Table -AutoSize
    } else {
        Write-ColorOutput "None found." $Yellow
    }
    
    Write-ColorOutput "`nLow Impact Effects ($($lowImpactEffects.Count)):" $Green
    if ($lowImpactEffects.Count -gt 0) {
        $lowImpactEffects | Format-Table -AutoSize
    } else {
        Write-ColorOutput "None found." $Yellow
    }
    
    # Summary
    Write-ColorOutput "`nSummary:" $Cyan
    Write-ColorOutput "Total Effects: $($highImpactEffects.Count + $mediumImpactEffects.Count + $lowImpactEffects.Count)" $Cyan
    Write-ColorOutput "Optimized: $optimizedCount" $Green
    Write-ColorOutput "Not Optimized: $notOptimizedCount" $Red
    Write-ColorOutput "High Impact: $($highImpactEffects.Count)" $Red
    Write-ColorOutput "Medium Impact: $($mediumImpactEffects.Count)" $Yellow
    Write-ColorOutput "Low Impact: $($lowImpactEffects.Count)" $Green
}

function Optimize-VisualEffectsForPerformance {
    Write-Header "Optimizing Visual Effects for Maximum Performance"
    
    $database = Get-VisualEffectsDatabase
    $optimizedCount = 0
    $skippedCount = 0
    
    Write-ColorOutput "`nOptimizing visual effects for maximum performance..." $Cyan
    
    # Optimize high impact effects
    Write-ColorOutput "`nOptimizing high impact effects..." $Red
    foreach ($effect in $database.highImpact) {
        Write-ColorOutput "Optimizing: $($effect.displayName)" $Cyan
        
        if (Set-VisualEffectValue -RegistryPath $effect.registryPath -ValueName $effect.registryValue -Value $effect.performanceValue) {
            Write-ColorOutput "  ✓ Optimized successfully" $Green
            $optimizedCount++
        } else {
            Write-ColorOutput "  ✗ Failed to optimize" $Red
            $skippedCount++
        }
    }
    
    # Optimize medium impact effects
    Write-ColorOutput "`nOptimizing medium impact effects..." $Yellow
    foreach ($effect in $database.mediumImpact) {
        Write-ColorOutput "Optimizing: $($effect.displayName)" $Cyan
        
        if (Set-VisualEffectValue -RegistryPath $effect.registryPath -ValueName $effect.registryValue -Value $effect.performanceValue) {
            Write-ColorOutput "  ✓ Optimized successfully" $Green
            $optimizedCount++
        } else {
            Write-ColorOutput "  ✗ Failed to optimize" $Red
            $skippedCount++
        }
    }
    
    # Optimize low impact effects
    Write-ColorOutput "`nOptimizing low impact effects..." $Green
    foreach ($effect in $database.lowImpact) {
        Write-ColorOutput "Optimizing: $($effect.displayName)" $Cyan
        
        if (Set-VisualEffectValue -RegistryPath $effect.registryPath -ValueName $effect.registryValue -Value $effect.performanceValue) {
            Write-ColorOutput "  ✓ Optimized successfully" $Green
            $optimizedCount++
        } else {
            Write-ColorOutput "  ✗ Failed to optimize" $Red
            $skippedCount++
        }
    }
    
    # Additional Windows 11 specific optimizations
    Write-ColorOutput "`nApplying additional Windows 11 optimizations..." $Cyan
    
    # Disable transparency effects
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0 -ErrorAction SilentlyContinue
    Write-ColorOutput "  ✓ Disabled transparency effects" $Green
    
    # Disable window animations
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value 0 -ErrorAction SilentlyContinue
    Write-ColorOutput "  ✓ Disabled window animations" $Green
    
    # Disable taskbar animations
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAnimations" -Value 0 -ErrorAction SilentlyContinue
    Write-ColorOutput "  ✓ Disabled taskbar animations" $Green
    
    # Disable start menu animations
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "StartMenuAnimations" -Value 0 -ErrorAction SilentlyContinue
    Write-ColorOutput "  ✓ Disabled start menu animations" $Green
    
    # Disable window shadows
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewShadow" -Value 0 -ErrorAction SilentlyContinue
    Write-ColorOutput "  ✓ Disabled window shadows" $Green
    
    # Disable window content while dragging
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "DragFullWindows" -Value 0 -ErrorAction SilentlyContinue
    Write-ColorOutput "  ✓ Disabled window content while dragging" $Green
    
    Write-ColorOutput "`nOptimization complete!" $Green
    Write-ColorOutput "Effects optimized: $optimizedCount" $Green
    Write-ColorOutput "Effects skipped: $skippedCount" $Yellow
    Write-ColorOutput "`nRestart recommended for full effect." $Cyan
}

function Optimize-VisualEffectsForAppearance {
    Write-Header "Optimizing Visual Effects for Best Appearance"
    
    $database = Get-VisualEffectsDatabase
    $optimizedCount = 0
    $skippedCount = 0
    
    Write-ColorOutput "`nOptimizing visual effects for best appearance..." $Cyan
    
    # Restore all effects to default values
    foreach ($effect in $database.highImpact) {
        Write-ColorOutput "Restoring: $($effect.displayName)" $Cyan
        
        if (Set-VisualEffectValue -RegistryPath $effect.registryPath -ValueName $effect.registryValue -Value $effect.defaultValue) {
            Write-ColorOutput "  ✓ Restored successfully" $Green
            $optimizedCount++
        } else {
            Write-ColorOutput "  ✗ Failed to restore" $Red
            $skippedCount++
        }
    }
    
    foreach ($effect in $database.mediumImpact) {
        Write-ColorOutput "Restoring: $($effect.displayName)" $Cyan
        
        if (Set-VisualEffectValue -RegistryPath $effect.registryPath -ValueName $effect.registryValue -Value $effect.defaultValue) {
            Write-ColorOutput "  ✓ Restored successfully" $Green
            $optimizedCount++
        } else {
            Write-ColorOutput "  ✗ Failed to restore" $Red
            $skippedCount++
        }
    }
    
    foreach ($effect in $database.lowImpact) {
        Write-ColorOutput "Restoring: $($effect.displayName)" $Cyan
        
        if (Set-VisualEffectValue -RegistryPath $effect.registryPath -ValueName $effect.registryValue -Value $effect.defaultValue) {
            Write-ColorOutput "  ✓ Restored successfully" $Green
            $optimizedCount++
        } else {
            Write-ColorOutput "  ✗ Failed to restore" $Red
            $skippedCount++
        }
    }
    
    # Additional Windows 11 specific optimizations for appearance
    Write-ColorOutput "`nApplying additional Windows 11 appearance optimizations..." $Cyan
    
    # Enable transparency effects
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 1 -ErrorAction SilentlyContinue
    Write-ColorOutput "  ✓ Enabled transparency effects" $Green
    
    # Enable window animations
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value 1 -ErrorAction SilentlyContinue
    Write-ColorOutput "  ✓ Enabled window animations" $Green
    
    # Enable taskbar animations
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAnimations" -Value 1 -ErrorAction SilentlyContinue
    Write-ColorOutput "  ✓ Enabled taskbar animations" $Green
    
    # Enable start menu animations
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "StartMenuAnimations" -Value 1 -ErrorAction SilentlyContinue
    Write-ColorOutput "  ✓ Enabled start menu animations" $Green
    
    # Enable window shadows
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewShadow" -Value 1 -ErrorAction SilentlyContinue
    Write-ColorOutput "  ✓ Enabled window shadows" $Green
    
    # Enable window content while dragging
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "DragFullWindows" -Value 1 -ErrorAction SilentlyContinue
    Write-ColorOutput "  ✓ Enabled window content while dragging" $Green
    
    Write-ColorOutput "`nAppearance optimization complete!" $Green
    Write-ColorOutput "Effects restored: $optimizedCount" $Green
    Write-ColorOutput "Effects skipped: $skippedCount" $Yellow
    Write-ColorOutput "`nRestart recommended for full effect." $Cyan
}

function Restore-VisualEffectsDefaults {
    Write-Header "Restoring Visual Effects to Default Settings"
    
    $database = Get-VisualEffectsDatabase
    $restoredCount = 0
    $skippedCount = 0
    
    Write-ColorOutput "`nRestoring visual effects to default settings..." $Cyan
    
    # Restore all effects to default values
    foreach ($effect in $database.highImpact) {
        Write-ColorOutput "Restoring: $($effect.displayName)" $Cyan
        
        if (Set-VisualEffectValue -RegistryPath $effect.registryPath -ValueName $effect.registryValue -Value $effect.defaultValue) {
            Write-ColorOutput "  ✓ Restored successfully" $Green
            $restoredCount++
        } else {
            Write-ColorOutput "  ✗ Failed to restore" $Red
            $skippedCount++
        }
    }
    
    foreach ($effect in $database.mediumImpact) {
        Write-ColorOutput "Restoring: $($effect.displayName)" $Cyan
        
        if (Set-VisualEffectValue -RegistryPath $effect.registryPath -ValueName $effect.registryValue -Value $effect.defaultValue) {
            Write-ColorOutput "  ✓ Restored successfully" $Green
            $restoredCount++
        } else {
            Write-ColorOutput "  ✗ Failed to restore" $Red
            $skippedCount++
        }
    }
    
    foreach ($effect in $database.lowImpact) {
        Write-ColorOutput "Restoring: $($effect.displayName)" $Cyan
        
        if (Set-VisualEffectValue -RegistryPath $effect.registryPath -ValueName $effect.registryValue -Value $effect.defaultValue) {
            Write-ColorOutput "  ✓ Restored successfully" $Green
            $restoredCount++
        } else {
            Write-ColorOutput "  ✗ Failed to restore" $Red
            $skippedCount++
        }
    }
    
    Write-ColorOutput "`nRestoration complete!" $Green
    Write-ColorOutput "Effects restored: $restoredCount" $Green
    Write-ColorOutput "Effects skipped: $skippedCount" $Yellow
    Write-ColorOutput "`nRestart recommended for full effect." $Cyan
}

function Monitor-VisualEffectsPerformance {
    Write-Header "Visual Effects Performance Monitor"
    
    Write-ColorOutput "Monitoring visual effects performance... (Press Ctrl+C to stop)" $Cyan
    
    try {
        while ($true) {
            Clear-Host
            Write-Header "Visual Effects Performance Monitor"
            
            # Get current system performance
            $os = Get-CimInstance Win32_OperatingSystem
            $memory = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
            $processes = Get-Process | Measure-Object
            $cpu = Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average
            
            Write-ColorOutput "`nSystem Performance:" $Cyan
            Write-ColorOutput "Memory Usage: $([math]::Round((($memory.Sum - $os.FreePhysicalMemory) / $memory.Sum) * 100, 2))%" $Cyan
            Write-ColorOutput "CPU Usage: $([math]::Round($cpu.Average, 2))%" $Cyan
            Write-ColorOutput "Running Processes: $($processes.Count)" $Cyan
            Write-ColorOutput "System Uptime: $($os.Uptime.Days) days, $($os.Uptime.Hours) hours" $Cyan
            
            # Check visual effects status
            $database = Get-VisualEffectsDatabase
            $optimizedCount = 0
            $totalCount = 0
            
            foreach ($effect in $database.highImpact) {
                $currentValue = Get-VisualEffectValue -RegistryPath $effect.registryPath -ValueName $effect.registryValue
                $totalCount++
                if ($currentValue -eq $effect.performanceValue) {
                    $optimizedCount++
                }
            }
            
            foreach ($effect in $database.mediumImpact) {
                $currentValue = Get-VisualEffectValue -RegistryPath $effect.registryPath -ValueName $effect.registryValue
                $totalCount++
                if ($currentValue -eq $effect.performanceValue) {
                    $optimizedCount++
                }
            }
            
            foreach ($effect in $database.lowImpact) {
                $currentValue = Get-VisualEffectValue -RegistryPath $effect.registryPath -ValueName $effect.registryValue
                $totalCount++
                if ($currentValue -eq $effect.performanceValue) {
                    $optimizedCount++
                }
            }
            
            Write-ColorOutput "`nVisual Effects Status:" $Cyan
            Write-ColorOutput "Total Effects: $totalCount" $Cyan
            Write-ColorOutput "Optimized: $optimizedCount" $Green
            Write-ColorOutput "Not Optimized: $($totalCount - $optimizedCount)" $Red
            
            Start-Sleep -Seconds 10
        }
    } catch {
        Write-ColorOutput "`nMonitoring stopped." $Yellow
    }
}

function Show-Help {
    Write-Header "Windows 11 Visual Effects Optimizer - Help"
    
    Write-ColorOutput "`nUSAGE:" $Yellow
    Write-ColorOutput "  .\windows-visual-effects-optimizer.ps1 [OPTIONS]" $Cyan
    
    Write-ColorOutput "`nOPTIONS:" $Yellow
    Write-ColorOutput "  -ListEffects           List all visual effects with current status" $Cyan
    Write-ColorOutput "  -AnalyzePerformance    Analyze visual effects performance impact" $Cyan
    Write-ColorOutput "  -OptimizeForPerformance Optimize for maximum performance" $Cyan
    Write-ColorOutput "  -OptimizeForAppearance  Optimize for best appearance" $Cyan
    Write-ColorOutput "  -RestoreDefaults       Restore visual effects to default settings" $Cyan
    Write-ColorOutput "  -MonitorPerformance    Monitor visual effects performance" $Cyan
    Write-ColorOutput "  -Help                  Show this help message" $Cyan
    
    Write-ColorOutput "`nEXAMPLES:" $Yellow
    Write-ColorOutput "  .\windows-visual-effects-optimizer.ps1 -ListEffects" $Cyan
    Write-ColorOutput "  .\windows-visual-effects-optimizer.ps1 -AnalyzePerformance" $Cyan
    Write-ColorOutput "  .\windows-visual-effects-optimizer.ps1 -OptimizeForPerformance" $Cyan
    Write-ColorOutput "  .\windows-visual-effects-optimizer.ps1 -MonitorPerformance" $Cyan
    
    Write-ColorOutput "`nNOTES:" $Yellow
    Write-ColorOutput "  • No administrator privileges required" $Cyan
    Write-ColorOutput "  • All changes are reversible using -RestoreDefaults" $Cyan
    Write-ColorOutput "  • Restart recommended after optimization for full effect" $Cyan
    Write-ColorOutput "  • Monitor performance to track improvements" $Cyan
}

# Main execution
if ($Help) {
    Show-Help
} elseif ($ListEffects) {
    Show-VisualEffectsList
} elseif ($AnalyzePerformance) {
    Analyze-VisualEffectsPerformance
} elseif ($OptimizeForPerformance) {
    Optimize-VisualEffectsForPerformance
} elseif ($OptimizeForAppearance) {
    Optimize-VisualEffectsForAppearance
} elseif ($RestoreDefaults) {
    Restore-VisualEffectsDefaults
} elseif ($MonitorPerformance) {
    Monitor-VisualEffectsPerformance
} else {
    # Interactive mode
    Write-Header "Windows 11 Visual Effects Optimizer"
    
    Write-ColorOutput "`nSelect an option:" $Yellow
    Write-ColorOutput "1. List all visual effects" $Cyan
    Write-ColorOutput "2. Analyze performance impact" $Cyan
    Write-ColorOutput "3. Optimize for maximum performance" $Cyan
    Write-ColorOutput "4. Optimize for best appearance" $Cyan
    Write-ColorOutput "5. Restore to default settings" $Cyan
    Write-ColorOutput "6. Monitor performance" $Cyan
    Write-ColorOutput "7. Show help" $Cyan
    Write-ColorOutput "8. Exit" $Cyan
    
    $choice = Read-Host "`nEnter your choice (1-8)"
    
    switch ($choice) {
        "1" { Show-VisualEffectsList }
        "2" { Analyze-VisualEffectsPerformance }
        "3" { Optimize-VisualEffectsForPerformance }
        "4" { Optimize-VisualEffectsForAppearance }
        "5" { Restore-VisualEffectsDefaults }
        "6" { Monitor-VisualEffectsPerformance }
        "7" { Show-Help }
        "8" { Write-ColorOutput "Goodbye!" $Green; exit }
        default { Write-ColorOutput "Invalid choice. Please run the script again." $Red }
    }
}
