clear,clc,close all
%% 基于图像局部特征的火灾检测算法实现
%% 核心LBP算法的火灾检测
% tic
% ji=zeros(1,100);
% jishu=0;
% picnum=100;
% for j=1:picnum
%     img_filename=sprintf('testpic1\\%d.jpg',j);
%     fprintf('获取测试图库第%d 张图\n',j);
%     img=imread(img_filename);
%     obj=imresize(img,[240,320]);
%% 获取检测图

fileName = '晚霞.jpg';  
obj = imread(fileName);  
%% 图像获取部分
I= obj;
I=imresize(I,[240,320]); %统一尺寸
[M,N,C]=size(I);
figure
imshow(I);
title('原图');
% HSV颜色分割部分
hsv=rgb2hsv(I);
figure 
imshow(hsv);
title('HSV');
h=hsv(:,:,1);
s=hsv(:,:,2);
v=hsv(:,:,3);
figure;imshow(h);title('H分量')
figure;imshow(s);title('S分量')
figure;imshow(v);title('V分量')
[row,col]=find((h>11/12 | h<1/12) & v>0.4);
I_bw=zeros(M,N);
leg=length(row);
for i=1:leg

     I_bw(row(i),col(i))=1;
     
end
I_bw=im2bw(I_bw);
figure
imshow(I_bw);
title('hsv分割的二值图');
% 形态学部分
% 设置去噪参数
set_area=400;
I_bw=bwareaopen(I_bw,set_area);
figure
imshow(I_bw);
title('去除小面积');
% 腐蚀
SE=ones(3);
I_bw=imerode(I_bw,SE);
figure
imshow(I_bw);
title('腐蚀');
% 填充
I_bw=imfill(I_bw,'holes');
I_bw=bwareaopen(I_bw,set_area);
figure
imshow(I_bw);
title('填充');
%  圆形度部分
  [lab,n]= bwlabel(I_bw);%对各连通域进行标记  是从上到下，从左到右的顺序。
    stats1 = regionprops(lab,'Area');    %求各连通域的面积 
    stats2 = regionprops(lab,'Perimeter');    %求各连通域的周长
    stats1=struct2cell(stats1);
    stats1=cell2mat(stats1);
    stats2=struct2cell(stats2);
    stats2=cell2mat(stats2);
    Circularity=zeros(n,1);
  
  for k=1:n 
    Circularity(k)=(4*pi*stats1(k))/(stats2(k)^2);
      if Circularity(k)>0.6
         [cols,rows]=find(lab==k);
         leg=length(rows);
         for t=1:leg
          lab(cols(t),rows(t))=0;
         end 
      end
  end
  I_bw=lab;
figure 
imshow(I_bw)
title('圆形度过滤')
% LBP局部描述子部分
load LBPfeature
% 获取图片数，database_pic
[database_pic,N]=size(LBPfeature);

I=double(I);
I_bw=double(I_bw);
I_res_r=I_bw.*I(:,:,1);
I_res_g=I_bw.*I(:,:,2);
I_res_b=I_bw.*I(:,:,3);
I_res(:,:,1)=I_res_r;
I_res(:,:,2)=I_res_g;
I_res(:,:,3)=I_res_b; 
I_res=uint8(I_res);
I_res1=I_res;
figure
imshow(I_res);
title('待检测图像');

SP=[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1];

[size_M,size_N,size_C]=size(I_res);

if size_C>1
    I_res=rgb2gray(I_res);
end
fprintf('正在计算图片的纹理特征...\n');

[Feature_texure]=lbp(I_res,SP,0,'nh');   %直方图均衡化后
Feature=[Feature_texure];
I2=lbp(I_res,SP,0,'i'); %LBP code image using sampling points in SP
%                           and no mapping. Now H2 is equal to histogram of I2.
figure, imshow(I2);title('纹理图');
H2=lbp(I_res);
figure;
subplot(1,1,1),stem(H2);
title('纹理灰度直方图')
% LBP&欧式距离计算
fprintf('与数据库进行距离计算...\n');
dist=zeros(1,database_pic);
for m=1:database_pic
    
%     dist(i)=sum(abs(mydatabase(i,:)-Feature));     
 dist(m)=sqrt(  sum(  (LBPfeature(m,:)-Feature).^2   )  );  %欧式距离

end
% 设置阈值判断部分

[content,index]=sort(dist);
fprintf('欧式距离越小越相似\n')
fprintf('欧式距离最大为\n')
disp(content(200))
fprintf('欧式距离最小为\n')
disp(content(1))
a=mean(content);
% 判断识别逻辑
if ( content(1)<0.06)
    recog_res=1;
%     jishu=jishu+1;
%     fprintf('标记火灾区域\n')
%     if j<=70
%     ji(j)=j;
%     end
 
else
    recog_res=0;
%     if j>70
%         ji(j)=j;
%     end
end
% zon=find(ji~=0);
% 标出火灾部分
I=uint8(I);
I_bw=im2bw(I_bw);
figure
imshow(I);
title('火灾检测');
hold on
STATS = regionprops(I_bw,'basic');
% 标定每个对象
for i=1:length(STATS)
    if recog_res==1
       rectangle('Position',STATS(i).BoundingBox,'EdgeColor','g','LineWidth',4); 
    end
end
hold off


% end
% toc



