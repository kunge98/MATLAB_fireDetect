function [] = drawFeatures( img, loc )
% ����ɸѡ������
figure;
imshow(img);
hold on;
plot(loc(:,2),loc(:,1),'+g');
end