function varargout = test(varargin)
% TEST MATLAB code for test.fig
%      TEST, by itself, creates a new TEST or raises the existing
%      singleton*.
%      H = TEST returns the handle to a new TEST or the handle to
%      the existing singleton*.
%      TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST.M with the given input arguments.
%      TEST('Property','Value',...) creates a new TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_OpeningFcn via varargin.
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
% See also: GUIDE, GUIDATA, GUIHANDLES
% Edit the above text to modify the response to help test
% Last Modified by GUIDE v2.5 25-May-2022 15:40:45
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_OpeningFcn, ...
                   'gui_OutputFcn',  @test_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
% --- Executes just before test is made visible.
function test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test (see VARARGIN)
% Choose default command line output for test
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes test wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% --- Outputs from this function are returned to the command line.
function varargout = test_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;
% --- Executes on button press in openvideo.
function openvideo_Callback(hObject, eventdata, handles)
% hObject    handle to openvideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname,filter] = uigetfile({'*.mp4;*.flv;*.avi;*.rmvb;*.f4v;*.mpeg;*.mkv'},'ѡ����Ƶ');
if filter == 0
    return
end
str = fullfile(pathname,filename);
filename = str; 
obj = VideoReader(filename);  
Show_Frames=read(obj,1);
axes(handles.axes1);  %���������������Ϊ��ǰ������,��������ͼ.
imshow(Show_Frames);
set(handles.axes1,'visible','on');
axis off
set(handles.text1,'String','�������Ƶ');
set(handles.text1,'visible','on');
setappdata(0,'obj',obj);
global indicate_loop;
indicate_loop=1;
% --- Executes on button press in detection.
function detection_Callback(hObject, eventdata, handles)
% hObject    handle to detection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=getappdata(0,'obj');
numFrames = obj.NumberOfFrames;
Framerate=obj.FrameRate; 
Height=obj.Height;
Width=obj.Width;
global indicate_loop;
indicate_loop=0;
load LBPfeature
[database_pic,N]=size(LBPfeature);
for i=1:numFrames
    if indicate_loop==1 
       break; 
    end
    I = read(obj,i);
    [M,N,C]=size(I);
    hsv=rgb2hsv(I);
    h=hsv(:,:,1);
    s=hsv(:,:,2);
    v=hsv(:,:,3);
    [row,col]=find((h>11/12 | h<1/12) & v>0.4);
    I_bw=zeros(M,N);
    leg=length(row);
    for j=1:leg
         I_bw(row(j),col(j))=1;
    end
    I_bw=im2bw(I_bw);
    set_area=500;
    I_bw=bwareaopen(I_bw,set_area);
    SE=ones(3);
    I_bw=imerode(I_bw,SE);
    I_bw=imfill(I_bw,'holes');
    set_area=300;
    I_bw=bwareaopen(I_bw,set_area);
    [lab,n]= bwlabel(I_bw);  %�Ը���ͨ����б��  �Ǵ��ϵ��£������ҵ�˳��
    stats1 = regionprops(lab,'Area');    
    stats2 = regionprops(lab,'Perimeter');    
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
  SP=[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1];
  [size_M,size_N,size_C]=size(I_res);
  if size_C>1
        I_res=rgb2gray(I_res);
  end
  [Feature_texure]=lbp(I_res,SP,0,'nh'); 
  Feature=[Feature_texure]; 
  dist=zeros(1,database_pic);
   for j=1:database_pic
        dist(j)=sum(abs(LBPfeature(j,:)-Feature).^2); %ŷ�Ͼ���
   end
   [content,index]=sort(dist);
   if content(1)<0.2
        recog_res=1;
    else
        recog_res=0;
   end
   I=uint8(I);
   I_bw=im2bw(I_bw);
   axes(handles.axes1);  
   set(handles.axes1,'visible','on');
   imshow(I);
   axis off
   hold on
   STATS = regionprops(I_bw,'basic');
   for j=1:length(STATS)
        if recog_res==1
           % ���
           rectangle('Position',STATS(j).BoundingBox,'EdgeColor','g','LineWidth',3); 
        end
    end
    hold on;
    text(5, 18, strcat('#',num2str(i)), 'Color','b', 'FontWeight','bold', 'FontSize',20);
    pause(0.001); 
    hold off;
    set(handles.text1,'String',sprintf('���ּ��'));
    set(handles.text1,'visible','on');
