function m_feat = computeHOG(x_data)

n_setf = 4356;
m_feat = zeros(n_setf,size(x_data,4));

%数据初始化
for i = 1:size(x_data,4)
    g_img = x_data(:,:,:,i);
    if ndims(g_img) == 3
        g_img =rgb2gray(g_img);
    end
    g_img = im2double(g_img);
    g_img = imresize(g_img,[100,100]);
    [v_f,v_p] = extractHOGFeatures(g_img);
    
    m_feat(:,i) = double(v_f');
end
