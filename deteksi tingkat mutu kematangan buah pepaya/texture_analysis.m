function varargout = texture_analysis(varargin)
% TEXTURE_ANALYSIS MATLAB code for texture_analysis.fig
%      TEXTURE_ANALYSIS, by itself, creates a new TEXTURE_ANALYSIS or raises the existing
%      singleton*.
%
%      H = TEXTURE_ANALYSIS returns the handle to a new TEXTURE_ANALYSIS or the handle to
%      the existing singleton*.
%
%      TEXTURE_ANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEXTURE_ANALYSIS.M with the given input arguments.
%
%      TEXTURE_ANALYSIS('Property','Value',...) creates a new TEXTURE_ANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before texture_analysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to texture_analysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help texture_analysis

% Last Modified by GUIDE v2.5 29-May-2022 23:26:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @texture_analysis_OpeningFcn, ...
                   'gui_OutputFcn',  @texture_analysis_OutputFcn, ...
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


% --- Executes just before texture_analysis is made visible.
function texture_analysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to texture_analysis (see VARARGIN)

% Choose default command line output for texture_analysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
movegui(hObject,'center');

% UIWAIT makes texture_analysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = texture_analysis_OutputFcn(hObject, eventdata, handles) 
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

% menampilkan menu "browse image"
[nama_file, nama_folder] = uigetfile('*.jpeg');

% jika ada nama file yg dipilih maka akan mengeksekusi perintah di bawah
% ini
if ~isequal(nama_file,0)
    % membaca file citra rgb
    Img = imread(fullfile(nama_folder,nama_file));
    % menampilkan citra rgb pada axes
    axes(handles.axes1)
    imshow(Img)
    title('RGB Image')
    % menyimpan variabel Img pada lokasi handles agar dapat dipanggil oleh
    % pushbutton yg lain
    handles.Img = Img;
    guidata(hObject, handles)
else    
% jika tidak ada nama file yg dipilih maka akan kembali
return
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% memanggil variabel Img yg ada di lokasi handles
Img = handles.Img;

% mengkonversi citra rgb menjadi citra grayscale
Img_gray = rgb2gray(Img);

% menampilkan citra grayscale pada axes
axes(handles.axes2)
imshow(Img_gray)
title('Grayscale Image')

% membaca pixel distance yg ada pada edit text
pixel_dist = str2double(get(handles.edit1,'String'));
% membentuk matriks kookurensi
GLCM = graycomatrix(Img_gray,'Offset',[0 pixel_dist;...
    -pixel_dist pixel_dist; -pixel_dist 0; -pixel_dist -pixel_dist]);
% mengestrak fitur GLCM
stats = graycoprops(GLCM,{'Contrast','Correlation','Energy','Homogeneity'});

% membaca fitur GLCM
Contrast = stats.Contrast;
Correlation = stats.Correlation;
Energy = stats.Energy;
Homogeneity = stats.Homogeneity;

% menampilkan fitur GLCM pada tabel
data = get(handles.uitable1,'Data');
data{1,1} = num2str(Contrast(1));
data{1,2} = num2str(Contrast(2));
data{1,3} = num2str(Contrast(3));
data{1,4} = num2str(Contrast(4));
data{1,5} = num2str(mean(Contrast));

data{2,1} = num2str(Correlation(1));
data{2,2} = num2str(Correlation(2));
data{2,3} = num2str(Correlation(3));
data{2,4} = num2str(Correlation(4));
data{2,5} = num2str(mean(Correlation));

data{3,1} = num2str(Energy(1));
data{3,2} = num2str(Energy(2));
data{3,3} = num2str(Energy(3));
data{3,4} = num2str(Energy(4));
data{3,5} = num2str(mean(Energy));

data{4,1} = num2str(Homogeneity(1));
data{4,2} = num2str(Homogeneity(2));
data{4,3} = num2str(Homogeneity(3));
data{4,4} = num2str(Homogeneity(4));
data{4,5} = num2str(mean(Homogeneity));

set(handles.uitable1,'Data',data)



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes1)
cla reset
set(gca,'Xtick',[])
set(gca,'Ytick',[])

axes(handles.axes2)
cla reset
set(gca,'Xtick',[])
set(gca,'Ytick',[])

set(handles.uitable1,'Data',[])
set(handles.edit1,'String','1')


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
