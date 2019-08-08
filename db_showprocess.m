%+++++++++++++++++++++++++++++++%
%作者：董波
%函数功能：显示处理进程
%输入：已完成数量与总数
%输出：进度条显示         
%++++++++++++++++++++++++++++++++%
function db_showprocess(n_complete,n_total)

n_breakflag = 0;

%S1创建宏句柄变量
global h_waitbar

if isempty(h_waitbar)
    h_waitbar = waitbar(0,'进程已经开始','Name','处理进行中...');
end

%S2处理进度显示
d_cmprate = n_complete/n_total;
waitbar(d_cmprate,h_waitbar,sprintf('进程已经完成百分之%f',d_cmprate*100));

