%---------Duke Dong (dukedong@dlmu.edu.cn)
%---------Information Science and Technology Department
%---------DLMU 
%Marco Commmands
clear all          %to clear memory 
db_globalcommands();%to clear the command window and close all figure

s_trainfile = './MNIST/train-images.idx3-ubyte';
s_trainlabel = './MNIST/train-labels.idx1-ubyte';
s_testfile = './MNIST/t10k-images.idx3-ubyte';
s_testlabel = './MNIST/t10k-labels.idx1-ubyte';

x_train = loadMNISTImages(s_trainfile);
y_train = (loadMNISTLabels(s_trainlabel));
x_test = loadMNISTImages(s_testfile);
y_test = (loadMNISTLabels(s_testlabel));

%parameters for TLIDC
n_clsnum = 10;      %Cluster Number
d_delta1 = 0.5;     %жд in TLIDC
d_delta2 = 0.1;     %ж─ in TLIDC

%feature types including:
%Handcraft features:'h':hog;'g':gabor;'p':pca;'o',gray level
%Deep features:'a':alexnet-fc7;'v':vggface-fc7;'r':resnet101-fc101
s_feat_type = 'h';

%implies every iteration
v_rate = d_delta1:d_delta2:1;

m_data = x_train;
v_id = y_train;

%S1.Compute boot features and initial pseudo labels by K-means for TLIDC
[m_feat,v_id_a,v_cent] = db_bootstage(m_data,n_clsnum,s_feat_type);

%evaluation for the initial results
v_init_external = cluster_eval(v_id,v_id_a);
v_init_internal = cluster_eval_inner(m_feat,v_id_a,v_cent);

%to store results of every iteration
m_allresults = zeros(length(v_rate)+1,6);
m_allresults(1,:) = [v_init_external,v_init_internal];

%S2.Initialize parameters in the operate stage
v_ccnid = zeros(1,length(st_imglst));  %to store CCN indexes in every iteration
v_ccdid = ones(1,length(st_imglst));   %to store CCD indexes in every iteration
n_iter = 1;                            %the iteration count
v_ccdcount = length(st_imglst);        %the element count of CCD

%plot all results in one figure;
figure;
title('Measuring Results');
xlabel('Sample Rate');
ylabel('Value');
s_legend = {'JC','FMI','NMI','ARI','ACC'}; %Indexes for clustering evaluation
v_color = rand(length(v_rate)+1,3);
for i = 1:5
   plot(0,m_allresults(1,i),'-*','Color',v_color(i,:));hold on;
end
grid on
legend(s_legend);

%make sure deep learning toolbox has been setup in Matlab
%alexnet can be imported by installing AlexNet Network support package
%or it can be imported as models trained by caffe\kera using
%importCaffeLayers\importKerasLayers
net = alexnet;
d_max_index = v_init_internal;
net_o = net;

%start the iterative process
while 1
    %S2.1 to choose reliabel 
    v_k = db_calcenter_dist(m_feat,v_cent,v_id_a,d_delta1);
    
    %S2.2 to confirm the CCN flags
    v_ccnid(v_k == 1) = 1;
    v_ccdid(v_k == 1) = 0;

    %S2.3 to sample the CCN data
    v_ccdcount = sum(v_ccdid);
    x_data = m_data(:,:,:,v_ccnid == 1);
    y_data = v_id_a(v_ccnid == 1);
    
    %S2.4 fine-tuning based on ccn
    net = db_transferlearning_core(x_data,y_data,net);
    
    %S2.5 predict the new labels
    [m_feat,v_id_a,v_cent]  = cluster_imporvingmain(net,m_data,v_id_a,n_clsnum);
    
    %S2.6 evaluation for the optimized results
    v_ext_index_o = cluster_eval(v_id,v_id_a);
    v_int_index_o = cluster_eval_inner(m_feat,v_id_a);
    
    if v_int_index_o<d_max_index
        d_max_index = v_int_index_o;
        net_o = net;
    end
    m_allresults(n_iter+1,:) = [v_ext_index_o,v_int_index_o];
    
    %S2.7 update the parameters
    n_iter = n_iter +1;
    d_delta1 = d_delta1 + d_delta2;
    
    %S2.8 plot all results in the figure
    for j = 1:5
        plot([0,v_rate(1:n_iter-1)],m_allresults(1:n_iter,j),'-*','Color',v_color(j,:));hold on;
    end
    grid on
    legend(s_legend);
    pause(0.04);
    
    %S2.9 break while all images are beileved belonging to CCN
    if d_delta1>1
        break;
    end
end

save('result.mat','m_allresults');
