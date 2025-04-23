# 设置目标目录
$targetDir = "E:\PhDproject\HCP\HCP_test"

# 获取目标目录中的所有压缩文件
$zipFiles = Get-ChildItem -Path $targetDir -Recurse -Filter *.zip

foreach ($zipFile in $zipFiles) {
    # 使用压缩文件所在的文件夹作为解压目标路径
    $parentDir = $zipFile.DirectoryName
    $zipFileName = [System.IO.Path]::GetFileNameWithoutExtension($zipFile.Name)
    $zipFilePath = $zipFile.FullName
    $tempDestinationPath = Join-Path -Path $parentDir -ChildPath $zipFileName

    # 创建临时解压目标路径（如果不存在）
    if (-Not (Test-Path -Path $tempDestinationPath)) {
        Write-Host "Creating folder: $tempDestinationPath"
        New-Item -ItemType Directory -Path $tempDestinationPath -Force
    }

    # 解压缩文件
    Write-Host "Extracting file: $zipFilePath to $tempDestinationPath"
    Expand-Archive -Path $zipFilePath -DestinationPath $tempDestinationPath -Force

    # 获取解压后的文件夹路径（通常是压缩包内的顶级目录）
    $extractedFolder = Get-ChildItem -Path $tempDestinationPath | Where-Object { $_.PSIsContainer } | Select-Object -First 1

    if ($extractedFolder) {
        $newFolderName = Join-Path -Path $parentDir -ChildPath $zipFileName

        # 检查目标文件夹是否已经存在
        if (-Not (Test-Path -Path $newFolderName)) {
            Write-Host "Renaming folder: $($extractedFolder.FullName) to $newFolderName"
            Rename-Item -Path $extractedFolder.FullName -NewName $newFolderName
        }
    }
}
