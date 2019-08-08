function [m_data,v_id] = db_gainid_q(st_imglst,n_maxnum)

n_seth = 224;
n_setw = 224;

s_allpath = unique({st_imglst.s_path;});

if length(s_allpath)>n_maxnum
    v_rid = randperm(length(s_allpath));
    v_rid = v_rid(1:n_maxnum);
    s_tmppath = s_allpath(v_rid);
    st_tmplst = [];
    for i = 1:length(st_imglst)
        m_id = strcmp(s_allpath,st_imglst(i).s_path);
        n_id = find(m_id == 1);
        n_flag = find(v_rid == n_id);
        
        if isempty(n_flag)
            continue;
        end
        st_tmplst = [st_tmplst;st_imglst(i)];
    end
    st_imglst = st_tmplst;
    s_allpath = s_tmppath;
end

v_id = zeros(length(st_imglst),1);
m_data = zeros(n_seth,n_setw,3,length(st_imglst));
for i = 1:length(st_imglst)
    m_id = strcmp(s_allpath,st_imglst(i).s_path);
    n_id = find(m_id == 1);
    v_id(i) = n_id;
    g_img = imread(fullfile(st_imglst(i).s_path,st_imglst(i).s_name));
    if ndims(g_img) == 2
        g_img = cat(3,g_img,g_img,g_img);
    end
    g_img = double(imresize(g_img,[n_seth,n_setw]));
    for j = 1:3
        v_mean = mean(mean(g_img(:,:,j)));
        g_img(:,:,j) = g_img(:,:,j) - v_mean;
    end
    m_data(:,:,:,i) = g_img;
    
    db_showprocess(i,length(st_imglst));
end
    

