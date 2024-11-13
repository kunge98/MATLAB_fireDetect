%% 生成sift索引
function creat_sift_index(raw_image_path,index_path)
imglist= dir([raw_image_path '\*.jpg']);
listlength=length(imglist);
setwaitbar=waitbar(0,'请等待>>>>>>>>');
%对图片依次进行特征提取
for i1=1:listlength
    image=imread([[raw_image_path '\'] imglist(i1).name]);
    image1=image;
    image=res(image);
    clc
%若不是灰度图转化为灰度图   
    if ndims(image)==3
        image = rgb2gray(image);
    end
    [rows, cols] = size(image);
%转化为PGM格式，为特征提取做准备    
    f = fopen('tmp.pgm', 'w');
    if f == -1
        error('Could not create file tmp.pgm.');
    end
    fprintf(f, 'P5\n%d\n%d\n255\n', cols, rows);
    fwrite(f, image', 'uint8');
    fclose(f);
    command = '!siftWin32 ';
    command =[command, ' <tmp.pgm >tmp.key'];
    eval(command);
    g = fopen('tmp.key', 'r');
    if g == -1
        error('Could not open file tmp.key.');
    end
    [header, count] = fscanf(g, '%d %d', [1 2]);
    if count ~= 2
        error('Invalid keypoint file beginning.');
    end
    num = header(1);
    len = header(2);
    if len ~= 128
        error('Keypoint descriptor length invalid (should be 128).');
    end
    locs = double(zeros(num, 4));
    descriptors = double(zeros(num, 128));
    for i = 1:num
        [vector, count] = fscanf(g, '%f %f %f %f', [1 4]); %row col scale ori
        if count ~= 4
            error('Invalid keypoint file format');
        end
        locs(i, :) = vector(1, :);
        [descrip, count] = fscanf(g, '%d', [1 len]);
        if (count ~= 128)
            error('Invalid keypoint file value.');
        end
        descrip = descrip / sqrt(sum(descrip.^2));
        descriptors(i, :) = descrip(1, :);
    end
    assignin('base','descriptors',descriptors)
    fclose(g);
    image=image1;
%   listname=imglist(i1).name(1:end-4);
    imwrite(image,[index_path,'\火灾SIFT特征库\IMG\',num2str(i1),'.jpg']);
    path=strcat(index_path,'\火灾SIFT特征库\DES\',num2str(i1),'descriptors');
    assignin('base','path',path)
    save(path,'descriptors')
     
    path=strcat(index_path,'\火灾SIFT特征库\LOC\',num2str(i1),'locs');
    save(path,'locs')
    jindu=fix(i1/listlength*100);
    waitbar(jindu/100,setwaitbar,['已经完成' num2str(jindu) '%']);
 
end
delete(setwaitbar);
clear setwaitbar;


