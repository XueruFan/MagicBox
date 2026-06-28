# BIDS Data Split Script
# Function: Split each subject's data into two folders (-1 and -2 suffixes)

# Set execution policy if needed (run as administrator)
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Define root path - modify this to your actual data path
$rootPath = "D:\3RBRAIN"

# Create log file
$logPath = Join-Path $rootPath "SplitBIDSData_Log_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
$logMessages = @()

# Log function
function Write-Log {
    param([string]$message, [string]$color = "White")
    $timestamp = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    $logEntry = "[$timestamp] $message"
    $logMessages += $logEntry
    Write-Host $logEntry -ForegroundColor $color
}

# Start processing
Write-Log "Starting BIDS data split processing" "Green"

# Get all site folders (3RB2_X format)
$siteFolders = Get-ChildItem -Path $rootPath -Directory | Where-Object { $_.Name -like "3RB2_*" }

# Process each site
foreach ($siteFolder in $siteFolders) {
    Write-Log "Processing site: $($siteFolder.Name)" "Green"
    
    $sitePath = $siteFolder.FullName
    
    # Get all subject folders in this site
    $subjectFolders = Get-ChildItem -Path $sitePath -Directory | Where-Object { $_.Name -like "sub-*" -and $_.Name -notlike "*-[12]" }
    
    # Process each subject folder
    foreach ($subjectFolder in $subjectFolders) {
        Write-Log "Processing subject: $($subjectFolder.Name)" "Yellow"
        
        $subjectPath = $subjectFolder.FullName
        $subjectName = $subjectFolder.Name
        
        # Create two new subject folders (-1 and -2 suffixes)
        $newSubjectPath1 = Join-Path $sitePath "$subjectName-1"
        $newSubjectPath2 = Join-Path $sitePath "$subjectName-2"
        
        # Create new folders if they don't exist
        if (!(Test-Path $newSubjectPath1)) {
            New-Item -ItemType Directory -Path $newSubjectPath1 -Force | Out-Null
        }
        if (!(Test-Path $newSubjectPath2)) {
            New-Item -ItemType Directory -Path $newSubjectPath2 -Force | Out-Null
        }
        
        # Create anat, func, fmap subfolders in new subject folders
        $subfolders = @("anat", "func", "fmap")
        foreach ($subfolder in $subfolders) {
            $newSubPath1 = Join-Path $newSubjectPath1 $subfolder
            $newSubPath2 = Join-Path $newSubjectPath2 $subfolder
            
            if (!(Test-Path $newSubPath1)) {
                New-Item -ItemType Directory -Path $newSubPath1 -Force | Out-Null
            }
            if (!(Test-Path $newSubPath2)) {
                New-Item -ItemType Directory -Path $newSubPath2 -Force | Out-Null
            }
        }
        
        # Process anat folder: T1 files to -1, T2 files to -2
        $anatSourcePath = Join-Path $subjectPath "anat"
        if (Test-Path $anatSourcePath) {
            $anatFiles = Get-ChildItem -Path $anatSourcePath -File
            
            $t1Files = $anatFiles | Where-Object { $_.Name -like "*T1w*" }
            $t2Files = $anatFiles | Where-Object { $_.Name -like "*T2w*" }
            
            # Check T1 files
            if ($t1Files.Count -eq 0) {
                Write-Log "  WARNING: No T1 files found in $subjectName/anat" "Red"
            } else {
                foreach ($file in $t1Files) {
                    $destPath = Join-Path (Join-Path $newSubjectPath1 "anat") $file.Name
                    Move-Item -Path $file.FullName -Destination $destPath -Force
                    Write-Log "  Moved T1 file: $($file.Name) -> -1/anat" "Cyan"
                }
            }
            
            # Check T2 files
            if ($t2Files.Count -eq 0) {
                Write-Log "  WARNING: No T2 files found in $subjectName/anat" "Red"
            } else {
                foreach ($file in $t2Files) {
                    $destPath = Join-Path (Join-Path $newSubjectPath2 "anat") $file.Name
                    Move-Item -Path $file.FullName -Destination $destPath -Force
                    Write-Log "  Moved T2 file: $($file.Name) -> -2/anat" "Cyan"
                }
            }
        } else {
            Write-Log "  WARNING: anat folder not found in $subjectName" "Red"
        }
        
        # Process func folder: EyeClose files to -1, EyeOpen files to -2
        $funcSourcePath = Join-Path $subjectPath "func"
        if (Test-Path $funcSourcePath) {
            $funcFiles = Get-ChildItem -Path $funcSourcePath -File
            
            $EyeCloseFiles = $funcFiles | Where-Object { $_.Name -like "*EyeClose*" }
            $EyeOpenFiles = $funcFiles | Where-Object { $_.Name -like "*EyeOpen*" }
            
            # Check EyeClose files
            if ($EyeCloseFiles.Count -eq 0) {
                Write-Log "  WARNING: No EyeClose files found in $subjectName/func" "Red"
            } else {
                foreach ($file in $EyeCloseFiles) {
                    $destPath = Join-Path (Join-Path $newSubjectPath1 "func") $file.Name
                    Move-Item -Path $file.FullName -Destination $destPath -Force
                    Write-Log "  Moved EyeClose file: $($file.Name) -> -1/func" "Magenta"
                }
            }
            
            # Check EyeOpen files
            if ($EyeOpenFiles.Count -eq 0) {
                Write-Log "  WARNING: No EyeOpen files found in $subjectName/func" "Red"
            } else {
                foreach ($file in $EyeOpenFiles) {
                    $destPath = Join-Path (Join-Path $newSubjectPath2 "func") $file.Name
                    Move-Item -Path $file.FullName -Destination $destPath -Force
                    Write-Log "  Moved EyeOpen file: $($file.Name) -> -2/func" "Magenta"
                }
            }
        } else {
            Write-Log "  WARNING: func folder not found in $subjectName" "Red"
        }
        
        # Process fmap folder: magnitude1 files to -1, magnitude2 files to -2
        $fmapSourcePath = Join-Path $subjectPath "fmap"
        if (Test-Path $fmapSourcePath) {
            $fmapFiles = Get-ChildItem -Path $fmapSourcePath -File
            
            $magnitude1Files = $fmapFiles | Where-Object { $_.Name -like "*magnitude1*" }
            $magnitude2Files = $fmapFiles | Where-Object { $_.Name -like "*magnitude2*" }
            $otherFmapFiles = $fmapFiles | Where-Object { $_.Name -notlike "*magnitude1*" -and $_.Name -notlike "*magnitude2*" }
            
            # Check magnitude1 files
            if ($magnitude1Files.Count -eq 0) {
                Write-Log "  WARNING: No magnitude1 files found in $subjectName/fmap" "Red"
            } else {
                foreach ($file in $magnitude1Files) {
                    $destPath = Join-Path (Join-Path $newSubjectPath1 "fmap") $file.Name
                    Move-Item -Path $file.FullName -Destination $destPath -Force
                    Write-Log "  Moved magnitude1 file: $($file.Name) -> -1/fmap" "Gray"
                }
            }
            
            # Check magnitude2 files
            if ($magnitude2Files.Count -eq 0) {
                Write-Log "  WARNING: No magnitude2 files found in $subjectName/fmap" "Red"
            } else {
                foreach ($file in $magnitude2Files) {
                    $destPath = Join-Path (Join-Path $newSubjectPath2 "fmap") $file.Name
                    Move-Item -Path $file.FullName -Destination $destPath -Force
                    Write-Log "  Moved magnitude2 file: $($file.Name) -> -2/fmap" "Gray"
                }
            }
            
            # Process other fmap files (copy to both folders)
            if ($otherFmapFiles.Count -gt 0) {
                foreach ($file in $otherFmapFiles) {
                    # Copy to -1 fmap folder
                    $destPath1 = Join-Path (Join-Path $newSubjectPath1 "fmap") $file.Name
                    Copy-Item -Path $file.FullName -Destination $destPath1 -Force
                    
                    # Move to -2 fmap folder
                    $destPath2 = Join-Path (Join-Path $newSubjectPath2 "fmap") $file.Name
                    Move-Item -Path $file.FullName -Destination $destPath2 -Force
                    
                    Write-Log "  Processed other fmap file: $($file.Name) -> both fmap folders" "Gray"
                }
            }
        } else {
            Write-Log "  WARNING: fmap folder not found in $subjectName" "Red"
        }
        
                # Delete original folder - FIXED: Check if subfolders are empty
        Write-Log "  Checking and deleting original folder: $subjectName" "Yellow"
        try {
            # Check if all subfolders are empty (only check for files, not folders)
            $anatFilesRemaining = if (Test-Path (Join-Path $subjectPath "anat")) { 
                @(Get-ChildItem -Path (Join-Path $subjectPath "anat") -File -ErrorAction SilentlyContinue).Count 
            } else { 0 }
            
            $funcFilesRemaining = if (Test-Path (Join-Path $subjectPath "func")) { 
                @(Get-ChildItem -Path (Join-Path $subjectPath "func") -File -ErrorAction SilentlyContinue).Count 
            } else { 0 }
            
            $fmapFilesRemaining = if (Test-Path (Join-Path $subjectPath "fmap")) { 
                @(Get-ChildItem -Path (Join-Path $subjectPath "fmap") -File -ErrorAction SilentlyContinue).Count 
            } else { 0 }
            
            $totalFilesRemaining = $anatFilesRemaining + $funcFilesRemaining + $fmapFilesRemaining
            
            if ($totalFilesRemaining -eq 0) {
                # All subfolders are empty, safe to delete
                Remove-Item -Path $subjectPath -Recurse -Force
                Write-Log "  Successfully deleted original folder: $subjectName" "Green"
            } else {
                Write-Log "  WARNING: Folder $subjectName still has files, skipping deletion." "Red"
                Write-Log "    anat files remaining: $anatFilesRemaining" "Red"
                Write-Log "    func files remaining: $funcFilesRemaining" "Red"
                Write-Log "    fmap files remaining: $fmapFilesRemaining" "Red"
            }
        }
        catch {
            $errorMsg = "Cannot delete folder $subjectName, error: $($_.Exception.Message)"
            Write-Log "  WARNING: $errorMsg" "Red"
        }
        
        Write-Log "Completed processing subject: $subjectName" "Green"
    }
}

# Write log to file
try {
    $logMessages | Out-File -FilePath $logPath -Encoding UTF8
    Write-Log "Log file saved: $logPath" "Green"
}
catch {
    Write-Host "WARNING: Cannot save log file, error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Log "All data processing completed!" "Green"

# Show statistics
Write-Log "Processing Statistics:" "Yellow"
Write-Log "Number of sites: $($siteFolders.Count)" "White"
$totalSubjects = ($siteFolders | ForEach-Object { 
    (Get-ChildItem -Path $_.FullName -Directory | Where-Object { $_.Name -like "sub-*" -and $_.Name -notlike "*-[12]" }).Count 
} | Measure-Object -Sum).Sum
Write-Log "Original subjects processed: $totalSubjects" "White"
Write-Log "New subject folders created: $($totalSubjects * 2)" "White"
Write-Log "Detailed log available at: $logPath" "Cyan"