xueru_disk = '/Volumes/Xueru/'; % 硬盘路径
data_folder = 'S1200TRT'; % 数据文件夹
data_path = strcat(xueru_disk, data_folder, '/'); % 数据路径
sm_path = '/Volumes/Xueru/sm/CSV/'; % 模板文件路径
cd (sm_path); subID = xlsread('SubjectID.xlsx'); % 导入被试编号文件
nsubs = numel(subID); % 计算被试个数
%%
for N = 2:nsubs
    cd /Volumes/Xueru/HCP_S1200TRT_ICAFIXdata
    sub = subID(N,1);
    eval(strcat("mkdir ", num2str(sub), " Test1"))
    eval(strcat("mkdir ", num2str(sub), " Test2")) 
    for T = 1:2
        newpath = strcat('/Volumes/Xueru/HCP_S1200TRT_ICAFIXdata/',...
            num2str(sub),'/Test',num2str(T),'/');
        cd (strcat(data_path, num2str(sub), '/Test', num2str(T), '/'))
        eval(strcat("movefile rfMRI* ", newpath))
    end
end