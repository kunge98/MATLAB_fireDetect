clear
clc
close all



%% ʶ��������

%% ��ȡ��Ƶ

% ��ȡ����Ƶ�ļ�����
fileName = 'forest2.avi';  

% ��ȡ��Ƶ
obj = VideoReader(fileName);  

% ��ȡ��Ƶ����
numFrames = obj.NumFrames;
Framerate=obj.FrameRate; 
Height=obj.Height;
Width=obj.Width;


%% ʶ����沿��

%% �������ݿ�

load mydatabase
% ��ȡͼƬ����database_pic
[database_pic,N]=size(mydatabase);

% ����Ƶ֡����
for i=1:numFrames

    % ��ȡ��Ƶ֡
    I = read(obj,i);
    
    % ��ȡ�ߴ�
    [M,N,C]=size(I);

  %% HSV��ɫ�ָ��

    % ԭͼ��ת��ΪHSVģ��
    hsv=rgb2hsv(I);

    % �ֱ��ȡH��S��V����
    h=hsv(:,:,1);
    s=hsv(:,:,2);
    v=hsv(:,:,3);

    %% HSV�ָ�

    % ����H V�������ҳ���ɫ��������������
    [row,col]=find((h>11/12 | h<1/12) & v>0.4);


    % ��ֵͼ�����ҳ��������ر�ɰ�ɫ
    I_bw=zeros(M,N);
    leg=length(row);
    for j=1:leg

         I_bw(row(j),col(j))=1;

    end

    % ��ʾ�ָ�Ķ�ֵͼ
    I_bw=im2bw(I_bw);


    %% ��̬ѧ����

    % ����ȥ�����
    set_area=500;
    % ȥ��
    I_bw=bwareaopen(I_bw,set_area);

    % ��ʴ����,����10
    SE=ones(3);
    I_bw=imerode(I_bw,SE);

    % ���
    I_bw=imfill(I_bw,'holes');

    % ����ȥ�����
    set_area=300;
    % ȥ��
    I_bw=bwareaopen(I_bw,set_area);

%%  Բ�ζȲ���

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

    %% HSV����ʶ��

    %% ��ȡͼƬ����

    % ��ȡ����ͼ��
    I=double(I);
    I_bw=double(I_bw);
    I_res_r=I_bw.*I(:,:,1);
    I_res_g=I_bw.*I(:,:,2);
    I_res_b=I_bw.*I(:,:,3);
    I_res(:,:,1)=I_res_r;
    I_res(:,:,2)=I_res_g;
    I_res(:,:,3)=I_res_b;

    I_res=uint8(I_res);

    % ��������
    SP=[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1];

    % ��ȡ�ߴ�
    [size_M,size_N,size_C]=size(I_res);

    % ת�Ҷ�ͼ
    if size_C>1
        I_res=rgb2gray(I_res);
    end

    fprintf('���ڼ���ͼƬ������...\n');
    % ����LBP����
    [Feature_texure]=lbp(I_res,SP,0,'nh'); 
    % ����
    Feature=(Feature_texure);
 
    %% ������㲿��
    fprintf('�����ݿ���бȶ�ʶ��...\n');
    dist=zeros(1,database_pic);
    for j=1:database_pic

        dist(j)=sum(abs(mydatabase(j,:)-Feature));   
    end

    %% ����,����жϲ���

    % ��������
    [content,index]=sort(dist);

    % �ж�ʶ���߼�
    if content(1)<0.55
        recog_res=1;
    else
        recog_res=0;
    end

   %% ��λ��ʶ�𲿷�

   I=uint8(I);
   I_bw=im2bw(I_bw);

    % ��ʾ
    imshow(I);
    hold on

    % ��λ�ͱ궨
    STATS = regionprops(I_bw,'basic');

    % �궨ÿ������
    for j=1:length(STATS)
        
         if recog_res==1
            % ���
            rectangle('Position',STATS(j).BoundingBox,'EdgeColor','g','LineWidth',4); 
         end
    end
    
    % ��ʾ֡���
    hold on;
    text(5, 18, strcat('#',num2str(i)), 'Color','y', 'FontWeight','bold', 'FontSize',20);
    pause(0.001); 
    hold off;

    
end

fprintf('�������...\n');







