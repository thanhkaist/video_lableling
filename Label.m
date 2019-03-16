
function varargout = Label(varargin)
% LABEL MATLAB code for Label.fig
%      LABEL, by itself, creates a new LABEL or raises the existing
%      singleton*.
%
%      H = LABEL returns the handle to a new LABEL or the handle to
%      the existing singleton*.
%
%      LABEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LABEL.M with the given input arguments.
%
%      LABEL('Property','Value',...) creates a new LABEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Label_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Label_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Label

% Last Modified by GUIDE v2.5 05-Mar-2019 17:35:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Label_OpeningFcn, ...
    'gui_OutputFcn',  @Label_OutputFcn, ...
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

% --- Executes just before Label is made visible.
function Label_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Label (see VARARGIN)

% Choose default command line output for Label
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Label wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = Label_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

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

% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data = get(hObject,'UserData');
video_file_name =0;
video_file_path =0;
if isempty(data)
    [ video_file_name,video_file_path ] = uigetfile({'*.avi;*.mp4'},'Pick a video file');
else
    video_file_name = data.fname;
    video_file_path = strcat(data.fpath,'\');
    set(hObject,'UserData','')
end

if(video_file_path == 0)
    return;
end





input_video_file = [video_file_path,video_file_name];
set(handles.edit1,'String',input_video_file);
[pathstr,name,ext] = fileparts(input_video_file); %get file name to view the title windows
set(handles.figure1,'NumberTitle','off','Name',['Label for Medical Project           File name: ' name ext]);
disp(['Opening file: ' name ext]);
% Acquiring video
clear handles.videoObject
videoObject = VideoReader(input_video_file);
% Display first frame
frame_1 = read(videoObject,1);
axes(handles.axes1);
h = imshow(frame_1);
drawnow;
axis(handles.axes1,'off');

% Display Frame Number
set(handles.text4,'String',['Frame: ',num2str(1),'/',num2str(videoObject.NumberOfFrames)]);
%set(handles.text2,'Visible','on');
%Update handles
handles.videoObject=videoObject; handles.current_frame=1; handles.h=h;
handles.newframe=1; handles.oldframe=1; handles.N=videoObject.NumberOfFrames;
handles.filepath = name;
global act_y act_x label fr;

% Load result file
resultFile = strcat(name,'.mat'); %'Class3_000001.mat'
if (exist(resultFile,'file'))
    %label = load(resultFile,'label');
    %fr = load(resultFile,'fr');
    load(resultFile);
    act_y = (label > 0)'; act_x = (fr/handles.N)';
    table = [label fr/30]; set(handles.uitable1,'Data',table); %show to table
    stem(handles.axes2,[0 act_x 1],[0 act_y 0]);
    set(handles.axes2,'xtick',[],'ytick',[]);
else
    act_y = []; act_x = []; label = []; fr =[];
    stem(handles.axes2,[]); set(handles.axes2,'xtick',[],'ytick',[]);
    set(handles.uitable1,'Data',[]);
end


set(handles.playpause,'Enable','on');
set(handles.slider1,'Enable','on');
set(handles.slider1,'Visible','on');
set(handles.axes2,'Visible','on');
set(handles.uitable1,'Enable','on');

guidata(hObject,handles);

% --- Executes on button press in add.
function add_Callback(hObject, eventdata, handles)
% hObject    handle to add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%set(handles.edit_label,'String',handles.current_frame);
global act_y act_x label fr;
if ~isempty(get(handles.edit_label,'String'))
    act_y = [act_y 1]; act_x = [act_x handles.current_frame/handles.N];
    label = [label; str2num(get(handles.edit_label,'String'))];
    fr = [fr; handles.current_frame];
    table = [label fr/30]; set(handles.uitable1,'Data',table); %show to table
    
    guidata(hObject,handles);
    stem(handles.axes2,[0 act_x 1],[0 act_y 0]);
    set(handles.axes2,'xtick',[],'ytick',[])
    set(handles.add,'Enable','off');
    set(handles.edit_label,'Enable','off');
else
    disp('Please input label 1,2,3,4 or 5 before adding!')
end

%handles.newframe=randi(1000,1); guidata(hObject,handles); % update handles
%tmp = get(handles.slider1,'Value');
%set(handles.text_save,'String',floor(tmp*handles.N));


% --- Executes on button press in playpause.
function playpause_Callback(hObject, eventdata, handles)
% hObject    handle to playpause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%global act_x act_y; % clear the marked points of axes plotted
if(strcmp(get(handles.playpause,'String'),'Pause to add label'))
    set(handles.playpause,'String','Play');
    set(handles.add,'Enable','on');
    set(handles.edit_label,'Enable','on');
    set(handles.edit_label,'String','');
    %    uicontrol(handles.edit_label);
    uiwait();
else
    set(handles.playpause,'String','Pause to add label');
    set(handles.add,'Enable','off');
    set(handles.edit_label,'Enable','off');
    uiresume();
end
if handles.videoObject.NumberOfFrames==handles.current_frame || handles.current_frame == 1
    handles.newframe = 1; guidata(hObject,handles); % update handles
    if get(handles.slider1,'Value')==1
        set(handles.slider1,'Value',0);
    end
    play_Video(hObject,eventdata,handles,handles.videoObject);
end

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(gca,'xtick',[],'ytick',[]);

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function edit_label_Callback(hObject, eventdata, handles)
% hObject    handle to edit_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%add_Callback(handles.add, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit_label_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2

% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function play_Video(hObject,eventdata,handles,videoObject)
%play video
set(handles.next,'Enable','off');
set(handles.save,'Enable','off');
set(handles.delete,'Enable','off');
set(handles.browse,'Enable','off');
frameCount = handles.newframe;
N = videoObject.NumberOfFrames;
dem=0;
while(1)
    %handles.newframe = str2num(get(handles.text_save,'String'));
    handles.newframe=max(1,floor(get(handles.slider1,'Value')*N));
    if handles.oldframe ~= handles.newframe
        frameCount = handles.newframe;
        handles.oldframe = handles.newframe;
        dem = 0;
    end
    handles.current_frame = frameCount;
    guidata(hObject,handles); %Update handles
    set(handles.text4,'String',['Frame: ',num2str(frameCount),'/',num2str(N)]);
    set(handles.text6,'String',['(',num2str(floor(frameCount/30)),'s / ',num2str(floor(N/30)),'s)']);
    frame = read(videoObject,frameCount);
    set(handles.h,'Cdata',frame);
    pause(0.03)
    dem = dem+1;
    if mod(dem,30)==0 || frameCount==N
        %sliderVal = frameCount/N;
        set(handles.slider1,'Value',frameCount/N); %update slider value
    end
    frameCount = frameCount+1; %handles.newframe
    if frameCount>N
        break;
    end
end
set(handles.playpause,'String','Play');
set(handles.save,'Enable','on');
set(handles.browse,'Enable','on');

% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(gca,'xtick',[],'ytick',[]);
% Hint: place code in OpeningFcn to populate axes2

% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
if isempty(eventdata.Indices)
    set(handles.delete,'Enable','off');
else
    set(handles.delete,'Enable','on');
    handles.selected_cell = eventdata.Indices;
    guidata(hObject,handles);
end

% --- Executes on button press in delete.
function delete_Callback(hObject, eventdata, handles)
% hObject    handle to delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
M = handles.selected_cell(1);
global act_y act_x label fr;
act_y(M) = []; act_x(M) = [];
label(M) = [];
fr(M) = [];
table = [label fr/30]; set(handles.uitable1,'Data',table); %show to table

stem(handles.axes2,[0 act_x 1],[0 act_y 0]);
set(handles.axes2,'xtick',[],'ytick',[])

% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label fr;
save([handles.filepath '.mat'],'label','fr');
set(handles.next,'Enable','on');
disp(['Saved to file: ' handles.filepath '.mat']);
if length(handles.filepath)>20
    set(handles.text_save,'String',['Saved to: ' handles.filepath(1:3) '...' handles.filepath((end-15):end) '.mat']);
else
    set(handles.text_save,'String',['Saved to: ' handles.filepath '.mat']);
end


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
ed = eventdata;
hd = handles;
disp(eventdata.Key);
fastforward = 0.02;
if strcmp(eventdata.Key, 'space')
    hO = hd.playpause;
    en =get(hO,'Enable');
    if (strcmp(en,'on'))
        playpause_Callback(hO, ed, hd);
    else
        disp('Play button disabled');
        
    end
    return
end
if strcmp(eventdata.Key, 's')
    hO = hd.save;
    en =get(hO,'Enable');
    if (strcmp(en,'on'))
        save_Callback(hO, ed, hd);
    else
        disp('Save button disabled');
    end
    return
end


if strcmp(eventdata.Key, 'leftarrow')
    hO = hd.slider1;
    en =get(hO,'Enable');
    if (strcmp(en,'on'))
        old = get(hO,'Value');
        new = old - 0.01;
        if new > 0
            set(hO,'Value',new);
        else
            set(hO,'Value',0);
        end
    else
        disp('Slide1 button disabled');
    end
    return
end

if strcmp(eventdata.Key, 'rightarrow')
    hO = hd.slider1;
    en =get(hO,'Enable');
    if (strcmp(en,'on'))
        old = get(hO,'Value');
        new = old + 0.01;
        if new < 1
            set(hO,'Value',new);
        else
            set(hO,'Value',1);
        end
    else
        disp('Slide1 is disabled');
    end
    return
end


if strcmp(eventdata.Key, 'b')
    hO = hd.browse;
    en =get(hO,'Enable');
    if (strcmp(en,'on'))
        browse_Callback(hO, ed, hd);
    else
        disp('browse button disabled');
    end
    return
end

if strcmp(eventdata.Key, '1')
    hO = hd.add;
    
    en =get(hd.edit_label,'Enable');
    if (strcmp(en,'off'))
        disp('video does not pause');
        return
    end
    en =get(hO,'Enable');
    
    
    if (strcmp(en,'on'))
        set(hd.edit_label,'String','1');
        add_Callback(hO, ed, hd);
    else
        disp('Add button button disabled');
    end
    return
end

if strcmp(eventdata.Key, '2')
    hO = hd.add;
    en =get(hd.edit_label,'Enable');
    if (strcmp(en,'off'))
        disp('video does not pause');
        return
    end
    en =get(hO,'Enable');
    
    if (strcmp(en,'on'))
        set(hd.edit_label,'String','3');
        add_Callback(hO, ed, hd);
    else
        disp('Add button button disabled');
    end
    return
end

if strcmp(eventdata.Key, '3')
    hO = hd.add;
    
    en =get(hd.edit_label,'Enable');
    if (strcmp(en,'off'))
        disp('video does not pause');
        return
    end
    en =get(hO,'Enable');
    if (strcmp(en,'on'))
        set(hd.edit_label,'String','2');
        add_Callback(hO, ed, hd);
    else
        disp('Add button button disabled');
    end
    return
end

if strcmp(eventdata.Key, '4')
    hO = hd.add;
    en =get(hd.edit_label,'Enable');
    if (strcmp(en,'off'))
        disp('video does not pause');
        return
    end
    en =get(hO,'Enable');
    if (strcmp(en,'on'))
        set(hd.edit_label,'String','4');
        add_Callback(hO, ed, hd);
    else
        disp('Add button button disabled');
    end
    return
end

if strcmp(eventdata.Key, '5')
    hO = hd.add;
    
    en =get(hd.edit_label,'Enable');
    if (strcmp(en,'off'))
        disp('video does not pause');
        return
    end
    en =get(hO,'Enable');
    if (strcmp(en,'on'))
        set(hd.edit_label,'String','5');
        add_Callback(hO, ed, hd);
    else
        disp('Add button button disabled');
    end
    return
end


if strcmp(eventdata.Key, 'e')
    hO = hd.slider1;
    en =get(hO,'Enable');
    if (strcmp(en,'on'))
        set(hO,'Value',1);
    else
        disp('Slide1 is disabled');
    end
    return
end

if strcmp(eventdata.Key, 'p')
    hO = hd.browse;
    en =get(hO,'Enable');
    if (strcmp(en,'on'))
        [filepath,name,ext] = fileparts(get(hd.edit1,'String'));
        names = dir( strcat(filepath,'/*.avi'));
        ind = 1 ;
        
        fileName = strcat(name,ext);
        for i = 1:length(names)
            if strcmp(fileName,names(i).name)
                ind = i;
            end
        end
        if ind >= 1
            if ind <length(names)
                ind = ind +1;
            end
        end
        
        data.hack = 'hack';
        data.fname = names(ind).name;
        data.fpath = filepath;
        set(hO,'UserData',data);
        browse_Callback(hO, ed, hd);
    else
        disp('browse button disabled');
    end
    return
end


disp('Key is not supported');

