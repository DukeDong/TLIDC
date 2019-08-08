%This function can
%Compute external indexes of v_id,v_id_c. 
%   v_id:labels with a size of D*1,D:image number
%   v_id_c:labels with a size of D*1.
%External indexes including:
%   Jaccard Coefficient (JC)
%   Fowlkes and Mallows Index (FMI) 
%   Normalized Mutual Information (NMI)
%   Clustering Accuracy (ACC) 
%   Adjusted Rand Index (ARI)
%Computed indexes are returned in a vector£º
%   v_index = [JC,FMI,NMI,ACC,ARI]
%---------Duke Dong (dukedong@dlmu.edu.cn)
%---------Information Science and Technology Department
%---------DLMU 

function v_index = cluster_eval(v_id,v_id_c)

n_ss = 0;
n_sd = 0;
n_ds = 0;
n_dd = 0;

for i = 1:length(v_id)
    for j = i+1:length(v_id)
        if (v_id(i) == v_id(j))&&(v_id_c(i) == v_id_c(j))
            n_ss = n_ss +1;
        elseif (v_id(i) == v_id(j))&&(v_id_c(i) ~= v_id_c(j))
            n_sd = n_sd +1;
        elseif (v_id(i) ~= v_id(j))&&(v_id_c(i) == v_id_c(j))
            n_ds = n_ds +1;
        else
            n_dd = n_dd +1;
        end
    end
end

JC = n_ss/(n_ss+n_sd+n_ds);
FMI = sqrt(n_ss/(n_ss+n_sd)*n_ss/(n_ss+n_ds));
ACC = db_acc(v_id,v_id_c);
ARI = rand_index(v_id,v_id_c,'adjusted');
NMI = nmi(v_id,v_id_c);

v_index = [JC,FMI,NMI,ARI,ACC];