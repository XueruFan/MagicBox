function [pos, neg] = xueru_sm_decompose(A)
%  提取出一个矩阵的+-值子图
pos = A; neg = A;
pos (pos < 0) = 0;            
neg (neg > 0) = 0;
end