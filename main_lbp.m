clear,clc,close all
%% ����ͼ��ֲ������Ļ��ּ���㷨ʵ��
%% ����LBP�㷨�Ļ��ּ��
% tic
% ji=zeros(1,100);
% jishu=0;
% picnum=100;
% for j=1:picnum
%     img_filename=sprintf('testpic1\\%d.jpg',j);
%     fprintf('��ȡ����ͼ���%d ��ͼ\n',j);
%     img=imread(img_filename);
%     obj=imresize(img,[240,320]);
%% ��ȡ���ͼ

fileName = '��ϼ.jpg';  
obj = imread(fileName);  
%% ͼ���ȡ����
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
figure;imshow(h);title('H����')
figure;imshow(s);title('S����')
figure;imshow(v);title('V����')
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
% ����ȥ�����
set_area=400;
I_bw=bwareaopen(I_bw,set_area);
figure
imshow(I_bw);
title('ȥ��С���');
% ��ʴ
SE=ones(3);
I_bw=imerode(I_bw,SE);
figure
imshow(I_bw);
title('��ʴ');
% ���
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
% LBP�ֲ������Ӳ���
load LBPfeature
% ��ȡͼƬ����database_pic
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
title('�����ͼ��');

SP=[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1];

[size_M,size_N,size_C]=size(I_res);

if size_C>1
    I_res=rgb2gray(I_res);
end
fprintf('���ڼ���ͼƬ����������...\n');

[Feature_texure]=lbp(I_res,SP,0,'nh');   %ֱ��ͼ���⻯��
Feature=[Feature_texure];
I2=lbp(I_res,SP,0,'i'); %LBP code image using sampling points in SP
%                           and no mapping. Now H2 is equal to histogram of I2.
figure, imshow(I2);title('����ͼ');
H2=lbp(I_res);
figure;
subplot(1,1,1),stem(H2);
title('����Ҷ�ֱ��ͼ')
% LBP&ŷʽ�������
fprintf('�����ݿ���о������...\n');
dist=zeros(1,database_pic);
for m=1:database_pic
    
%     dist(i)=sum(abs(mydatabase(i,:)-Feature));     
 dist(m)=sqrt(  sum(  (LBPfeature(m,:)-Feature).^2   )  );  %ŷʽ����

end
% ������ֵ�жϲ���

[content,index]=sort(dist);
fprintf('ŷʽ����ԽСԽ����\n')
fprintf('ŷʽ�������Ϊ\n')
disp(content(200))
fprintf('ŷʽ������СΪ\n')
disp(content(1))
a=mean(content);
% �ж�ʶ���߼�
if ( content(1)<0.06)
    recog_res=1;
%     jishu=jishu+1;
%     fprintf('��ǻ�������\n')
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
% ������ֲ���
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



