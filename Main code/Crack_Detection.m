 function varargout = Crack_Detection(varargin)
% CRACK_DETECTION MATLAB code for Crack_Detection.fig
%      CRACK_DETECTION, by itself, creates a new CRACK_DETECTION or raises the existing
%      singleton*.
%
%      H = CRACK_DETECTION returns the handle to a new CRACK_DETECTION or the handle to
%      the existing singleton*.
% 
%      CRACK_DETECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CRACK_DETECTION.M with the given input arguments.
%
%      CRACK_DETECTION('Property','Value',...) creates a new CRACK_DETECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Crack_Detection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Crack_Detection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Crack_Detection

% Last Modified by GUIDE v2.5 27-Jan-2023 09:53:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Crack_Detection_OpeningFcn, ...
                   'gui_OutputFcn',  @Crack_Detection_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State,varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Crack_Detection is made visible.
function Crack_Detection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Crack_Detection (see VARARGIN)

% Choose default command line output for Crack_Detection
handles.output = hObject;
axes(handles.axes1); axis off
axes(handles.axes2); axis off
axes(handles.axes3); axis off
axes(handles.axes4); axis off
set(handles.edit1,'String','**');
set(handles.edit2,'String','**');
set(handles.edit3,'String','**');
set(handles.edit4,'String','**');
set(handles.edit5,'String','**');
set(handles.edit6,'String','**');
set(handles.edit7,'String','**');
set(handles.edit8,'String','**');
set(handles.edit9,'String','**');
set(handles.edit10,'String','**');
set(handles.edit11,'String','**');
set(handles.edit12,'String','**');
set(handles.edit13,'String','**');
set(handles.edit14,'String','**');
set(handles.edit15,'String','**');
set(handles.edit16,'String','**');
set(handles.edit17,'String','**');
set(handles.edit18,'String','**');
set(handles.edit19,'String','**');
set(handles.edit20,'String','**');
set(handles.edit21,'String','**');
set(handles.edit22,'String','**');
set(handles.edit23,'String','**');
set(handles.edit24,'String','**');
 


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Crack_Detection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Crack_Detection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 global img;global N; global grayimg;global img2;

N = 2; 
K = 1;
%% Read All Image
img = {};
img2 = {};
for i=1:N
  img2{i}=sprintf('Non-Crack/%d%s',i,'.jpg');
  img2{i}=imread(img2{i});
end
 
% [fname path]=uigetfile({'*.jpg';'*.bmp';'*.tif';'*.jpg'},'Browse Image');
% if fname~=0
%     img=imread([path,fname]);
% else
%     warndlg('Please Select the necessary Image File');
% end

url = "http://192.168.137.251/cam-hi.jpg";
img = imread(url);
 



axes(handles.axes1); imshow(img); 
title('Original');
grayImg = {};
grayImg2 = {};
for i=1:N
    
    grayImg2{i} = rgb2gray(img2{i});
end
grayimg = rgb2gray(img);
axes(handles.axes2); imshow(grayimg); 
title('Gray Level');

medImg = {};
medImg2 = {};
for i=1:N
    medimg = medfilt2(grayimg,[5,5]);
    medImg2{i} = medfilt2(grayImg2{i},[5,5]);
    %looping j times
    for j=1:K
       
        medImg2{i} = medImg2{i} + medfilt2(grayImg2{i},[5,5]);
    end
end
 medimg = medimg + medfilt2(grayimg,[5,5]);
axes(handles.axes2); imshow(medimg); 
title('Med Level');pause(2);
%% Create Structuring Element 15 pixels for 0,30,60,90,120,150 degres
SE = {};I = img;
for i=0:5
   SE{i+1} = strel('line',15,i*30); 
end
%% Image opening in the six direction for each gray level image && Overlap Image to Single one
imgOpen = {};
imgOverlap = {};
imgOpen2 = {};
imgOverlap2 = {};
for i=1:N
    for j=1:6
        imgOpen{j} = imopen(medimg,SE{j});
        imgOpen2{j} = imopen(medImg2{i},SE{j});
        if j==6
            imgOverlap{i} = imgOpen{1};
            imgOverlap2{i} = imgOpen2{1};
            for l=2:6
                imgOverlap{i} = imfuse(imgOverlap{i},imgOpen{l});
                imgOverlap2{i} = imfuse(imgOverlap2{i},imgOpen2{l});
            end
        end
    end