end
set(handles.text1,'String',sprintf('������'));
set(handles.text1,'visible','on');
% --- Executes on button press in quit.
function quit_Callback(hObject, eventdata, handles)
% hObject    handle to quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button=questdlg('�Ƿ�ȷ�Ϲر�','�ر�ȷ��','��','��','��');
if strcmp(button,'��')
    global indicate_loop;
    indicate_loop=1;
    close(gcf);
    close all;
else
    return;
end
% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate axes1
% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
ha=axes('units','normalized','pos',[0 0 1 1]);
uistack(ha,'down');
ii=imread('GUI����.jpg');
image(ii);
colormap gray
set(ha,'handlevisibility','off','visible','on');
% --- Executes on button press in LBP_feature_library.
function LBP_feature_library_Callback(hObject, eventdata, handles)
% hObject    handle to LBP_feature_library (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 cla reset;
 img1=imread('LBP.png');
 axes(handles.axes1);  
 imshow(img1);
 set(handles.axes1,'visible','on');
 axis off
 set(handles.text1,'String',sprintf('���ɻ���LBP��������...'));
filepath=getappdata(0,'filepath'); 
train_picnum=230;
Feature_num=256;
LBPfeature=zeros(train_picnum,Feature_num);
SP=[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1];
for i=1:train_picnum
    axes(handles.axes1);  
    imshow(img1);
    set(handles.axes1,'visible','on');
    axis off
    img_filename=sprintf('\\%d.jpg',i);
    fprintf('��ȡѵ��ͼ���%d ��ͼ����\n',i);
    img=imread(strcat(filepath ,img_filename));
    img=res(img);% ��ȡ��ȷ���ֲ���
    img=imresize(img,[240,320]);
    [M,N,C]=size(img);
    if C>1
        img=rgb2gray(img);
    end
    T=lbp(img,SP,0,'nh'); 
    LBPfeature(i,:)=T;     
end
set(handles.text1,'String',sprintf('���ɻ���LBP���������'));
assignin('base','LBPfeature',LBPfeature)
fprintf('ѵ������LBP���������\n');
save LBPfeature.mat LBPfeature
% --- Executes on button press in SIFT_feature_library.
function SIFT_feature_library_Callback(hObject, eventdata, handles)
% hObject    handle to SIFT_feature_library (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla reset;
img1=imread('SIFT.png');
axes(handles.axes1);  
imshow(img1);
set(handles.axes1,'visible','on');
axis off
set(handles.text1,'String',sprintf('���ɻ���SIFT��������...'));
filepath=getappdata(0,'filepath'); 
dir_name1=filepath;%ѵ������ͼ��·��
dir_name='C:\Users\Administrator\Desktop\����SIFT������';
mkdir([dir_name '\����SIFT������'],'IMG');
mkdir([dir_name '\����SIFT������'],'DES');
mkdir([dir_name '\����SIFT������'],'LOC');
creat_sift_index(dir_name1,dir_name);
set(handles.text1,'String',sprintf('���ɻ���SIFT���������'));
% --- Executes on button press in hsv_seg.
function hsv_seg_Callback(hObject, eventdata, handles)
% hObject    handle to hsv_seg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj3=getappdata(0,'obj2');
hsv=rgb2hsv(obj3);
[M,N,C]=size(obj3);
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
set(handles.text1,'String','HSV�ָ�');
axes(handles.axes1);  
imshow(I_bw);
set(handles.axes1,'visible','on');
axis off
setappdata(0,'I_bw',I_bw);  % ��Ϊȫ�ؼ����ñ�����
% --- Executes on button press in morphological_process.
function morphological_process_Callback(hObject, eventdata, handles)
% hObject    handle to morphological_process (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I_bw=getappdata(0,'I_bw');
set_area=500;
I_bw=bwareaopen(I_bw,set_area);
SE=ones(3);
I_bw=imerode(I_bw,SE);
I_bw=imfill(I_bw,'holes');
I_bw1=bwareaopen(I_bw,set_area);
set(handles.text1,'String','��̬ѧ����');
axes(handles.axes1); 
imshow(I_bw1);
set(handles.axes1,'visible','on');
axis off
setappdata(0,'I_bw1',I_bw1);  % ��Ϊȫ�ؼ����ñ���
% --- Executes on button press in circularity.
function circularity_Callback(hObject, eventdata, handles)
% hObject    handle to circularity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I_bw1=getappdata(0,'I_bw1');
    [lab,n]= bwlabel(I_bw1);%�Ը���ͨ����б��  �Ǵ��ϵ��£������ҵ�˳��
    stats1 = regionprops(lab,'Area');
    stats2 = regionprops(lab,'Perimeter');   
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
I_bw2=lab;
set(handles.text1,'String','Բ�ζȹ���');
axes(handles.axes1);  
imshow(I_bw2);
set(handles.axes1,'visible','on');
axis off
setappdata(0,'I_bw2',I_bw2);  % ��Ϊȫ�ؼ����ñ�����
% --- Executes on button press in suspected_fire.
function suspected_fire_Callback(hObject, eventdata, handles)
% hObject    handle to suspected_fire (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I_bw2=getappdata(0,'I_bw2');
obj4 =getappdata(0,'obj2');
obj4=double(obj4);
I_bw2=double(I_bw2);
I_res_r=I_bw2.*obj4(:,:,1);
I_res_g=I_bw2.*obj4(:,:,2);
I_res_b=I_bw2.*obj4(:,:,3);
I_res(:,:,1)=I_res_r;
I_res(:,:,2)=I_res_g;
I_res(:,:,3)=I_res_b;
I_res=uint8(I_res);
I_res1=rgb2gray(I_res);
set(handles.text1,'String','������������');
axes(handles.axes1);  
imshow(I_res);
set(handles.axes1,'visible','on');
axis off
setappdata(0,'I_res1',I_res1);  % ��Ϊȫ�ؼ����ñ�����
% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I_res1=getappdata(0,'I_res1');
SP=[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1];
[Feature_texure]=lbp(I_res1,SP,0,'nh');   %ֱ��ͼ���⻯��
Feature=[Feature_texure];
load LBPfeature.mat
[database_pic,N]=size(LBPfeature);
dist=zeros(1,database_pic);
for i=1:database_pic
 dist(i)=sqrt( sum( (LBPfeature(i,:)-Feature).^2 ) );  %ŷʽ����
end
[content,index]=sort(dist);
if ( dist(1)<0.15 )
    cla reset;
    recog_res=1;
    img=imread('��.png')
    axes(handles.axes1);  
    imshow(img);
    set(handles.axes1,'visible','on');
    axis off
else
    cla reset;
    recog_res=0;
    img=imread('�ǻ�.png')
    axes(handles.axes1);  
    imshow(img);
    set(handles.axes1,'visible','on');
    axis off
end
set(handles.text1,'String','LBP&ŷʽ����');
recog_res=1;
setappdata(0,'recog_res',recog_res);
% --- Executes on button press in recog_fire.
function recog_fire_Callback(hObject, eventdata, handles)
% hObject    handle to recog_fire (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 obj2=getappdata(0,'obj2');
 recog_res=getappdata(0,'recog_res');
 I_bw2=getappdata(0,'I_bw2');
 axes(handles.axes1);
 imshow(obj2);
 if recog_res==1
  hold on
  STATS = regionprops(I_bw2,'basic');
    for j=1:length(STATS)
        if recog_res==1
           rectangle('Position',STATS(j).BoundingBox,'EdgeColor','g','LineWidth',3); 
        end
    end
   hold off
 else
     set(handles.text1,'String',sprintf('δ��������'));
 end
set(handles.text1,'String','�������');
set(handles.text1,'visible','on');
% --- Executes on button press in get_pic.
function get_pic_Callback(hObject, eventdata, handles)
% hObject    handle to get_pic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname,filter] = uigetfile({'*.jpg;*.png;*.gif;*.bmp;*.jpeg;'},'ѡ��ͼƬ');
if filter == 0
    return
end
str = fullfile(pathname,filename);
obj2 = imread(str); 
obj2=imresize(obj2,[240,320]);
axes(handles.axes1);
imshow(obj2);
set(handles.axes1,'visible','on');
axis off
set(handles.text1,'String','�����ͼƬ');
set(handles.text1,'visible','on');
setappdata(0,'obj2',obj2);  % ��Ϊȫ�ؼ����ñ�����
% --- Executes on button press in SURF_feature_library.
function SURF_feature_library_Callback(hObject, eventdata, handles)
% hObject    handle to SURF_feature_library (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla reset
filepath=getappdata(0,'filepath'); 
set(handles.text1,'String',sprintf('���ɻ���SURF��������...'));
filepath=getappdata(0,'filepath'); 
dir_name1=filepath;%ѵ������ͼ��·��
dir_name='C:\Users\Administrator\Desktop\���۴���';
mkdir([dir_name '\����SURF������'],'IMG');
mkdir([dir_name '\����SURF������'],'DES');
mkdir([dir_name '\����SURF������'],'LOC');
creat_surf_index(dir_name1,dir_name);
set(handles.text1,'String',sprintf('���ɻ���SURF���������'));
% --- Executes on button press in SelectGallery.
function SelectGallery_Callback(hObject, eventdata, handles)
% hObject    handle to SelectGallery (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filepath = uigetdir('*.*','��ѡ���ļ���');%fliepathΪ�ļ���·��
setappdata(0,'filepath',filepath); 
cla reset;
img=imread('ѡ��.png');
axes(handles.axes1);  
imshow(img);
set(handles.axes1,'visible','on');
axis off
% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of togglebutton2
% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text1,'String',sprintf('SIFT&ŷ�Ͼ���'));
I_res1=getappdata(0,'I_res1');
img=I_res1;
[img1, des1 ,loc1]=sift(I_res1);
rlu_num=0;
ed1str=('C:\Users\Administrator\Desktop\���۴���');
imgname= dir([ed1str '\����SIFT������\IMG\*.jpg']);
desname= dir([ed1str '\����SIFT������\DES\*.mat']);
leg=length(imgname);
num=zeros(leg,5000);
for j=1:leg
    eval(['load ' ed1str '\����SIFT������\DES\' desname(j).name]); 
    des2=descriptors;
    assignin('base','des2',des2)
    distRatio = 0.6;
    des2t= des2';     
    for i = 1 : size(des1,1)
    dotprods = des1(i,:) * des2t;        
    [vals,inds] = sort(acos(dotprods)); 
        if (vals(1) < distRatio * vals(2))
                match(i) = inds(1);
        else
                match(i) = 0;
        end
    end
    num = sum(match>0);   
    if num
       rlu_num=rlu_num+1;
      % rlu_list(rlu_num)={[ed1str '\����SIFT������\IMG\' imgname(i).name]};
       sort_index(rlu_num,1)=num;
       sort_index(rlu_num,2)=rlu_num;
    end
end
rlu_index=sortrows(sort_index,-1);
a=rlu_index(1,1);
if ( a>5)
    recog_res=1;
    cla reset;
    recog_res=1;
    img=imread('��.png')
    axes(handles.axes1);  
    imshow(img);
    set(handles.axes1,'visible','on');
    axis off
else
    recog_res=0;
     cla reset;
    recog_res=1;
    img=imread('�ǻ�.png')
    axes(handles.axes1);  
    imshow(img);
    set(handles.axes1,'visible','on');
    axis off
end
setappdata(0,'recog_res',recog_res)
% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text1,'String',sprintf('SURF&ŷ�Ͼ���'));
I_res1=getappdata(0,'I_res1');
img=I_res1;
Ipts=OpenSurf(img);
des1=reshape([Ipts.descriptor],64,[]); 
num=zeros(1,length(des1));
ed1str=('C:\Users\Administrator\Desktop\���۴���');
imgname= dir([ed1str '\����SURF������\IMG\*.jpg']);
desname= dir([ed1str '\����SURF������\DES\*.mat']);
leg=length(imgname);
n=0;
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
if ( max(num)>5)
    recog_res=1;
     cla reset;
    recog_res=1;
    img=imread('��.png')
    axes(handles.axes1);  
    imshow(img);
    set(handles.axes1,'visible','on');
    axis off   
else
    recog_res=0;
     cla reset;
    recog_res=1;
    img=imread('�ǻ�.png')
    axes(handles.axes1);  
    imshow(img);
    set(handles.axes1,'visible','on');
    axis off
end


% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname,filter] = uigetfile({'*.mp4;*.flv;*.avi;*.rmvb;*.f4v;*.mpeg;*.mkv'},'ѡ����Ƶ');
if filter == 0
    return
end
str = fullfile(pathname,filename);
filename = str; 
obj = VideoReader(filename);  
Show_Frames=read(obj,1);
axes(handles.axes1);  %���������������Ϊ��ǰ������,��������ͼ.
imshow(Show_Frames);
set(handles.axes1,'visible','on');
axis off
set(handles.text1,'String','�������Ƶ');
set(handles.text1,'visible','on');
setappdata(0,'obj',obj);
global indicate_loop;
indicate_loop=1;



% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=getappdata(0,'obj');
numFrames = obj.NumberOfFrames;
Framerate=obj.FrameRate; 
Height=obj.Height;
Width=obj.Width;
global indicate_loop;
indicate_loop=0;
load LBPfeature
[database_pic,N]=size(LBPfeature);
for i=1:numFrames
    if indicate_loop==1 
       break; 
    end
    I = read(obj,i);
    [M,N,C]=size(I);
    hsv=rgb2hsv(I);
    h=hsv(:,:,1);
    s=hsv(:,:,2);
    v=hsv(:,:,3);
    [row,col]=find((h>11/12 | h<1/12) & v>0.4);
    I_bw=zeros(M,N);
    leg=length(row);
    for j=1:leg
         I_bw(row(j),col(j))=1;
    end
    I_bw=im2bw(I_bw);
    set_area=500;
    I_bw=bwareaopen(I_bw,set_area);
    SE=ones(3);
    I_bw=imerode(I_bw,SE);
    I_bw=imfill(I_bw,'holes');
    set_area=300;
    I_bw=bwareaopen(I_bw,set_area);
    [lab,n]= bwlabel(I_bw);  %�Ը���ͨ����б��  �Ǵ��ϵ��£������ҵ�˳��
    stats1 = regionprops(lab,'Area');    
    stats2 = regionprops(lab,'Perimeter');    
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
  SP=[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1];
  [size_M,size_N,size_C]=size(I_res);
  if size_C>1
        I_res=rgb2gray(I_res);
  end
  [Feature_texure]=lbp(I_res,SP,0,'nh'); 
  Feature=[Feature_texure]; 
  dist=zeros(1,database_pic);
   for j=1:database_pic
        dist(j)=sum(abs(LBPfeature(j,:)-Feature).^2); %ŷ�Ͼ���
   end
   [content,index]=sort(dist);
   if content(1)<0.2
        recog_res=1;
    else
        recog_res=0;
   end
   I=uint8(I);
   I_bw=im2bw(I_bw);
   axes(handles.axes1);  
   set(handles.axes1,'visible','on');
   imshow(I);
   axis off
   hold on
   STATS = regionprops(I_bw,'basic');
   for j=1:length(STATS)
        if recog_res==1
           % ���
           rectangle('Position',STATS(j).BoundingBox,'EdgeColor','g','LineWidth',3); 
        end
    end
    hold on;
    text(5, 18, strcat('#',num2str(i)), 'Color','b', 'FontWeight','bold', 'FontSize',20);
    pause(0.001); 
    hold off;
    set(handles.text1,'String',sprintf('���ּ��'));
    set(handles.text1,'visible','on');
end
set(handles.text1,'String',sprintf('������'));
set(handles.text1,'visible','on');



% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname,filter] = uigetfile({'*.jpg;*.png;*.gif;*.bmp;*.jpeg;'},'ѡ��ͼƬ');
if filter == 0
    return
end
str = fullfile(pathname,filename);
obj2 = imread(str); 
obj2=imresize(obj2,[240,320]);
axes(handles.axes1);
imshow(obj2);
set(handles.axes1,'visible','on');
axis off
set(handles.text1,'String','�����ͼƬ');
set(handles.text1,'visible','on');
setappdata(0,'obj2',obj2);  % ��Ϊȫ�ؼ����ñ�����



% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj3=getappdata(0,'obj2');
hsv=rgb2hsv(obj3);
[M,N,C]=size(obj3);
h=hsv(:,:,1);
s=hsv(:,:,2);
v=hsv(:,:,3);
[row,col]=find(s<0.2 & v>0.75);
% [row,col]=find((h>11/12 | h<1/12) & v>0.4);
I_bw=zeros(M,N);
leg=length(row);
for i=1:leg
     I_bw(row(i),col(i))=1;  
end
I_bw=im2bw(I_bw);
set(handles.text1,'String','HSV�ָ�');
axes(handles.axes1);  
imshow(I_bw);
set(handles.axes1,'visible','on');
axis off
setappdata(0,'I_bw',I_bw);  % ��Ϊȫ�ؼ����ñ�����


% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I_bw=getappdata(0,'I_bw');
set_area=500;
I_bw=bwareaopen(I_bw,set_area);
SE=ones(3);
I_bw=imerode(I_bw,SE);
I_bw=imfill(I_bw,'holes');
I_bw1=bwareaopen(I_bw,set_area);
set(handles.text1,'String','��̬ѧ����');
axes(handles.axes1);  
imshow(I_bw1);
set(handles.axes1,'visible','on');
axis off
setappdata(0,'I_bw1',I_bw1);  % ��Ϊȫ�ؼ����ñ�����



% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I_bw1=getappdata(0,'I_bw1');
    [lab,n]= bwlabel(I_bw1);%�Ը���ͨ����б��  �Ǵ��ϵ��£������ҵ�˳��
    stats1 = regionprops(lab,'Area');    
    stats2 = regionprops(lab,'Perimeter');   
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
I_bw2=lab;
set(handles.text1,'String','Բ�ζȹ���');
axes(handles.axes1);  
imshow(I_bw2);
set(handles.axes1,'visible','on');
axis off
setappdata(0,'I_bw2',I_bw2);  % ��Ϊȫ�ؼ����ñ�����



% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I_bw2=getappdata(0,'I_bw2');
obj4 =getappdata(0,'obj2');
obj4=double(obj4);
I_bw2=double(I_bw2);
I_res_r=I_bw2.*obj4(:,:,1);
I_res_g=I_bw2.*obj4(:,:,2);
I_res_b=I_bw2.*obj4(:,:,3);
I_res(:,:,1)=I_res_r;
I_res(:,:,2)=I_res_g;
I_res(:,:,3)=I_res_b;
I_res=uint8(I_res);
I_res1=rgb2gray(I_res);
set(handles.text1,'String','������������');
axes(handles.axes1);  
imshow(I_res);
set(handles.axes1,'visible','on');
axis off
setappdata(0,'I_res1',I_res1);  % ��Ϊȫ�ؼ����ñ�����


% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I_res1=getappdata(0,'I_res1');
SP=[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1];
[Feature_texure]=lbp(I_res1,SP,0,'nh');   %ֱ��ͼ���⻯��
Feature=[Feature_texure];
load LBPfeature.mat
[database_pic,N]=size(LBPfeature);
dist=zeros(1,database_pic);
for i=1:database_pic
 dist(i)=sqrt( sum( (LBPfeature(i,:)-Feature).^2 ) );  %ŷʽ����
end
[content,index]=sort(dist);
if ( dist(1)<0.15 )
    cla reset;
    recog_res=1;
    img=imread('��.png')
    axes(handles.axes1);  
    imshow(img);
    set(handles.axes1,'visible','on');
    axis off
else
    cla reset;
    recog_res=0;
    img=imread('�ǻ�.png')
    axes(handles.axes1);  
    imshow(img);
    set(handles.axes1,'visible','on');
    axis off
end
set(handles.text1,'String','LBP&ŷʽ����');
recog_res=1;
setappdata(0,'recog_res',recog_res);



% --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 obj2=getappdata(0,'obj2');
 recog_res=getappdata(0,'recog_res');
 I_bw2=getappdata(0,'I_bw2');
 axes(handles.axes1);
 imshow(obj2);
 if recog_res==1
  hold on
  STATS = regionprops(I_bw2,'basic');
    for j=1:length(STATS)
        if recog_res==1
           rectangle('Position',STATS(j).BoundingBox,'EdgeColor','g','LineWidth',3); 
        end
    end
   hold off
 else
     set(handles.text1,'String',sprintf('δ��������'));
 end
set(handles.text1,'String','�������');
set(handles.text1,'visible','on');
