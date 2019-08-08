function v_k = db_calcenter_dist(m_feat,v_cent,v_id,d_rate)

v_uid = unique(v_id);
n_clsnum = length(v_uid);
v_k = zeros(size(v_id));
for i = 1:n_clsnum
    v_imgid =find(v_id == v_uid(i));
    
    n_num = ceil(length(v_imgid)*d_rate);
    if(n_num <2)
        n_num = 1;
    end
    
    m_ptfeat = m_feat(:,v_imgid);
    m_centmat = repmat(v_cent(i,:)',[1,length(v_imgid)]);
    m_delta= abs(m_ptfeat - m_centmat);
    v_delta = sum(m_delta);
    [v_delta,v_tpid] = sort(v_delta,'ascend');
    v_k(v_imgid(v_tpid(1:n_num))) = 1;
end