end
axes(handles.axes2); imshow(imgOverlap{1}); 
title('Overlap Level');
SE = {};I = img;
for i=0:5
   SE{i+1} = strel('line',15,i*30); 
end
%% Image opening in the six direction for each gray level image && Overlap Image to Single one
imgOpen = {};
imgOverlap = {};
imgOpen2 = {};
imgOverlap2 = {};
for i=1:N
    for j=1:6
        imgOpen{j} = imopen(medimg,SE{j});
        imgOpen2{j} = imopen(medImg2{i},SE{j});
        if j==6
            imgOverlap{i} = imgOpen{1};
            imgOverlap2{i} = imgOpen2{1};
            for l=2:6
                imgOverlap{i} = imfuse(imgOverlap{i},imgOpen{l});
                imgOverlap2{i} = imfuse(imgOverlap2{i},imgOpen2{l});
            end
        end
    end
end
axes(handles.axes3);  imshow(imgOverlap{1}); 
title('Overlap Level');
%% Image regions and Convert to binary image with otsu threshold
imgBw = {};
imgBw2 = {};
for i=1:N
   %crack
   level = graythresh(imgOverlap{i});
   imgBw{i} = im2bw(imgOverlap{i},level);
   %inverse
   imgBw{i} = ~imgBw{i};
   %non-crack
   level2 = graythresh(imgOverlap2{i});
   imgBw2{i} = im2bw(imgOverlap2{i},level2);
   %inverse
   imgBw2{i} = ~imgBw2{i};
end
for i=1:N
figure, imshow(imgBw{i}); 
title('Binary');    
end

%
 s = regionprops(imgBw2{2},'centroid');
 centroids = cat(1, s.Centroid);
 figure, imshow(imgBw2{2})
 hold on
 plot(centroids(:,1),centroids(:,2), 'b*')
 hold off

%% Prepare properties image region (Eccentricity and Area) for crack
imgProp = {};
areaProp = {};
eccentricityProp = {};
majorAxisProp = {};
minorAxisProp = {};
for i=1:N
   imgProp{i} = regionprops(imgBw{i},'Area','Eccentricity','MajorAxisLength','MinorAxisLength'); 
   areaProp{i} = vertcat(imgProp{i}.Area);
   eccentricityProp{i} = vertcat(imgProp{i}.Eccentricity);
   majorAxisProp{i} = vertcat(imgProp{i}.MajorAxisLength);
   minorAxisProp{i} = vertcat(imgProp{i}.MinorAxisLength);
end

%% Prepare properties image region (Eccentricity and Area) for non-crack
imgProp2 = {};
areaProp2 = {};
eccentricityProp2 = {};
majorAxisProp2 = {};
minorAxisProp2 = {};
for i=1:N
   imgProp2{i} = regionprops(imgBw2{i},'Area','Eccentricity','MajorAxisLength','MinorAxisLength'); 
   areaProp2{i} = vertcat(imgProp2{i}.Area);
   eccentricityProp2{i} = vertcat(imgProp2{i}.Eccentricity);
   majorAxisProp2{i} = vertcat(imgProp2{i}.MajorAxisLength);
   minorAxisProp2{i} = vertcat(imgProp2{i}.MinorAxisLength);
end

%% Count Area
%Area>=200
area1 = {};
%Area 200>~>=150
area2 = {};
%Area 150>~>=100
area3 = {};
%Area 100>~>=50
area4 = {};
%Area <50
area5 = {};

