%This function can
%1. Compute outputs of fc7 in Alexnet[1] fed by m_data, which size is M*N*C*D. 
%   M:rows,N:cols,C:channels,D:number of images.
%   The computed outputs are returned by m_feat, which size is 4096*D.
%[1].Krizhevsky A., Sutskever I., Hinton G. E., 2012. 
%ImageNet classification with deep convolutional neural networks. 
%International Conference on Neural Information Processing Systems.
%---------Duke Dong (dukedong@dlmu.edu.cn)
%---------Information Science and Technology Department
%---------DLMU 

function m_feat_n = computeAlexnetfeature(m_data)

%make sure deep learning toolbox has been setup in Matlab
%alexnet can be imported by installing AlexNet Network support package
%or it can be imported as models trained by caffe\kera using
%importCaffeLayers\importKerasLayers
st_net = alexnet;

inputSize = st_net.Layers(1).InputSize;
n_num = size(m_data,4);

%to avoid out of memory errors 
n_start = 1;
n_batch = 20; %Batch Size

m_feat_n = zeros(4096,n_num);

while 1
    n_end = n_start + n_batch -1;
    
    if n_end > n_num
        n_end = n_num;
    end
    
    x_batch = m_data(:,:,:,n_start:n_end);
    y_batch = ones(n_batch,1);
    augimds_c = augmentedImageDatastore(inputSize,x_batch,y_batch-1);
    
    m_feat_v = activations(st_net,augimds_c,'fc7','OutputAs','columns');
    m_feat_n(:,n_start:n_end) = m_feat_v;
    n_start = n_start + n_batch;
    
    if n_start > n_num
        break;
    end
    db_showprocess(n_start,n_num);
end