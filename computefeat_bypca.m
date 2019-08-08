function m_feat = computefeat_bypca(x_data)

n_seth = 100;
data = zeros(n_seth*n_seth,size(x_data,4));

%数据初始化
for i = 1:size(x_data,4)
    g_img = x_data(:,:,:,i);
    if ndims(g_img) == 3
        g_img =rgb2gray(g_img);
    end
    g_img = im2double(g_img);
    g_img = imresize(g_img,[n_seth,n_seth]);
    
    data(:,i) = reshape(g_img,n_seth*n_seth,1);
end

%计算均值
v_mean = mean(data')';
m_mean = repmat(v_mean,1,size(x_data,4));
data = data - m_mean;

%PCA
L = data'*data;
[eigVecs, eigVals] = eig(L);

diagonal = diag(eigVals);
[diagonal, index] = sort(diagonal);
index = flipud(index);
 
pcaEigVals = zeros(size(eigVals));
pcaEigVecs = zeros(length(eigVecs(:,1)),size(eigVals,1));
for i = 1 : size(eigVals, 1)
    pcaEigVals(i, i) = eigVals(index(i), index(i));
    pcaEigVecs(:, i) = eigVecs(:, index(i));
end;
dim = min([size(x_data,4),5000]);
pcaEigVals = diag(pcaEigVals);
pcaEigVals = pcaEigVals / (dim-1);
pcaEigVals = pcaEigVals(1 : (dim-1));        % Retaining only the largest subDim ones

pcaEigVecs = data * pcaEigVecs;    % Turk-Pentland trick (part 2)

for i = 1 : dim
    pcaEigVecs(:, i) = pcaEigVecs(:, i) / norm(pcaEigVecs(:, i));
end;
w = pcaEigVecs(:, 1:(dim-1));
m_feat = w'*data;