for i=1:N
   counter1 = 0;
   counter2 = 0;
   counter3 = 0;
   counter4 = 0;
   counter5 = 0;
   for j=1:size(imgProp{i})
       if imgProp{i}(j).Area < 50
          counter5 = counter5 + 1;
       else if imgProp{i}(j).Area >= 50 && imgProp{i}(j).Area < 100
               counter4 = counter4 + 1;
           else if imgProp{i}(j).Area >= 100 && imgProp{i}(j).Area < 150
                   counter3 = counter3 + 1;
               else if imgProp{i}(j).Area >= 150 && imgProp{i}(j).Area < 200
                       counter2 = counter2 + 1;
                   else counter1 = counter1 + 1;
                   end
               end
           end
       end
   end
   area1{i} = counter1;
   area2{i} = counter2;
   area3{i} = counter3;
   area4{i} = counter4;
   area5{i} = counter5;
end

%% Count Eccentricity
%eccentricity 0.1>=~>=0.95
eccentricity1 = {};
%eccentricity 0.95>~>=0.90
eccentricity2 = {};
%eccentricity 0.90>~>=0.85
eccentricity3 = {};
%eccentricity 0.85>~>=0.80
eccentricity4 = {};
%eccentricity <0.80
eccentricity5 = {};

for i=1:N
   counter1 = 0;
   counter2 = 0;
   counter3 = 0;
   counter4 = 0;
   counter5 = 0;
   for j=1:size(imgProp{i})
       if imgProp{i}(j).Eccentricity < 0.80
          counter5 = counter5 + 1;
       else if imgProp{i}(j).Eccentricity >= 0.80 && imgProp{i}(j).Eccentricity < 0.85
               counter4 = counter4 + 1;
           else if imgProp{i}(j).Eccentricity >= 0.85 && imgProp{i}(j).Eccentricity < 0.90
                   counter3 = counter3 + 1;
               else if imgProp{i}(j).Eccentricity >= 0.90 && imgProp{i}(j).Eccentricity < 0.95
                       counter2 = counter2 + 1;
                   else counter1 = counter1 + 1;
                   end
               end
           end
       end
   end
   eccentricity1{i} = counter1;
   eccentricity2{i} = counter2;
   eccentricity3{i} = counter3;
   eccentricity4{i} = counter4;
   eccentricity5{i} = counter5;
end

%% Accuracy Count Crack
counter1 = {};
counter2 = {};
counter3 = {};
counter4 = {};
counter5 = {};
counter6 = {};
counter7 = {};
counter8 = {};
counter9 = {};
counter10 = {};
counter11 = {};
counter12 = {};
counter13 = {};
counter14 = {};
counter15 = {};
counter16 = {};

for i=1:N
    counter1{i} = 0;    
    counter2{i} = 0;    
    counter3{i} = 0;    
    counter4{i} = 0;    
    counter5{i} = 0;    
    counter6{i} = 0;    
    counter7{i} = 0;    
    counter8{i} = 0;
    counter9{i} = 0;    
    counter10{i} = 0;    
    counter11{i} = 0;    
    counter12{i} = 0;    
    counter13{i} = 0;    
    counter14{i} = 0;    
    counter15{i} = 0;    
    counter16{i} = 0;
end
total = {};
for i=1:16
   total{i} = 0; 
