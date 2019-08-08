%++++++++++++++++++++++++++++++++++++%
%作者：董波
%函数功能：递归创建文件夹
%输入：文件夹名
%输出：确保传入文件夹存在
%++++++++++++++++++++++++++++++++++++%

function db_createfolder(s_dirname)

%S1判断是否存在
if isdir(s_dirname)
    return;
end

%S2 确保顶级文件夹存在
n_line = find(s_dirname == '\',1,'last');
db_createfolder(s_dirname(1:n_line-1));

%S3 创建文件夹
mkdir(s_dirname);