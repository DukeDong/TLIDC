%董波
%宏
clear all
db_globalcommands();

s_trainfile = './MNIST/train-images.idx3-ubyte';
s_trainlabel = './MNIST/train-labels.idx1-ubyte';
s_testfile = './MNIST/t10k-images.idx3-ubyte';
s_testlabel = './MNIST/t10k-labels.idx1-ubyte';

x_train = loadMNISTImages(s_trainfile);
y_train = (loadMNISTLabels(s_trainlabel));
x_test = loadMNISTImages(s_testfile);
y_test = (loadMNISTLabels(s_testlabel));

n_clsnum = 10;

d_distrate = 0.4;%归一化特征与中心平均几何距离在0.25以内
d_delta = 0.1;
d_rate = d_distrate:d_delta:1;
m_data = x_test;
v_id = y_test;

%S1.计算特征
% load vgg_face
% net = net_c;
% net = alexnet;
[m_feat,v_id_a,v_cent]  = cluster_imporvingmain_V2(net,m_data,v_id,n_clsnum);
% net = resnet101;
% [m_feat,v_id_a,v_cent]  = cluster_imporvingmain_V3(net,m_data,v_id,n_clsnum);
% [m_feat,v_id_a,v_cent] = cluster_imporvingmain_V1(m_data,n_clsnum,'o');
% v_id_alex = v_id_a;
% %S2.初始聚类
% [v_cent,v_id_a] = cluster_main.(m_feat,n_clsnum);

v_rate = cluster_eval(v_id,v_id_a);
s = cluster_eval_inner(m_feat,v_id_a,v_cent);

v_ccnid = zeros(1,length(v_id));
v_ccdid = ones(1,length(v_id));
n_iter = 0;
v_ccdcount = length(v_id);

figure;

d_max = s;
grid on;
title('Measuring Results');
xlabel('Sample Rate');
ylabel('Value');
s_legend = {'JC','FMI','RI','CM','NMI','ACC','DBI'};
%初始值
m_allresults = zeros(length(d_rate)+1,7);
m_allresults(1,:) = [v_rate(1:end),s/d_max];
v_samplerate = zeros(length(d_rate)+1,1);


for i = 1:7
   plot(v_samplerate(1),m_allresults(1,i),'-*','Color',rand(3,1));hold on;
end
grid on
legend(s_legend);
net = alexnet;
while 1
    %满足聚类中心距离阈值的数据集
    v_k = db_calcenter_dist(m_feat,v_cent,v_id_a,d_distrate);
    
    %已经同类的做好标签
    v_ccnid(v_k == 1) = 1;
    v_ccdid(v_k == 1) = 0;

    v_ccdcount = sum(v_ccdid);
    x_data = m_data(:,:,:,v_ccnid == 1);
    y_data = v_id_a(v_ccnid == 1);
    %fine-tuning ccn数据集
%     net = db_caffe_pro_ccn_v2(m_data,v_id_a,net);
    net = db_caffe_pro_ccn_v2(x_data,y_data,net);
    %S5.聚类优化
    [m_feat,v_id_a,v_cent]  = cluster_imporvingmain_V2(net,m_data,v_id_a,n_clsnum);
    
    d_rate_p = cluster_eval(v_id,v_id_a);
    s_p = cluster_eval_inner(m_feat,v_id_a);
    
    n_iter = n_iter +1;
    d_distrate = d_distrate + d_delta;
    m_allresults(n_iter+1,:) = [d_rate_p(1:end),s_p/d_max];
    
    v_samplerate(n_iter+1) = d_rate(n_iter);
    for j = 1:7
        plot(v_samplerate(1:n_iter+1),m_allresults(1:n_iter+1,j),'-*','Color',rand(3,1));hold on;
    end
    grid on
    legend(s_legend);
    pause(0.04);
    if d_distrate>1
        break;
    end
%     if n_iter == 10
%         break;
%     end
end

% 
% d_distrate = 0.3;%归一化特征与中心平均几何距离在0.25以内
% d_delta = 0.1;
% d_rate = d_distrate:d_delta:1;
% figure;
% 
% grid on;
% title('Measuring Results');
% xlabel('Sample Rate');
% ylabel('Value');
% s_legend = {'JC','FMI','RI','CM','NMI','ACC','DBI'};
% %初始值
% m_allresults_2 = zeros(length(d_rate)+1,7);
% m_allresults_2(1,:) = [v_rate(1:end),s/d_max];
% v_samplerate = zeros(length(d_rate)+1,1);
% 
% n_iter = 0;
% for i = 1:7
%    plot(v_samplerate(1),m_allresults_2(1,i),'-*','Color',rand(3,1));hold on;
% end
% grid on
% legend(s_legend);
% net = alexnet;
% v_id_a = v_id_alex;
% while 1
%     %满足聚类中心距离阈值的数据集
%     v_k = db_calcenter_dist(m_feat,v_cent,v_id_a,d_distrate);
%     
%     %已经同类的做好标签
%     v_ccnid(v_k == 1) = 1;
%     v_ccdid(v_k == 1) = 0;
% 
%     v_ccdcount = sum(v_ccdid);
%     x_data = m_data(:,:,:,v_ccnid == 1);
%     y_data = v_id_a(v_ccnid == 1);
%     %fine-tuning ccn数据集
%     net = db_caffe_pro_ccn_v2(m_data,v_id_a,net);
% %     net = db_caffe_pro_ccn_v2(x_data,y_data,net);
%     %S5.聚类优化
%     [m_feat,v_id_a,v_cent]  = cluster_imporvingmain_V2(net,m_data,v_id_a,n_clsnum);
%     
%     d_rate_p = cluster_eval(v_id,v_id_a);
%     s_p = cluster_eval_inner(m_feat,v_id_a);
%     
%     n_iter = n_iter +1;
%     d_distrate = d_distrate + d_delta;
%     m_allresults_2(n_iter+1,:) = [d_rate_p(1:end),s_p/d_max];
%     
%     v_samplerate(n_iter+1) = d_rate(n_iter);
%     for j = 1:7
%         plot(v_samplerate(1:n_iter+1),m_allresults_2(1:n_iter+1,j),'-*','Color',rand(3,1));hold on;
%     end
%     grid on
%     legend(s_legend);
%     pause(0.04);
%     if d_distrate>1
%         break;
%     end
% %     if n_iter == 10
% %         break;
% %     end
% end
% 
% 





