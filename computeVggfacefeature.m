%This function can
%1. Compute outputs of fc7 in Vgg Face[1] fed by m_data, which size is M*N*C*D. 
%   M:rows,N:cols,C:channels,D:number of images.
%   The computed outputs are returned by m_feat, which size is 4096*D.
%[1].O. M. Parkhi, A. Vedaldi, A. Zisserman. 
% Deep Face Recognition. British Machine Vision Conference, 2015.
%---------Duke Dong (dukedong@dlmu.edu.cn)
%---------Information Science and Technology Department
%---------DLMU 

function m_feat_n = computeVggfacefeature(m_data)

%make sure deep learning toolbox has been setup in Matlab
%vggface can be imported as models trained by caffe\kera using
%importCaffeLayers\importKerasLayers
load vgg_face.mat
st_net = net_c;

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