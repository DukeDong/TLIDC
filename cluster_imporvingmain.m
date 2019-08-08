function [m_feat_n,v_p_id,v_cent] = cluster_imporvingmain(st_net,x_train,y_train,n_clsnum)

inputSize = st_net.Layers(1).InputSize;
n_num = size(x_train,4);
n_start = 1;
n_batch = 20;

m_feat_n = zeros(4096,n_num);

while 1
    n_end = n_start + n_batch -1;
    
    if n_end > n_num
        n_end = n_num;
    end
    
    x_batch = x_train(:,:,:,n_start:n_end);
    y_batch = y_train(n_start:n_end);
    augimdsTrain = augmentedImageDatastore(inputSize,x_batch,y_batch-1);
    
    m_feat_v = activations(st_net,augimdsTrain,'fc7','OutputAs','columns');
    m_feat_n(:,n_start:n_end) = m_feat_v;
    n_start = n_start + n_batch;
    
    if n_start > n_num
        break;
    end
    db_showprocess(n_start,n_num);
end
[v_p_id,v_cent] = kmeans((m_feat_n'),n_clsnum);