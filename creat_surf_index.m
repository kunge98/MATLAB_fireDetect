%% 生成surf索引  
 function creat_surf_index(raw_image_path,index_path)
imglist= dir([raw_image_path '\*.jpg']);
listlength=length(imglist);
setwaitbar=waitbar(0,'请等待>>>>>>>>');

for i1=1:listlength
     
    image=imread([[raw_image_path '\'] imglist(i1).name]);
    image1=image;
    image=res(image);
    clc 
    fprintf('zhezzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz%d',i1);
%若不是灰度图转化为灰度图   
    if ndims(image)==3
        image = rgb2gray(image);
    end
    Ipts=OpenSurf(image);
    
    descriptor=reshape([Ipts.descriptor],64,[]);
    
    filedir=('C:\Users\Administrator\Desktop\毕论代码\火灾SURF特征库\DES\');
    savepath=strcat(filedir,num2str(i1),'.mat');
    save(savepath,'descriptor');
    
    listname=imglist(i1).name(1:end);
    imwrite(image1,[index_path,'\火灾SURF特征库\IMG\',listname]);
    
    jindu=fix(i1/listlength*100);
    waitbar(jindu/100,setwaitbar,['已经完成' num2str(jindu) '%']);

end
delete(setwaitbar);
clear setwaitbar;