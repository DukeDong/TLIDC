%According to initialized feature type, this function can
%1. Extract features from m_data, which size is M*N*C*D. 
%   M:rows,N:cols,C:channels,D:number of images.
%   The extracted features are returned by m_feat, which size is L*D.
%   L:dimension of extracted feature for one image
%2. Conduct clustering based on m_feat.
%   Clustering method: k-means
%   Cluster number: n_clsnum>2 and when n_clsnum>100 it requires lots of memory
%   The clustering results are returned by v_id_a,v_cent.
%   v_id_a:the cluster indexes with a size of D*1,v_cent:centers of each
%   cluster with a size of n_clsnum*L
%s_feat_type: handcraft features:'h':hog;'g':gabor;'p':pca;'o',gray level;
%         Deep features:'a':alexnet-fc7;'v':vggface-fc7;'r':resnet101-fc101
%---------Duke Dong (dukedong@dlmu.edu.cn)
%---------Information Science and Technology Department
%---------DLMU 

function [m_feat,v_id_a,v_cent] = db_bootstage(m_data,n_clsnum,s_feat_type)

switch s_feat_type
    case 'h'%hog
        m_feat = computeHOG(m_data);
    case 'g'%gabor
        m_feat = computeGabor(m_data);
    case 'p'%pca
        m_feat = computefeat_bypca(m_data);
    case 'o'%gray pixel
        m_feat = computeORI(m_data);
    case 'a'%alxenet-fc7
        m_feat = computeAlexnetfeature(m_data);
    case 'v'%vggface-fc7
        m_feat = computeVggfacefeature(m_data);
    case 'r'%resnet101-fc101
        m_feat = computeResnetfeature(m_data);
end

[v_id_a,v_cent] = kmeans((m_feat'),n_clsnum);