end
for i=1:N
    for j=1:size(imgProp{i})
       if(imgProp{i}(j).Area >= 50 && imgProp{i}(j).Eccentricity >= 0.8)
           counter1{i} = counter1{i} + 1;
           if(imgProp{i}(j).Area >= 50 && imgProp{i}(j).Eccentricity >=0.85)
               counter2{i} = counter2{i} + 1;
               if(imgProp{i}(j).Area >= 50 && imgProp{i}(j).Eccentricity >=0.9)
                   counter3{i} = counter3{i} + 1;
                   if(imgProp{i}(j).Area >= 50 && imgProp{i}(j).Eccentricity >=0.95)
                       counter4{i} = counter4{i} + 1;
                   end
               end
           end
       end
       if(imgProp{i}(j).Area >= 100 && imgProp{i}(j).Eccentricity >= 0.8)
           counter5{i} = counter5{i} + 1;
           if(imgProp{i}(j).Area >= 100 && imgProp{i}(j).Eccentricity >=0.85)
               counter6{i} = counter6{i} + 1;
               if(imgProp{i}(j).Area >= 100 && imgProp{i}(j).Eccentricity >=0.9)
                   counter7{i} = counter7{i} + 1;
                   if(imgProp{i}(j).Area >= 100 && imgProp{i}(j).Eccentricity >=0.95)
                       counter8{i} = counter8{i} + 1;
                   end
               end
           end
       end
       if(imgProp{i}(j).Area >= 150 && imgProp{i}(j).Eccentricity >= 0.8)
           counter9{i} = counter9{i} + 1;
           if(imgProp{i}(j).Area >= 150 && imgProp{i}(j).Eccentricity >=0.85)
               counter10{i} = counter10{i} + 1;
               if(imgProp{i}(j).Area >= 150 && imgProp{i}(j).Eccentricity >=0.9)
                   counter11{i} = counter11{i} + 1;
                   if(imgProp{i}(j).Area >= 150 && imgProp{i}(j).Eccentricity >=0.95)
                       counter12{i} = counter12{i} + 1;
                   end
               end
           end
       end
       if(imgProp{i}(j).Area >= 200 && imgProp{i}(j).Eccentricity >= 0.8)
           counter13{i} = counter13{i} + 1;
           if(imgProp{i}(j).Area >= 200 && imgProp{i}(j).Eccentricity >=0.85)
               counter14{i} = counter14{i} + 1;
               if(imgProp{i}(j).Area >= 200 && imgProp{i}(j).Eccentricity >=0.9)
                   counter15{i} = counter15{i} + 1;
                   if(imgProp{i}(j).Area >= 200 && imgProp{i}(j).Eccentricity >=0.95)
                       counter16{i} = counter16{i} + 1;
                   end
               end
           end
       end
    end
end

for i=1:N
        if counter1{i} ~= 0
            total{1} = total{1} + 1;
        end 
        if counter2{i} ~= 0
            total{2} = total{2} + 1; 
        end
        if counter3{i} ~= 0
            total{3} = total{3} + 1;
        end
        if counter4{i} ~= 0
            total{4} = total{4} + 1;
        end
        if counter5{i} ~= 0
            total{5} = total{5} + 1;
        end
        if counter6{i} ~= 0
            total{6} = total{6} + 1;
        end
        if counter7{i} ~= 0
            total{7} = total{7} + 1;
        end
        if counter8{i} ~= 0
            total{8} = total{8} + 1;
        end
        if counter9{i} ~= 0
            total{9} = total{9} + 1;
        end
        if counter10{i} ~= 0
            total{10} = total{10} + 1;
        end
        if counter11{i} ~= 0
            total{11} = total{11} + 1;
        end
        if counter12{i} ~= 0
            total{12} = total{12} + 1;
        end
        if counter13{i} ~= 0
            total{13} = total{13} + 1;
        end
        if counter14{i} ~= 0
            total{14} = total{14} + 1;
        end
        if counter15{i} ~= 0
            total{15} = total{15} + 1;
        end
        if counter16{i} ~= 0
            total{16} = total{16} + 1;
        end
end

%% Accuracy Count Non-Crack
counter2_1 = {};
counter2_2 = {};
counter2_3 = {};
counter2_4 = {};
counter2_5 = {};
counter2_6 = {};
counter2_7 = {};
counter2_8 = {};
counter2_9 = {};
counter2_10 = {};
counter2_11 = {};
counter2_12 = {};
counter2_13 = {};
counter2_14 = {};
counter2_15 = {};
counter2_16 = {};

for i=1:N
    counter2_1{i} = 0;    
    counter2_2{i} = 0;    
    counter2_3{i} = 0;    
    counter2_4{i} = 0;    
    counter2_5{i} = 0;    
    counter2_6{i} = 0;    
    counter2_7{i} = 0;    
    counter2_8{i} = 0;
    counter2_9{i} = 0;    
    counter2_10{i} = 0;    
    counter2_11{i} = 0;    
    counter2_12{i} = 0;    
    counter2_13{i} = 0;    
    counter2_14{i} = 0;    
    counter2_15{i} = 0;    
    counter2_16{i} = 0;
end
total2 = {};
for i=1:16
   total2{i} = 0; 
