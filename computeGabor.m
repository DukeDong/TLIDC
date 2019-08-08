function m_feat = computeGabor(x_data)

n_setf = 100*100;
m_feat = zeros(n_setf,size(x_data,4));

%数据初始化
for i = 1:size(x_data,4)
    g_img = x_data(:,:,:,i);
    if ndims(g_img) == 3
        g_img =rgb2gray(g_img);
    end
    g_img = im2double(g_img);
    g_img = imresize(g_img,[100,100]);
    [G,GABOUT]=gaborfilter(g_img,0.15,5,1.0,0);
    
    m_feat(:,i) = abs(GABOUT(:));
end
