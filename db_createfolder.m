%++++++++++++++++++++++++++++++++++++%
%���ߣ�����
%�������ܣ��ݹ鴴���ļ���
%���룺�ļ�����
%�����ȷ�������ļ��д���
%++++++++++++++++++++++++++++++++++++%

function db_createfolder(s_dirname)

%S1�ж��Ƿ����
if isdir(s_dirname)
    return;
end

%S2 ȷ�������ļ��д���
n_line = find(s_dirname == '\',1,'last');
db_createfolder(s_dirname(1:n_line-1));

%S3 �����ļ���
mkdir(s_dirname);