# Windows 11 Startup Manager GUI
# A user-friendly interface for managing startup applications

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows 11 Startup Manager"
$form.Size = New-Object System.Drawing.Size(1000, 700)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

# Create main panel
$mainPanel = New-Object System.Windows.Forms.Panel
$mainPanel.Dock = "Fill"
$mainPanel.Padding = New-Object System.Windows.Forms.Padding(10)

# Create header
$headerLabel = New-Object System.Windows.Forms.Label
$headerLabel.Text = "Windows 11 Startup Manager"
$headerLabel.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$headerLabel.ForeColor = [System.Drawing.Color]::DarkBlue
$headerLabel.AutoSize = $true
$headerLabel.Location = New-Object System.Drawing.Point(10, 10)

# Create status label
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Loading startup applications..."
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$statusLabel.ForeColor = [System.Drawing.Color]::DarkGreen
$statusLabel.AutoSize = $true
$statusLabel.Location = New-Object System.Drawing.Point(10, 50)

# Create ListView for startup applications
$listView = New-Object System.Windows.Forms.ListView
$listView.Location = New-Object System.Drawing.Point(10, 80)
$listView.Size = New-Object System.Drawing.Size(960, 400)
$listView.View = "Details"
$listView.FullRowSelect = $true
$listView.GridLines = $true
$listView.CheckBoxes = $true

# Add columns
$listView.Columns.Add("Application", 200)
$listView.Columns.Add("Command", 300)
$listView.Columns.Add("Location", 150)
$listView.Columns.Add("User", 100)
$listView.Columns.Add("Memory Usage", 100)
$listView.Columns.Add("Status", 100)

# Create buttons panel
$buttonPanel = New-Object System.Windows.Forms.Panel
$buttonPanel.Location = New-Object System.Drawing.Point(10, 490)
$buttonPanel.Size = New-Object System.Drawing.Size(960, 50)

# Create buttons
$refreshButton = New-Object System.Windows.Forms.Button
$refreshButton.Text = "Refresh"
$refreshButton.Location = New-Object System.Drawing.Point(10, 10)
$refreshButton.Size = New-Object System.Drawing.Size(80, 30)

$disableSelectedButton = New-Object System.Windows.Forms.Button
$disableSelectedButton.Text = "Disable Selected"
$disableSelectedButton.Location = New-Object System.Drawing.Point(100, 10)
$disableSelectedButton.Size = New-Object System.Drawing.Size(120, 30)
$disableSelectedButton.BackColor = [System.Drawing.Color]::Orange

$disableGamingButton = New-Object System.Windows.Forms.Button
$disableGamingButton.Text = "Disable Gaming"
$disableGamingButton.Location = New-Object System.Drawing.Point(230, 10)
$disableGamingButton.Size = New-Object System.Drawing.Size(100, 30)
$disableGamingButton.BackColor = [System.Drawing.Color]::LightCoral

$disableMediaButton = New-Object System.Windows.Forms.Button
$disableMediaButton.Text = "Disable Media"
$disableMediaButton.Location = New-Object System.Drawing.Point(340, 10)
$disableMediaButton.Size = New-Object System.Drawing.Size(100, 30)
$disableMediaButton.BackColor = [System.Drawing.Color]::LightCoral

$disableCloudButton = New-Object System.Windows.Forms.Button
$disableCloudButton.Text = "Disable Cloud"
$disableCloudButton.Location = New-Object System.Drawing.Point(450, 10)
$disableCloudButton.Size = New-Object System.Drawing.Size(100, 30)
$disableCloudButton.BackColor = [System.Drawing.Color]::LightCoral

$disableCommButton = New-Object System.Windows.Forms.Button
$disableCommButton.Text = "Disable Comm"
$disableCommButton.Location = New-Object System.Drawing.Point(560, 10)
$disableCommButton.Size = New-Object System.Drawing.Size(100, 30)
$disableCommButton.BackColor = [System.Drawing.Color]::LightCoral

$exportButton = New-Object System.Windows.Forms.Button
$exportButton.Text = "Export Report"
$exportButton.Location = New-Object System.Drawing.Point(670, 10)
$exportButton.Size = New-Object System.Drawing.Size(100, 30)
$exportButton.BackColor = [System.Drawing.Color]::LightBlue

$closeButton = New-Object System.Windows.Forms.Button
$closeButton.Text = "Close"
$closeButton.Location = New-Object System.Drawing.Point(780, 10)
$closeButton.Size = New-Object System.Drawing.Size(80, 30)
$closeButton.BackColor = [System.Drawing.Color]::LightGray

# Create info panel
$infoPanel = New-Object System.Windows.Forms.Panel
$infoPanel.Location = New-Object System.Drawing.Point(10, 550)
$infoPanel.Size = New-Object System.Drawing.Size(960, 100)
$infoPanel.BorderStyle = "FixedSingle"

