function varargout = telosim(varargin)
% TELOSIM M-file for telosim.fig
%      TELOSIM, by itself, creates a new TELOSIM or raises the existing
%      singleton*.
%
%      H = TELOSIM returns the handle to a new TELOSIM or the handle to
%      the existing singleton*.
%
%      TELOSIM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TELOSIM.M with the given input arguments.
%
%      TELOSIM('Property','Value',...) creates a new TELOSIM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before telosim_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to telosim_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help telosim

% Last Modified by GUIDE v2.5 27-Feb-2010 15:10:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @telosim_OpeningFcn, ...
                   'gui_OutputFcn',  @telosim_OutputFcn, ...
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


% --- Executes just before telosim is made visible.
function telosim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to telosim (see VARARGIN)

% Choose default command line output for telosim
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes telosim wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = telosim_OutputFcn(hObject, eventdata, handles) 
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

zy_dist1=[216.726800000000,0.0283453900000000;211.952800000000,0.00214546900000000;204.792600000000,0.00564354600000000;200.020800000000,0;195.248900000000,0.00508221300000000;190.479100000000,0.00897027800000000;185.705200000000,0.00263145800000000;178.549500000000,0.0134510500000000;171.389600000000,0.0331386600000000;164.233800000000,0.0401106900000000;157.076000000000,0.0634996500000000;147.532300000000,0.0702329000000000;140.374500000000,0.0799557300000000;133.214300000000,0.114518000000000;126.056500000000,0.107466000000000;111.743300000000,0.0803695800000000;104.583100000000,0.0827175100000000;97.4232200000000,0.0724903900000000;90.2696100000000,0.0633682600000000;83.1097100000000,0.0510616200000000;78.3378400000000,0.0288199700000000;71.1800300000000,0.00588319100000000;64.0222300000000,0.00411514200000000;56.8644300000000,0.00546845600000000;47.3183300000000,0.00546031800000000;40.1626200000000,0.00596968400000000;33.0048200000000,0.00350297700000000;25.8470200000000,0.00246724700000000;18.6892100000000,0.00109940600000000;11.5314100000000,0.00187801700000000;1.98766900000000,0.00184553200000000;-5.17249200000000,0.00176034700000000;-14.7138700000000,0.00455145500000000;-21.8740300000000,0.00197992900000000;]
zy_dist2=[183.319226000000,0.0124079032705275;176.161400000000,0.0197451497745071;169.003574000000,0.0320619374436991;161.847945000000,0.0433222031621792;154.687922000000,0.0486325175861051;147.532293000000,0.0647330767400168;140.374467000000,0.0736831005916094;133.214444000000,0.0797823740415325;128.444757000000,0.0635000628888216;118.898792000000,0.0867575541595297;109.357221000000,0.0728902745018079;102.197198000000,0.0659091321961011;92.6556270000001,0.0575344093092525;85.4956039999997,0.0544802201475070;73.5658939999998,0.0386960581361490;66.4080679999997,0.0454385680578785;56.8643000000002,0.0423968270525287;49.7042769999998,0.0192440808328179;40.1627059999996,0.0144672094726311;33.0048800000000,0.0122199439099446;16.3032860000003,0.0156184689144087;21.0751699999996,0.0129964547795460;13.9173440000000,0.0101022550742455;6.75951799999984,0.0126667736598896;-2.78644699999995,0.000713444296764089;]
zy_dist3=[166.617632000000,0.00941928600286524;157.076061000000,0.00965618658599302;145.146351000000,0.00389811745490060;137.988525000000,0.0131323455052710;128.444757000000,0.0292955450852193;121.284734000000,0.0222982969667814;114.129105000000,0.0197096776565965;104.583140000000,0.0193177473690114;97.4231170000003,0.0588903389118723;87.8815460000001,0.0926186499868862;80.7237200000000,0.111908592269318;71.1799520000000,0.0937367694259428;64.0221259999998,0.0743869823770988;56.8643000000002,0.0572306959512288;37.7767640000002,0.0533429470224548;44.9367869999996,0.0489115697301535;37.7767640000002,0.0347896994191676;30.6167410000003,0.0393540989856972;23.4611120000000,0.0401673028011729;16.3032860000003,0.0401423311556668;9.14546000000019,0.0408367546303985;1.98763400000007,0.0217863035057905;-5.17238900000029,0.0326638152866936;-9.94207599999982,0.0184254749792239;-24.2577280000000,0.00560841362366045;-29.0296119999998,0.00847205731093527;]

