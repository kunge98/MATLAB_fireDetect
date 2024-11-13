%%  ����hsv�Ļ��ּ��
tic
img= imread('test2.jpg');
figure 
imshow(img);
img=imresize(img,[240,320]);
% title('ԭͼ');
[M,N,C]=size(img);
hsv=rgb2hsv(img);
h=hsv(:,:,1);
s=hsv(:,:,2);
v=hsv(:,:,3);
[row,col]=find((h>11/12 | h<1/12) & v>0.4);
I_bw=zeros(M,N);
leg=length(row);
for i=1:leg
     I_bw(row(i),col(i))=1;
end
% figure
% imshow(I_bw);
% title('�ָ�Ķ�ֵͼ');



figure
imshow(img);
title('���ּ��');
hold on
STATS = regionprops(I_bw,'basic');
for i=1:length(STATS)
    
       % ���
       rectangle('Position',STATS(i).BoundingBox,'EdgeColor','g','LineWidth',4); 
    
end
hold off
toc