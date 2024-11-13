clear ,clc, close all
%% ����ͼ��ֲ������Ļ��ּ���㷨ʵ��
%% ����SIFT�㷨�Ļ��ּ��
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
 
 fileName = '39.jpg';  
 obj = imread(fileName);  
% ͼ���ȡ����
I= obj;
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

set_area=400;
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
         for t=1:leg
          lab(cols(t),rows(t))=0;
         end 
      end
  end
  I_bw=lab;
figure 
imshow(I_bw)
title('Բ�ζȹ���')
% ����ⲿ��
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
title('�����ͼ��');
% SIFT�ֲ������Ӳ���
img=I_res;
[img1, des1 ,loc1]=sift(I_res);
rlu_num=0;
ed1str=('C:\Users\Administrator\Desktop\���۴���');
imgname= dir([ed1str '\����SIFT������\IMG\*.jpg']);
desname= dir([ed1str '\����SIFT������\DES\*.mat']);
leg=length(imgname);
num=zeros(leg,5000);
sort_index = [];
for j=1:leg

 eval(['load ' ed1str '\����SIFT������\DES\' desname(j).name]);

 des2=descriptors;
   
    distRatio = 0.6;
    des2t = des2';    
    for z = 1 : size(des1,1)
    dotprods = des1(z,:) * des2t;        
    [vals,inds] = sort(acos(dotprods)); 
        if (vals(1) < distRatio * vals(2))
                match(z) = inds(1);
        else
                match(z) = 0;
        end
    end
    num = sum(match>0);   
    if num
       rlu_num=rlu_num+1;
       rlu_list(rlu_num)={[ed1str '\����SIFT������\IMG\' imgname(z).name]};
       sort_index(rlu_num,1)=num;
       sort_index(rlu_num,2)=rlu_num;
    end
end
image=rgb2gray(I_res1);
image = double(image);
keyPoints = sift2(image,3,5,1.3);
image = SIFTKeypointVisualizer(image,keyPoints);
figure
imshow(uint8(image))
title('SIFT����')

rlu_index=sortrows(sort_index,-1);
im2=imread(rlu_list{rlu_index(1,2)});
a=rlu_index(1,1);
fprintf('��ƥ��Ĺ���%d��ƥ���\n',a);

% ������ֵ�жϲ���

if ( a>12)
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
% ��λ���ֲ���
I=uint8(I);
I_bw=im2bw(I_bw);
figure
imshow(I);
title('���ּ��');
hold on
STATS = regionprops(I_bw,'basic');
% �궨ÿ������
for i=1:length(STATS)
    if recog_res==1
       rectangle('Position',STATS(i).BoundingBox,'EdgeColor','g','LineWidth',4); 
    end
end
hold off
% end
% toc