end
for i=1:N
    for j=1:size(imgProp2{i})
       if(imgProp2{i}(j).Area >= 50 && imgProp2{i}(j).Eccentricity >= 0.8)
           counter2_1{i} = counter2_1{i} + 1;
           if(imgProp2{i}(j).Area >= 50 && imgProp2{i}(j).Eccentricity >=0.85)
               counter2_2{i} = counter2_2{i} + 1;
               if(imgProp2{i}(j).Area >= 50 && imgProp2{i}(j).Eccentricity >=0.9)
                   counter2_3{i} = counter2_3{i} + 1;
                   if(imgProp2{i}(j).Area >= 50 && imgProp2{i}(j).Eccentricity >=0.95)
                       counter2_4{i} = counter2_4{i} + 1;
                   end
               end
           end
       end
       if(imgProp2{i}(j).Area >= 100 && imgProp2{i}(j).Eccentricity >= 0.8)
           counter2_5{i} = counter2_5{i} + 1;
           if(imgProp2{i}(j).Area >= 100 && imgProp2{i}(j).Eccentricity >=0.85)
               counter2_6{i} = counter2_6{i} + 1;
               if(imgProp2{i}(j).Area >= 100 && imgProp2{i}(j).Eccentricity >=0.9)
                   counter2_7{i} = counter2_7{i} + 1;
                   if(imgProp2{i}(j).Area >= 100 && imgProp2{i}(j).Eccentricity >=0.95)
                       counter2_8{i} = counter2_8{i} + 1;
                   end
               end
           end
       end
       if(imgProp2{i}(j).Area >= 150 && imgProp2{i}(j).Eccentricity >= 0.8)
           counter2_9{i} = counter2_9{i} + 1;
           if(imgProp2{i}(j).Area >= 150 && imgProp2{i}(j).Eccentricity >=0.85)
               counter2_10{i} = counter2_10{i} + 1;
               if(imgProp2{i}(j).Area >= 150 && imgProp2{i}(j).Eccentricity >=0.9)
                   counter2_11{i} = counter2_11{i} + 1;
                   if(imgProp2{i}(j).Area >= 150 && imgProp2{i}(j).Eccentricity >=0.95)
                       counter2_12{i} = counter2_12{i} + 1;
                   end
               end
           end
       end
       if(imgProp2{i}(j).Area >= 200 && imgProp2{i}(j).Eccentricity >= 0.8)
           counter2_13{i} = counter2_13{i} + 1;
           if(imgProp2{i}(j).Area >= 200 && imgProp2{i}(j).Eccentricity >=0.85)
               counter2_14{i} = counter2_14{i} + 1;
               if(imgProp2{i}(j).Area >= 200 && imgProp2{i}(j).Eccentricity >=0.9)
                   counter2_15{i} = counter2_15{i} + 1;
                   if(imgProp2{i}(j).Area >= 200 && imgProp2{i}(j).Eccentricity >=0.95)
                       counter2_16{i} = counter2_16{i} + 1;
                   end
               end
           end
       end
    end
end

for i=1:N
        if counter2_1{i} == 0
            total2{1} = total2{1} + 1;
        end 
        if counter2_2{i} == 0
            total2{2} = total2{2} + 1; 
        end
        if counter2_3{i} == 0
            total2{3} = total2{3} + 1;
        end
        if counter2_4{i} == 0
            total2{4} = total2{4} + 1;
        end
        if counter2_5{i} == 0
            total2{5} = total2{5} + 1;
        end
        if counter2_6{i} == 0
            total2{6} = total2{6} + 1;
        end
        if counter2_7{i} == 0
            total2{7} = total2{7} + 1;
        end
        if counter2_8{i} == 0
            total2{8} = total2{8} + 1;
        end
        if counter2_9{i} == 0
            total2{9} = total2{9} + 1;
        end
        if counter2_10{i} == 0
            total2{10} = total2{10} + 1;
        end
        if counter2_11{i} == 0
            total2{11} = total2{11} + 1;
        end
        if counter2_12{i} == 0
            total2{12} = total2{12} + 1;
        end
        if counter2_13{i} == 0
            total2{13} = total2{13} + 1;
        end
        if counter2_14{i} == 0
            total2{14} = total2{14} + 1;
        end
        if counter2_15{i} == 0
            total2{15} = total2{15} + 1;
        end
        if counter2_16{i} == 0
            total2{16} = total2{16} + 1;
        end
