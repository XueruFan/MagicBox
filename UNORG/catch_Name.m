Path = "Z:\NKIQC\T1w\"
File = dir(fullfile(Path,'*T1w.html'));  % 显示文件夹下所有符合后缀名为T1w.html文件(后缀名可以根据自己情况进行修改)的完整信息
FileNames = {File.name}';            % 提取符合后缀名为T1w.html的所有文件的文件名，转换为n行1列
Length_Names = size(FileNames,1);    % 获取所提取数据文件的个数
for k = 1 : Length_Names  %对文件名进行遍历保存写入txt文件
    res1(k) = FileNames(k);
    fp=fopen('Z:\NKIQC\SubList.txt','w');  %'SubList.txt'为文件名（此处填入txt文件路径及名字）；'w'为打开并写入，若文件不存在则创建
    fprintf(fp,'%s\r\n',string(res1));   %fp为文件句柄，指定要写入数据的文件，%s表示保存字符串（也可以替换为其他格式，比如%d表示整数），\r\n 表示换行保存，也可以替换为其他格式，比如空格。
    fclose(fp);   %关闭文件
end