$infoLabel = New-Object System.Windows.Forms.Label
$infoLabel.Text = "Information:"
$infoLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$infoLabel.Location = New-Object System.Drawing.Point(10, 10)
$infoLabel.AutoSize = $true

$infoText = New-Object System.Windows.Forms.TextBox
$infoText.Location = New-Object System.Drawing.Point(10, 35)
$infoText.Size = New-Object System.Drawing.Size(940, 60)
$infoText.Multiline = $true
$infoText.ReadOnly = $true
$infoText.ScrollBars = "Vertical"
$infoText.Text = "Select applications to disable and click 'Disable Selected'. Use category buttons to quickly disable groups of applications."

# Global variables
$startupApps = @()
$disabledCount = 0

# Function to load startup applications
function Load-StartupApplications {
    try {
        $statusLabel.Text = "Loading startup applications..."
        $statusLabel.Refresh()
        
        $script:startupApps = Get-CimInstance Win32_StartupCommand | 
            Select-Object Name, Command, Location, User | 
            Sort-Object Name
        
        $listView.Items.Clear()
        
        foreach ($app in $script:startupApps) {
            $item = New-Object System.Windows.Forms.ListViewItem($app.Name)
            $item.SubItems.Add($app.Command)
            $item.SubItems.Add($app.Location)
            $item.SubItems.Add($app.User)
            
            # Check if process is running and get memory usage
            $process = Get-Process -Name $app.Name -ErrorAction SilentlyContinue
            if ($process) {
                $memoryUsage = [math]::Round($process.WorkingSet64 / 1MB, 2)
                $item.SubItems.Add("$memoryUsage MB")
                $item.SubItems.Add("Running")
                $item.ForeColor = [System.Drawing.Color]::Green
            } else {
                $item.SubItems.Add("0 MB")
                $item.SubItems.Add("Not Running")
                $item.ForeColor = [System.Drawing.Color]::Gray
            }
            
            $listView.Items.Add($item)
        }
        
        $statusLabel.Text = "Loaded $($script:startupApps.Count) startup applications"
        $statusLabel.ForeColor = [System.Drawing.Color]::DarkGreen
    } catch {
        $statusLabel.Text = "Error loading startup applications: $($_.Exception.Message)"
        $statusLabel.ForeColor = [System.Drawing.Color]::Red
    }
}

# Function to disable selected applications
function Disable-SelectedApplications {
    $selectedItems = $listView.CheckedItems
    if ($selectedItems.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Please select applications to disable.", "No Selection", "OK", "Information")
        return
    }
    
    $result = [System.Windows.Forms.MessageBox]::Show(
        "Are you sure you want to disable $($selectedItems.Count) selected applications?",
        "Confirm Disable",
        "YesNo",
        "Question"
    )
    
    if ($result -eq "Yes") {
        $disabled = 0
        foreach ($item in $selectedItems) {
            $appName = $item.Text
            $app = $script:startupApps | Where-Object { $_.Name -eq $appName }
            
            if ($app) {
                try {
                    if ($app.Location -like "*HKEY_CURRENT_USER*") {
                        $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
                    } elseif ($app.Location -like "*HKEY_LOCAL_MACHINE*") {
                        $regPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
                    } else {
                        continue
                    }
                    
                    $regEntry = Get-ItemProperty -Path $regPath -Name $appName -ErrorAction SilentlyContinue
                    if ($regEntry) {
                        Remove-ItemProperty -Path $regPath -Name $appName -Force
                        $disabled++
                        $item.ForeColor = [System.Drawing.Color]::Red
                        $item.SubItems[5].Text = "Disabled"
                    }
                } catch {
                    Write-Host "Error disabling $appName : $($_.Exception.Message)"
                }
            }
        }
        
        $script:disabledCount += $disabled
        $statusLabel.Text = "Disabled $disabled applications. Total disabled: $($script:disabledCount)"
        $statusLabel.ForeColor = [System.Drawing.Color]::DarkGreen
    }
}

