function varargout = Codes(varargin)
% Codes M-file for Codes.fig
%      Codes, by itself, creates a new Codes or raises the existing
%      singleton*.
%
%      H = Codes returns the handle to a new Codes or the handle to
%      the existing singleton*.
%
%      Codes('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Codes.M with the given input arguments.
%
%      Codes('Property','Value',...) creates a new Codes or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EPANET_Functions_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Codes_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Codes

% Last Modified by GUIDE v2.5 05-May-2012 14:28:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Codes_OpeningFcn, ...
                   'gui_OutputFcn',  @Codes_OutputFcn, ...
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


% --- Executes just before Codes is made visible.
function Codes_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Codes (see VARARGIN)

% Choose default command line output for lbox2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

if nargin == 3,
initial_dir=strcat(pwd,'\usercode');
elseif nargin > 4
    if strcmpi(varargin{1},'dir')
        if exist(varargin{2},'dir')
            initial_dir = varargin{2};
        else
            errordlg('Input argument must be a valid directory','Input Argument Error!')
            return
        end
    else
        errordlg('Unrecognized input argument','Input Argument Error!');
        return;
    end
end

handles.dir_path = initial_dir;

% Update handles structure
guidata(hObject, handles);


set(handles.figure1,'position',[80 30 59.3 13]);

% Populate the listbox
guide_Callback(hObject, eventdata, handles) 
% Return figure handle as first output argument
% load_listbox2(pwd,handles)

% UIWAIT makes lbox2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
mfiles_Callback(hObject, eventdata, handles) 

% --- Outputs from this function are returned to the command line.
function varargout = Codes_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

get(handles.figure1,'SelectionType');
if strcmp(get(handles.figure1,'SelectionType'),'open')
    index_selected = get(handles.listbox2,'Value');
    file_list = get(handles.listbox2,'String');
    filename = file_list{index_selected};
    if  handles.is_dir(handles.sorted_index(index_selected))
        cd (filename)
        load_listbox(pwd,handles)
    else
        [path,name,ext,ver] = fileparts(filename);
        switch ext
            case '.fig'
                guide (filename)
            otherwise
                try
                    open(filename)
                catch
                    errordlg(lasterr,'File Type Error','modal')
                end
        end
    end
end
% ------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%constant

allfunctions =(get(handles.listbox2,'String'));
count = (get(handles.listbox2,'Value'));

v = char(allfunctions(count));

s=length(v);
k = s-2;
b = v(1:k);
% t = strncmpi(v, 'EN_', 3); %elegxoume ta 3 prwta grammata
p = strcmp(v(k:length(v)),'fig');

if p==0

    open(b)    %run(b)

else           %else if p~=0
    
    b = v(1:length(v)-4);
    guide(b)
        
end
% else
%     
%     msgbox('Is not run. Run only start with EN_!');
% end




% --- Executes on button press in mfiles.
function mfiles_Callback(hObject, eventdata, handles)
% hObject    handle to mfiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dir_struct = dir(strcat(handles.dir_path,'\*.m'));
[sorted_names,sorted_index] = sortrows({dir_struct.name}');
handles.file_names = sorted_names;
handles.is_dir = [dir_struct.isdir];
handles.sorted_index = sorted_index;
guidata(handles.figure1,handles)
set(handles.listbox2,'String',handles.file_names,...
	'Value',1);



% --- Executes on button press in guide.
function guide_Callback(hObject, eventdata, handles)
%cd (dir_path)
dir_struct = dir(strcat(handles.dir_path,'\*.fig'));
[sorted_names,sorted_index] = sortrows({dir_struct.name}');
handles.file_names = sorted_names;
handles.is_dir = [dir_struct.isdir];
handles.sorted_index = sorted_index;
% Update handles structure
guidata(hObject, handles);

set(handles.listbox2,'String',handles.file_names,...
	'Value',1);
% set(handles.text1,'String',pwd)

