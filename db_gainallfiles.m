%��������db_gainallfiles
%���ߣ�����
%ʱ�䣺2015 4 20
%�������ܣ��Ӹ�����·���У���ȡ���е��������׺һ�µ��ļ��б�
%������б�ṹ��

function st_filelst = db_gainallfiles(s_path,s_tail)

st_filelst = [];
%��ȡ��ǰ·���µ����з����������ļ��������ļ���
%S1.�ȶ��ļ�
st_files = dir(fullfile(s_path,s_tail));

for i = 1:length(st_files)
    st_sig.s_path = s_path;
    st_sig.s_name = st_files(i).name;
    st_filelst = [st_filelst;st_sig];
end

%S2.�������ļ��е��ļ��б�
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