end
%% Total Accuracy Crack
Accuracy_Info = {};
akutasi2 = {};
totalAccuracy_Info = {};
for i=1:16
    Accuracy_Info{i} = total{i}/N;
    Accuracy_CNN{i} = total2{i}/N;
end
for i=1:16
   totalAccuracy_Info{i} = (Accuracy_Info{i}+Accuracy_CNN{i})/2; 
end
%% Write to Excel
filename = '2crackDetection1.xlsx';
kriteria1 = {'>=50','>=50','>=50','>=50','>=100','>=100','>=100','>=100','>=150','>=150','>=150','>=150','>=200','>=200','>=200','>=200'};
kriteria2 = {'>=0.80','>=0.85','>=0.90','>=0.95','>=0.80','>=0.85','>=0.90','>=0.95','>=0.80','>=0.85','>=0.90','>=0.95','>=0.80','>=0.85','>=0.90','>=0.95'};
headers = {'Area','Eccentricity','Accuracy of crack detection','Accuracy of non-crack detection', 'Overall Accuracy'};
data = [Accuracy_Info];
data2 = [Accuracy_CNN];
data3 = [totalAccuracy_Info];
xlswrite(filename,headers,'Sheet1','A1');
xlswrite(filename,data.','Sheet1','C2');
xlswrite(filename,data2.','Sheet1','D2');
xlswrite(filename,data3.','Sheet1','E2');
xlswrite(filename,kriteria1.','Sheet1','A2');
xlswrite(filename,kriteria2.','Sheet1','B2');
%% Write to Excel
filename = 'imgProp2.xlsx';
for i=1:N
   data = [areaProp2{i},eccentricityProp2{i},majorAxisProp2{i},minorAxisProp2{i}];
   headers = {'Area','Eccentricity','MajorAxisLength','MinorAxisLength'};
   xlswrite(filename,headers,i,'A1');
   xlswrite(filename,data,i,'A2');
end
net = vgg16()
net.Layers
sz = net.Layers(1).InputSize
I = I(1:sz(1),1:sz(2),1:sz(3));
s = classifyvgg16(imgBw{1},'centroid');
centroids = cat(1, s.Centroid);
axes(handles.axes4);  imshow(imgBw{1})
hold on
plot(centroids(:,1),centroids(:,2), 'b*')
hold off


 
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 

 

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1); cla(handles.axes1); title(''); axis off
axes(handles.axes2); cla(handles.axes2); title(''); axis off
axes(handles.axes3); cla(handles.axes3); title(''); axis off
axes(handles.axes4); cla(handles.axes4); title(''); axis off
set(handles.edit1,'String','--');
set(handles.edit2,'String','--');
set(handles.edit3,'String','--');
set(handles.edit4,'String','--');
set(handles.edit5,'String','--');
set(handles.edit6,'String','--');
set(handles.edit7,'String','--');
set(handles.edit8,'String','--');
set(handles.edit9,'String','--');
set(handles.edit10,'String','--');
set(handles.edit11,'String','--');
set(handles.edit12,'String','--');
set(handles.edit13,'String','--');
set(handles.edit14,'String','--');
set(handles.edit15,'String','--');
set(handles.edit16,'String','--');
set(handles.edit17,'String','--');
set(handles.edit18,'String','--');
set(handles.edit19,'String','--');
set(handles.edit20,'String','--');
set(handles.edit21,'String','--');
set(handles.edit22,'String','--');
set(handles.edit23,'String','--');
set(handles.edit24,'String','--');
 
clc
clear all


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run('Analysiss.p');
s = serial('com14');
        fopen(s);
        fwrite(s,'AA');
        pause(2);
fwrite(s,'AA');
        pause(2);
        fclose(s);
        clear s


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double


% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
