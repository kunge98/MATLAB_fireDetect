function [] = drawFeatures( img, loc )
% 绘制筛选特征点
figure;
imshow(img);
hold on;
plot(loc(:,2),loc(:,1),'+g');
end