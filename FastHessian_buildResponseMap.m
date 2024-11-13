function responseMap=FastHessian_buildResponseMap(FastHessianData)%����������Ľṹ
%�������顢�㣨5��4�㣩
%9,  15, 21, 27ÿ��ͼ���С
%15, 27, 39, 51
%27, 51, 75, 99
%51, 99, 147,195
%99, 195,291,387
responseMap=[]; j=0;
%��ȡͼ�������
w = (size(FastHessianData.img,2) / FastHessianData.init_sample);
h = (size(FastHessianData.img,1)/ FastHessianData.init_sample);
s = (FastHessianData.init_sample);
% ������Ƶ�Hession����ֵ
if (FastHessianData.octaves >= 1)
    j=j+1; responseMap{j}=FastHessian_ResponseLayer(w,   h,   s,   9);
    j=j+1; responseMap{j}=FastHessian_ResponseLayer(w, h, s, 15);
    j=j+1; responseMap{j}=FastHessian_ResponseLayer(w, h, s, 21);
    j=j+1; responseMap{j}=FastHessian_ResponseLayer(w, h, s, 27);
end

if (FastHessianData.octaves >= 2)
    j=j+1; responseMap{j}=FastHessian_ResponseLayer(w / 2, h / 2, s * 2, 39);
    j=j+1; responseMap{j}=FastHessian_ResponseLayer(w / 2, h / 2, s * 2, 51);
end

if (FastHessianData.octaves >= 3)
    j=j+1; responseMap{j}=FastHessian_ResponseLayer(w / 4, h / 4, s * 4, 75);
    j=j+1; responseMap{j}=FastHessian_ResponseLayer(w / 4, h / 4, s * 4, 99);
end

if (FastHessianData.octaves >= 4)
    j=j+1; responseMap{j}=FastHessian_ResponseLayer(w / 8, h / 8, s * 8, 147);
    j=j+1; responseMap{j}=FastHessian_ResponseLayer(w / 8, h / 8, s * 8, 195);
end

if (FastHessianData.octaves >= 5)
    j=j+1; responseMap{j}=FastHessian_ResponseLayer(w / 16, h / 16, s * 16, 291);
    j=j+1; responseMap{j}=FastHessian_ResponseLayer(w / 16, h / 16, s * 16, 387);
end
%�ó�ͼ��������Ӧֵ
for i=1:length(responseMap);
    responseMap{i}=FastHessian_buildResponseLayer(responseMap{i},FastHessianData);
end


