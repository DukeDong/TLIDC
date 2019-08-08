%函数名：db_gainallfiles
%作者：董波
%时间：2015 4 20
%函数功能：从给定的路径中，提取所有的与输入后缀一致的文件列表
%输出：列表结构体

function st_filelst = db_gainallfiles(s_path,s_tail)

st_filelst = [];
%获取当前路径下的所有符合条件的文件与其他文件夹
%S1.先读文件
st_files = dir(fullfile(s_path,s_tail));

for i = 1:length(st_files)
    st_sig.s_path = s_path;
    st_sig.s_name = st_files(i).name;
    st_filelst = [st_filelst;st_sig];
end

%S2.读其他文件夹的文件列表
st_dir = dir(s_path);

for i = 1:length(st_dir)
    if strcmp(st_dir(i).name,'..')||strcmp(st_dir(i).name,'.')
        continue;
    end
    
    if st_dir(i).isdir == 0
        continue;
    end
    
    st_deepfile = db_gainallfiles(fullfile(s_path,st_dir(i).name),s_tail);
    
    st_filelst = [st_filelst;st_deepfile];
end

