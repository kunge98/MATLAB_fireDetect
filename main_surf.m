clear ,clc, close all
%% ����ͼ��ֲ������Ļ��ּ���㷨ʵ��
%% ����SURF�㷨�Ļ��ּ��
% tic
% ji=zeros(1,100);
% jishu=0;
% picnum=100;
% for p=1:picnum
%     img_filename=sprintf('testpic1\\%d.jpg',p);
%     fprintf('��ȡ����ͼ���%d ��ͼ\n',p);
%     img=imread(img_filename);
%     obj=imresize(img,[240,320]);
    
%% ��ȡ���ͼ
% img_filename=sprintf('testpic1\\%d.jpg',89);
img_filename=('1.jpg');
fileName =img_filename ;
obj = imread(fileName);  
% ͼ���ȡ����
I= obj;
% I=imresize(I,[320,480]); %ͳһ�ߴ�
 I=imresize(I,[240,320]); %ͳһ�ߴ�
[M,N,C]=size(I);
figure
imshow(I);
title('ԭͼ');
% HSV��ɫ�ָ��
hsv=rgb2hsv(I);
figure 
imshow(hsv);
title('HSV');
h=hsv(:,:,1);
s=hsv(:,:,2);
v=hsv(:,:,3);
[row,col]=find((h>11/12 | h<1/12) & v>0.4);
I_bw=zeros(M,N);
leg=length(row);
for i=1:leg
     I_bw(row(i),col(i))=1;    
end
I_bw=im2bw(I_bw);
figure
imshow(I_bw);
title('hsv�ָ�Ķ�ֵͼ');
% ��̬ѧ����

set_area=500;
I_bw=bwareaopen(I_bw,set_area);
figure
imshow(I_bw);
title('ȥ��С���');

SE=ones(3);
I_bw=imerode(I_bw,SE);
figure
imshow(I_bw);
title('��ʴ');

I_bw=imfill(I_bw,'holes');
I_bw=bwareaopen(I_bw,set_area);
figure
imshow(I_bw);
title('���');
%  Բ�ζȲ���
  [lab,n]= bwlabel(I_bw);%�Ը���ͨ����б��  �Ǵ��ϵ��£������ҵ�˳��
    stats1 = regionprops(lab,'Area');    %�����ͨ������ 
    stats2 = regionprops(lab,'Perimeter');    %�����ͨ����ܳ�
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
         for j=1:leg
          lab(cols(j),rows(j))=0;
         end 
      end
  end
  I_bw=lab;
figure 
imshow(I_bw)
title('Բ�ζȹ���')
% ����ⲿ��
I1=double(I);
I_bw=double(I_bw);
I_res_r=I_bw.*I1(:,:,1);
I_res_g=I_bw.*I1(:,:,2);
I_res_b=I_bw.*I1(:,:,3);
I_res(:,:,1)=I_res_r;
I_res(:,:,2)=I_res_g;
I_res(:,:,3)=I_res_b; 
I_res=uint8(I_res);
I_res1=I_res;
figure
imshow(I_res);
title('�����ͼ��');
% SURF�ֲ������Ӳ���
img=I_res;
Ipts=OpenSurf(img);
des1=Ipts.descriptor;
des1=reshape([Ipts.descriptor],64,[]); %D1
num=zeros(1,length(des1));
orix= cat(1,Ipts.x);
oriy= cat(1,Ipts.y);
figure
imshow(rgb2gray(img))
title ('SURF����')
hold on
plot(orix,oriy,'*g')
hold off

ed1str=('C:\Users\Administrator\Desktop\���۴���');
imgname= dir([ed1str '\����SURF������\IMG\*.jpg']);
desname= dir([ed1str '\����SURF������\DES\*.mat']);
leg=length(imgname);
n=0;
rlu_num=0;

for j=1:leg
    filedir=('C:\Users\Administrator\Desktop\���۴���\����SURF������\DES\');
    loadpath=strcat(filedir,num2str(j),'.mat');
    des2=load(loadpath); 
    des2=struct2cell(des2);
    des2=cell2mat(des2);
    n=0;
    err=zeros(1,length(des1));
    cor2=zeros(1,length(des1));
 

  for t=1:length(des1)
      a= repmat(des1(:,t),[1 length(des2(1,:))]);% ���ܳ���������������߽�
      distance=sum((des2-a).^2,1);% ��ÿ�����
      [err(t),cor2(t)]=min(distance);
      [err, ind]=sort(err); 
      if max(err)<0.4
         n=n+1;
         num(j)=n;
      end
  end
end
fprintf('��ƥ��Ĺ���%d��ƥ���\n',max(num));
% ������ֵ�жϲ���
a=max(num);
if (a>7)
    recog_res=1;
    fprintf('��ǻ�������\n')
%     if p<=70
%         ji(p)=p;
%     end
else
    recog_res=0;
%     if p>70
%         ji(p)=p;
%     end
end
% zon=find(ji~=0);
%% ������ֲ���
I=uint8(I);
I_bw=im2bw(I_bw);
figure
imshow(I);
title('���ּ��');
hold on
STATS = regionprops(I_bw,'basic');
% �궨ÿ������
for k=1:length(STATS)
    if recog_res==1
       rectangle('Position',STATS(k).BoundingBox,'EdgeColor','g','LineWidth',4); 
    end
end
hold off
% end
% toc