L1 = str2double(get(handles.input_L1,'String'));
SD1 = str2double(get(handles.input_SD1,'String'));
L2 = str2double(get(handles.input_L2,'String'));
SD2 = str2double(get(handles.input_SD2,'String'));
preCycles = str2double(get(handles.input_preCycles,'String'));
freeCycles = str2double(get(handles.input_freeCycles,'String'));
Limit = str2double(get(handles.input_Limit,'String'));
preActivity2 = str2double(get(handles.input_preActivity2,'String'));
freeActivity2 = str2double(get(handles.input_freeActivity2,'String'));
preActivity3 = str2double(get(handles.input_preActivity3,'String'));
freeActivity3 = str2double(get(handles.input_freeActivity3,'String'));

% [preResult1,Result1,preResult2,Result2,preResult3,Result3]=...
%     zhaoy_gui(L1,SD1,L2,SD2,preCycles,freeCycles,Limit,preActivity2,freeActivity2,preActivity3,freeActivity3)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%below is a nearly copy of zhaoy_gui.m:
N=100000;

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%for 100% activity case:
telomeres=zeros(N,1);

%%%elongation step 1 by pre-positioning telomerase:
ran=randn(N,1);
for cycle=1:preCycles
    for i=1:N
        if telomeres(i)<Limit
            telomeres(i)=telomeres(i)+(L1+SD1.*ran(i));
        end
    end
end
[n1,xout1]=hist(telomeres,0:5:200);
preResult1=[xout1;n1/max(n1)]

%%%elongation step 2 by free telomerase:
ran=randn(N,1);
for cycle=1:freeCycles
    for i=1:N
        if telomeres(i)<Limit
            telomeres(i)=telomeres(i)+(L2+SD2.*ran(i));
        end
    end
end
[n2,xout2]=hist(telomeres,0:5:200);
Result1=[xout2;n2/max(n2)]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%for 40%(apparent) activity case:
telomeres=zeros(N,1);

%%%elongation step 1 by pre-positioning telomerase:
for cycle=1:preCycles
    ran1=rand(N,1);
    ran2=randn(N,1);
    for i=1:N
        if ran1(i)<=preActivity2 && telomeres(i)<Limit
            telomeres(i)=telomeres(i)+(L1+SD1.*ran2(i));
        end
    end
end
[n1,xout1]=hist(telomeres,0:5:200);
preResult2=[xout1;n1/max(n1)]

%%%elongation step 2 by free telomerase:
for cycle=1:freeCycles
    ran1=rand(N,1);
    ran2=randn(N,1);
    for i=1:N
        if ran1(i)<=freeActivity2 && telomeres(i)<Limit
            telomeres(i)=telomeres(i)+(L2+SD2.*ran2(i));
        end
    end
end
[n2,xout2]=hist(telomeres,0:5:200);
Result2=[xout2;n2/max(n2)]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%for 10%(apparent) activity case:
telomeres=zeros(N,1);

%%%elongation step 1 by pre-positioning telomerase:
for cycle=1:preCycles
    ran1=rand(N,1);
    ran2=randn(N,1);
    for i=1:N
        if ran1(i)<=preActivity3 && telomeres(i)<Limit
            telomeres(i)=telomeres(i)+(L1+SD1.*ran2(i));
        end
    end
end
[n1,xout1]=hist(telomeres,0:5:200);
preResult3=[xout1;n1/max(n1)]

%%%elongation step 2 by free telomerase:
for cycle=1:freeCycles
    ran1=rand(N,1);
    ran2=randn(N,1);
    for i=1:N
        if ran1(i)<=freeActivity3 && telomeres(i)<Limit
            telomeres(i)=telomeres(i)+(L2+SD2.*ran2(i));
        end
    end
end
[n2,xout2]=hist(telomeres,0:5:200);
Result3=[xout2;n2/max(n2)]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(handles.axes1,'NextPlot','replace')
plot(handles.axes1,zy_dist1(:,1),zy_dist1(:,2)/max(zy_dist1(:,2)),'ko')
set(handles.axes1,'NextPlot','add')
plot(handles.axes1,preResult1(1,:),preResult1(2,:),'y') % Plot into the proper axes
set(handles.axes1,'NextPlot','add')
plot(handles.axes1,Result1(1,:),Result1(2,:),'r') % Plot into the proper axes