# Function to disable applications by category
function Disable-ApplicationsByCategory {
    param([string]$Category)
    
    $patterns = @{}
    $patterns["Gaming"] = @("Steam", "Epic", "Origin", "Battle", "Discord", "Riot", "Ubisoft", "EA Desktop", "GOG")
    $patterns["Media"] = @("Spotify", "iTunes", "VLC", "Winamp", "Adobe Creative Cloud", "Adobe Acrobat", "Adobe Reader")
    $patterns["Cloud"] = @("Dropbox", "OneDrive", "Google Drive", "iCloud", "Box Sync", "SugarSync", "SpiderOak", "Mega")
    $patterns["Communication"] = @("Skype", "Zoom", "Microsoft Teams", "Slack", "Discord", "WhatsApp", "Telegram", "Signal")
    
    if (-not $patterns.ContainsKey($Category)) {
        return
    }
    
    $categoryPatterns = $patterns[$Category]
    $itemsToDisable = @()
    
    foreach ($item in $listView.Items) {
        foreach ($pattern in $categoryPatterns) {
            if ($item.Text -like "*$pattern*") {
                $itemsToDisable += $item
                break
            }
        }
    }
    
    if ($itemsToDisable.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("No $Category applications found in startup.", "No Applications", "OK", "Information")
        return
    }
    
    $result = [System.Windows.Forms.MessageBox]::Show(
        "Found $($itemsToDisable.Count) $Category applications. Disable them?",
        "Confirm Disable $Category",
        "YesNo",
        "Question"
    )
    
    if ($result -eq "Yes") {
        $disabled = 0
        foreach ($item in $itemsToDisable) {
            $appName = $item.Text
            $app = $script:startupApps | Where-Object { $_.Name -eq $appName }
            
            if ($app) {
                try {
                    if ($app.Location -like "*HKEY_CURRENT_USER*") {
                        $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
                    } elseif ($app.Location -like "*HKEY_LOCAL_MACHINE*") {
                        $regPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
                    } else {
                        continue
                    }
                    
                    $regEntry = Get-ItemProperty -Path $regPath -Name $appName -ErrorAction SilentlyContinue
                    if ($regEntry) {
                        Remove-ItemProperty -Path $regPath -Name $appName -Force
                        $disabled++
                        $item.ForeColor = [System.Drawing.Color]::Red
                        $item.SubItems[5].Text = "Disabled"
                    }
                } catch {
                    Write-Host "Error disabling $appName : $($_.Exception.Message)"
                }
            }
        }
        
        $script:disabledCount += $disabled
        $statusLabel.Text = "Disabled $disabled $Category applications. Total disabled: $($script:disabledCount)"
        $statusLabel.ForeColor = [System.Drawing.Color]::DarkGreen
    }
}

# Function to export report
function Export-Report {
    $saveDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveDialog.Filter = "CSV files (*.csv)|*.csv|Text files (*.txt)|*.txt|All files (*.*)|*.*"
    $saveDialog.FileName = "startup-applications-report.csv"
    
    if ($saveDialog.ShowDialog() -eq "OK") {
        try {
            $reportData = @()
            foreach ($item in $listView.Items) {
                $reportData += [PSCustomObject]@{
                    Application = $item.Text
                    Command = $item.SubItems[1].Text
                    Location = $item.SubItems[2].Text
                    User = $item.SubItems[3].Text
                    MemoryUsage = $item.SubItems[4].Text
                    Status = $item.SubItems[5].Text
                }
            }
            
            $reportData | Export-Csv -Path $saveDialog.FileName -NoTypeInformation
            [System.Windows.Forms.MessageBox]::Show("Report exported successfully to: $($saveDialog.FileName)", "Export Complete", "OK", "Information")
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Error exporting report: $($_.Exception.Message)", "Export Error", "OK", "Error")
        }
    }
}

# Event handlers
$refreshButton.Add_Click({
    Load-StartupApplications
})

$disableSelectedButton.Add_Click({
    Disable-SelectedApplications
})

$disableGamingButton.Add_Click({
    Disable-ApplicationsByCategory -Category "Gaming"
})

$disableMediaButton.Add_Click({
    Disable-ApplicationsByCategory -Category "Media"
})

$disableCloudButton.Add_Click({
    Disable-ApplicationsByCategory -Category "Cloud"
})

$disableCommButton.Add_Click({
    Disable-ApplicationsByCategory -Category "Communication"
})

$exportButton.Add_Click({
    Export-Report
})

$closeButton.Add_Click({
    $form.Close()
})

# Add controls to form
$buttonPanel.Controls.Add($refreshButton)
$buttonPanel.Controls.Add($disableSelectedButton)
$buttonPanel.Controls.Add($disableGamingButton)
$buttonPanel.Controls.Add($disableMediaButton)
$buttonPanel.Controls.Add($disableCloudButton)
$buttonPanel.Controls.Add($disableCommButton)
$buttonPanel.Controls.Add($exportButton)
$buttonPanel.Controls.Add($closeButton)

$infoPanel.Controls.Add($infoLabel)
$infoPanel.Controls.Add($infoText)

$mainPanel.Controls.Add($headerLabel)
$mainPanel.Controls.Add($statusLabel)
$mainPanel.Controls.Add($listView)
$mainPanel.Controls.Add($buttonPanel)
$mainPanel.Controls.Add($infoPanel)

$form.Controls.Add($mainPanel)

# Load startup applications on form load
$form.Add_Load({
    Load-StartupApplications
})

# Show form
$form.ShowDialog()
