%+++++++++++++++++++++++++++++++%
%���ߣ�����
%�������ܣ���ʾ�������
%���룺���������������
%�������������ʾ         
%++++++++++++++++++++++++++++++++%
function db_showprocess(n_complete,n_total)

n_breakflag = 0;

%S1������������
global h_waitbar

if isempty(h_waitbar)
    h_waitbar = waitbar(0,'�����Ѿ���ʼ','Name','���������...');
end

%S2���������ʾ
d_cmprate = n_complete/n_total;
waitbar(d_cmprate,h_waitbar,sprintf('�����Ѿ���ɰٷ�֮%f',d_cmprate*100));

