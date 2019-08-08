function s = cluster_eval_inner(m_feat,v_id,v_cent)

if ~exist('v_cent','var')
    v_cent = zeros(max(v_id),size(m_feat,1));
    for i = 1:max(v_id)
        v_tmpid = v_id == i;
        m_partfeat = m_feat(:,v_tmpid);
        v_cent(i,:) = mean(m_partfeat');
    end
end

n_id_num = max(v_id);

v_avg_c = zeros(n_id_num,1);%averaged distance with same clusters
v_avg_min = zeros(n_id_num,1);%minimum distance with same clusters
v_avg_max = zeros(n_id_num,1);%maximum distance with same clusters

m_dcent = zeros(n_id_num,n_id_num);

for i = 1:n_id_num
    v_id_s = v_id == i;
        
    m_part_feat = m_feat(:,v_id_s);
    
    d_c_dist = 0;
    d_maxdist = -inf;
    d_mindist = inf;
    
    for j = 1:size(m_part_feat,2)
        v_xj = m_part_feat(:,j);
        for k = 1:size(m_part_feat,2)
            if j == k
                continue;
            end
            v_xk = m_part_feat(:,k);
            d_dist = sqrt(sum((v_xj - v_xk).^2));
            d_c_dist = d_c_dist + d_dist;
            if d_dist > d_maxdist
                d_maxdist = d_dist;
            end
            
            if d_dist < d_mindist
                d_mindist = d_dist;
            end
        end
    end
    if size(m_part_feat,2) == 0
        v_avg_c(i) = -1;
        v_avg_min(i) = -1;
        v_avg_max(i) = -1;
    else
        v_avg_c(i) = d_c_dist/size(m_part_feat,2);
        v_avg_min(i) = d_mindist;
        v_avg_max(i) = d_maxdist;
    end

    for j = 1:n_id_num
        if i == j
            continue;
        end
        
        d_dist = sqrt(sum((v_cent(i,:) - v_cent(j,:)).^2));
        m_dcent(i,j) = d_dist;
    end
end

v_chck_id = v_avg_c == -1;
v_avg_c(v_chck_id) = mean(v_avg_c(~v_chck_id));
v_avg_min(v_chck_id) = max(v_avg_min(~v_chck_id));
v_avg_max(v_chck_id) = min(v_avg_max(~v_chck_id));

d_DBI = 0;
for i = 1:n_id_num
    d_dbi_sigmax = -inf;
    for j = 1:n_id_num
        if i == j
            continue;
        end
        if isnan(m_dcent(i,j))
            d_rate = -1;
        else
            d_rate = (v_avg_c(i)+v_avg_c(j))/m_dcent(i,j);
        end
        if d_rate > d_dbi_sigmax
            d_dbi_sigmax = d_rate;
        end
    end
    d_DBI = d_DBI + d_dbi_sigmax;
end

s = d_DBI/n_id_num;








