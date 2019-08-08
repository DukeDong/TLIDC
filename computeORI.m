function m_feat = computeORI(x_data)

n_setf = 28*28;
m_feat = zeros(n_setf,size(x_data,4));

%数据初始化
for i = 1:size(x_data,4)
    g_img = x_data(:,:,:,i);
    if ndims(g_img) == 3
        g_img =rgb2gray(g_img);
    end
    g_img = im2double(imresize(g_img,[28,28]));
    m_feat(:,i) = double(g_img(:));
end
