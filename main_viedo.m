clear
clc
close all



%% 识别主函数

%% 获取视频

% 读取的视频文件名称
fileName = 'forest2.avi';  

% 读取视频
obj = VideoReader(fileName);  

% 获取视频参数
numFrames = obj.NumFrames;
Framerate=obj.FrameRate; 
Height=obj.Height;
Width=obj.Width;


%% 识别火焰部分

%% 载入数据库

load mydatabase
% 获取图片数，database_pic
[database_pic,N]=size(mydatabase);

% 对视频帧处理
for i=1:numFrames

    % 获取视频帧
    I = read(obj,i);
    
    % 获取尺寸
    [M,N,C]=size(I);

  %% HSV颜色分割部分

    % 原图像转换为HSV模型
    hsv=rgb2hsv(I);

    % 分别获取H、S、V分量
    h=hsv(:,:,1);
    s=hsv(:,:,2);
    v=hsv(:,:,3);

    %% HSV分割

    % 根据H V分量，找出红色背景的像素坐标
    [row,col]=find((h>11/12 | h<1/12) & v>0.4);


    % 二值图，将找出来的像素变成白色
    I_bw=zeros(M,N);
    leg=length(row);
    for j=1:leg

         I_bw(row(j),col(j))=1;

    end

    % 显示分割的二值图
    I_bw=im2bw(I_bw);


    %% 形态学部分

    % 设置去噪参数
    set_area=500;
    % 去噪
    I_bw=bwareaopen(I_bw,set_area);

    % 腐蚀操作,参数10
    SE=ones(3);
    I_bw=imerode(I_bw,SE);

    % 填充
    I_bw=imfill(I_bw,'holes');

    % 设置去噪参数
    set_area=300;
    % 去噪
    I_bw=bwareaopen(I_bw,set_area);

%%  圆形度部分

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
         for j=1:leg
          lab(cols(j),rows(j))=0;
         end 
      end
  end
  I_bw=lab;

    %% HSV特征识别

    %% 提取图片特征

    % 获取测试图像
    I=double(I);
    I_bw=double(I_bw);
    I_res_r=I_bw.*I(:,:,1);
    I_res_g=I_bw.*I(:,:,2);
    I_res_b=I_bw.*I(:,:,3);
    I_res(:,:,1)=I_res_r;
    I_res(:,:,2)=I_res_g;
    I_res(:,:,3)=I_res_b;

    I_res=uint8(I_res);

    % 纹理特征
    SP=[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1];

    % 获取尺寸
    [size_M,size_N,size_C]=size(I_res);

    % 转灰度图
    if size_C>1
        I_res=rgb2gray(I_res);
    end

    fprintf('正在计算图片的特征...\n');
    % 生成LBP特征
    [Feature_texure]=lbp(I_res,SP,0,'nh'); 
    % 保存
    Feature=(Feature_texure);
 
    %% 距离计算部分
    fprintf('与数据库进行比对识别...\n');
    dist=zeros(1,database_pic);
    for j=1:database_pic

        dist(j)=sum(abs(mydatabase(j,:)-Feature));   
    end

    %% 分类,结果判断部分

    % 距离排序
    [content,index]=sort(dist);

    % 判断识别逻辑
    if content(1)<0.55
        recog_res=1;
    else
        recog_res=0;
    end

   %% 定位和识别部分

   I=uint8(I);
   I_bw=im2bw(I_bw);

    % 显示
    imshow(I);
    hold on

    % 定位和标定
    STATS = regionprops(I_bw,'basic');

    % 标定每个对象
    for j=1:length(STATS)
        
         if recog_res==1
            % 标记
            rectangle('Position',STATS(j).BoundingBox,'EdgeColor','g','LineWidth',4); 
         end
    end
    
    % 显示帧序号
    hold on;
    text(5, 18, strcat('#',num2str(i)), 'Color','y', 'FontWeight','bold', 'FontSize',20);
    pause(0.001); 
    hold off;

    
end

fprintf('处理完毕...\n');







