function d_acc = db_acc(y_pre,y_true)

D = max(max(y_pre), max(y_true))+1;
w = zeros(D,D);
for i = 1:length(y_pre)
    w(y_pre(i),y_true(i)) = w(y_pre(i),y_true(i))+1;    
end

% [v_x,v_y] = linear_sum_assignment(max(w(:))-w);
% v_x = [1;v_x(1:end-1)+1];
[v_y,v_x] = munkres(max(w(:))-w);

d_acc = 0;
for i = 1:length(v_x)
    d_acc = d_acc + w(v_y(i),v_x(i));
end
d_acc = d_acc / length(y_pre);

% for i in range(Y_pred.size):
%     w[Y_pred[i], Y[i]] += 1
%     ind = linear_assignment(w.max() - w)
% return sum([w[i,j] for i,j in ind])*1.0/Y_pred.size,ind