set(handles.axes2,'NextPlot','replace')
plot(handles.axes2,zy_dist2(:,1),zy_dist2(:,2)/max(zy_dist2(:,2)),'ko')
set(handles.axes2,'NextPlot','add')
plot(handles.axes2,preResult2(1,:),preResult2(2,:),'y') % Plot into the proper axes
set(handles.axes2,'NextPlot','add')
plot(handles.axes2,Result2(1,:),Result2(2,:),'r') % Plot into the proper axes

set(handles.axes3,'NextPlot','replace')
plot(handles.axes3,zy_dist3(:,1),zy_dist3(:,2)/max(zy_dist3(:,2)),'ko')
set(handles.axes3,'NextPlot','add')
plot(handles.axes3,preResult3(1,:),preResult3(2,:),'y') % Plot into the proper axes
set(handles.axes3,'NextPlot','add')
plot(handles.axes3,Result3(1,:),Result3(2,:),'r') % Plot into the proper axes


function input_L1_Callback(hObject, eventdata, handles)
% hObject    handle to input_L1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_L1 as text
%        str2double(get(hObject,'String')) returns contents of input_L1 as a double


% --- Executes during object creation, after setting all properties.
function input_L1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_L1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_SD1_Callback(hObject, eventdata, handles)
% hObject    handle to input_SD1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_SD1 as text
%        str2double(get(hObject,'String')) returns contents of input_SD1 as a double


% --- Executes during object creation, after setting all properties.
function input_SD1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_SD1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_L2_Callback(hObject, eventdata, handles)
% hObject    handle to input_L2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_L2 as text
%        str2double(get(hObject,'String')) returns contents of input_L2 as a double


% --- Executes during object creation, after setting all properties.
function input_L2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_L2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_SD2_Callback(hObject, eventdata, handles)
% hObject    handle to input_SD2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_SD2 as text
%        str2double(get(hObject,'String')) returns contents of input_SD2 as a double


% --- Executes during object creation, after setting all properties.
function input_SD2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_SD2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_preCycles_Callback(hObject, eventdata, handles)
% hObject    handle to input_preCycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_preCycles as text
%        str2double(get(hObject,'String')) returns contents of input_preCycles as a double


% --- Executes during object creation, after setting all properties.
function input_preCycles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_preCycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_freeCycles_Callback(hObject, eventdata, handles)
% hObject    handle to input_freeCycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_freeCycles as text
%        str2double(get(hObject,'String')) returns contents of input_freeCycles as a double


% --- Executes during object creation, after setting all properties.
function input_freeCycles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_freeCycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_Limit_Callback(hObject, eventdata, handles)
% hObject    handle to input_Limit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_Limit as text
%        str2double(get(hObject,'String')) returns contents of input_Limit as a double


% --- Executes during object creation, after setting all properties.
function input_Limit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_Limit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_preActivity2_Callback(hObject, eventdata, handles)
% hObject    handle to input_preActivity3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_preActivity3 as text
%        str2double(get(hObject,'String')) returns contents of input_preActivity3 as a double


% --- Executes during object creation, after setting all properties.
function input_preActivity2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_preActivity3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_freeActivity2_Callback(hObject, eventdata, handles)
% hObject    handle to input_freeActivity3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_freeActivity3 as text
%        str2double(get(hObject,'String')) returns contents of input_freeActivity3 as a double


% --- Executes during object creation, after setting all properties.
function input_freeActivity2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_freeActivity3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_preActivity3_Callback(hObject, eventdata, handles)
% hObject    handle to input_preActivity3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_preActivity3 as text
%        str2double(get(hObject,'String')) returns contents of input_preActivity3 as a double


% --- Executes during object creation, after setting all properties.
function input_preActivity3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_preActivity3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_freeActivity3_Callback(hObject, eventdata, handles)
% hObject    handle to input_freeActivity3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_freeActivity3 as text
%        str2double(get(hObject,'String')) returns contents of input_freeActivity3 as a double


% --- Executes during object creation, after setting all properties.
function input_freeActivity3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_freeActivity3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


