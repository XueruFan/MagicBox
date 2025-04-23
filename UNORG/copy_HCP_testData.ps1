# 读取文件夹列表
$folders = Get-Content -Path "HCPtest.txt"

# 设置目标目录
$targetDir = "E:\PhDproject\HCP\HCP_test"

# 创建目标目录，如果不存在
if (-Not (Test-Path -Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir
}

# 创建目标文件夹结构
foreach ($folder in $folders) {
    $sourcePath = "D:\HCP\$folder"
    $destinationFolderPath = Join-Path -Path $targetDir -ChildPath $folder

    if (-Not (Test-Path -Path $destinationFolderPath)) {
        Write-Host "Creating folder: $destinationFolderPath"
        New-Item -ItemType Directory -Path $destinationFolderPath -Force
    }
}

# 遍历文件夹列表并拷贝指定的子文件夹中的特定文件
foreach ($folder in $folders) {
    $sourcePath = "D:\HCP\$folder"
    $destinationFolderPath = Join-Path -Path $targetDir -ChildPath $folder
    $foldersToCopy = @("preproc")

    foreach ($subFolder in $foldersToCopy) {
        $sourceSubFolderPath = Join-Path -Path $sourcePath -ChildPath $subFolder
        if (Test-Path -Path $sourceSubFolderPath) {
            # 查找包含关键字 "rfMRI" 的文件
            $filesToCopy = Get-ChildItem -Path $sourceSubFolderPath -Recurse | Where-Object { $_.Name -like "*rfMRI*" }

            foreach ($file in $filesToCopy) {
                # 构建目标文件路径，保留原始文件夹结构
                $relativePath = $file.FullName.Substring($sourcePath.Length + 1)
                $destinationFilePath = Join-Path -Path $destinationFolderPath -ChildPath $relativePath

                # 创建目标文件夹（如果不存在）
                $destinationDir = Split-Path -Path $destinationFilePath -Parent
                if (-Not (Test-Path -Path $destinationDir)) {
                    Write-Host "Creating folder: $destinationDir"
                    New-Item -ItemType Directory -Path $destinationDir -Force
                }

                # 复制文件
                Write-Host "Copying file: $file.FullName to $destinationFilePath"
                Copy-Item -Path $file.FullName -Destination $destinationFilePath -Force
            }
        } else {
            Write-Host "Source subfolder does not exist: $sourceSubFolderPath"
        }
    }
}
