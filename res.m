%% hsv+形态学+圆形度过滤 获取精确火灾部分
function I_res =  res(img)
I=img;
[M,N,C]=size(I);
hsv=rgb2hsv(I);
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
set_area=500;
I_bw=bwareaopen(I_bw,set_area);
SE=ones(3);
I_bw=imerode(I_bw,SE);
I_bw=imfill(I_bw,'holes');
I_bw=bwareaopen(I_bw,set_area);
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
I=double(I);
I_bw=double(I_bw);
I_res_r=I_bw.*I(:,:,1);
I_res_g=I_bw.*I(:,:,2);
I_res_b=I_bw.*I(:,:,3);
I_res(:,:,1)=I_res_r;
I_res(:,:,2)=I_res_g;
I_res(:,:,3)=I_res_b;  
I_res=uint8(I_res);
